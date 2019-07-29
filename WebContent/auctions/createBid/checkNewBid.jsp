<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
Checks bid's validity then posts it to database
this also emails the previous top poster
and autobid kicks in if enabled
 ------------------------------------------------------------------------------------------------------->


<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Redirecting...</title>
	</head>
<body>

		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><img src="../../images/websiteLogo.png"></p>
		
		
		<!-----------------------------------------------------------------------------------------------
				SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
		<%
		String user_username;
		if(session.getAttribute("user_username") == null){
		   	%>
		   	<script>
		  			alert("User session check failed, please login!");
		  			window.location.href = "../../login.jsp";
		  		</script>
		  		<%
		  		return;
		} else {
				user_username = session.getAttribute("user_username").toString();
		}
		%>	
				
		<!-----------------------------------------------------------------------------------------------
			     						CHECK IF BID IS VALID
		------------------------------------------------------------------------------------------------>		
		<%
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//PARAMETERS
			String thisNewBidder = session.getAttribute("user_username").toString();
			int auctionID = Integer.parseInt(request.getParameter("auctionID"));
			
			double item_currentBid = Double.parseDouble(request.getParameter("item_currentBid")); 
			double bidIncrements = Double.parseDouble(request.getParameter("bidIncrements")); 
			double newBid = Double.parseDouble(request.getParameter("bid_Amount"));
			double newUpperLimit = Double.parseDouble(request.getParameter("bid_Amount"));

			
			if(request.getParameter("bid_UpperLimit") != ""){
				newUpperLimit = Double.parseDouble(request.getParameter("bid_UpperLimit"));
			} 
			
			
			//1. check if 
			    String checkAuction = "SELECT * FROM Auctions a WHERE a.auctionID= '" + auctionID + "'" ;
				ResultSet checkAuctionResult = stmt.executeQuery(checkAuction);

				if(checkAuctionResult.next() == false){
					%> 
					<script> 
					    alert("Error: This auction does not exist.");
					    window.location.href = "../auctionsHome.jsp";
					</script>
					<%
					con.close();
					return;
				}
			
			//2. Check if Auction is still active	
			    String checkActive = "SELECT isActive FROM Auctions WHERE auctionID= '" + auctionID + "'" ;
				ResultSet resActive = stmt.executeQuery(checkAuction);
				resActive.next();
				if (!(resActive.getBoolean("isActive"))){
					%> 
					<script> 
					    alert("Error: This Auction has already ended.");
					    window.location.href = "../auctionsHome.jsp";
					</script>
					<%
					con.close();
					return;
				}
			//3. Check if attempted bid is higher an Auto Upper Limit
				if(newBid > newUpperLimit){
					%> 
					<script> 
					    alert("Error: Bid is higher than the upper limit");
					    window.location.href = "../auctionsHome.jsp";
					</script>
					<%
					con.close();
					return;
				}
			
			//3. Check if attempted bid is lower than current top bid
			if(newBid < item_currentBid){
				String item_currentBidStr = String.format("%.02f", (item_currentBid));
				%> 
				
				<script> 
				    alert("Error: Bid must be at least $<%=item_currentBidStr%>");
				    window.location.href = "../auctionsHome.jsp";
				</script>

				<%
				con.close();
				return;
			}			
				// BID IS VALID, CHECK AUCTION BIDDING STATUS
				//RETURN LIST OF ALL BIDS ON THIS AUCTION
				String checkBids = "SELECT auctionID, bidder, bid_amount, AutoUpperLimit from Bids"
										+ " WHERE auctionID LIKE '" + auctionID + "';";
					
				ResultSet checkBidsRes = stmt.executeQuery(checkBids);
				checkBidsRes.next();

				Calendar cal = Calendar.getInstance();
				java.sql.Timestamp newTimeDate = new java.sql.Timestamp(cal.getTimeInMillis());
				checkBidsRes.beforeFirst();
				//IF THERE IS AT LEAST ONE BID
				if (checkBidsRes.next()){
					//GET INFO ON TOP BID
					String checkTopBid = "SELECT b.auctionID, topBidder, t1.topBid, t2.topBidAutoLimit from Bids b"
							+ " LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid, COUNT(bid_amount) AS numBids"
							+ " FROM Bids GROUP BY auctionID) t1 ON b.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID,"
							+ " bidder AS topBidder, bid_amount, AutoUpperLimit as topBidAutoLimit FROM Bids) t2 ON b.auctionID ="
							+ " t2.auctionID AND topBid = t2.bid_amount WHERE b.auctionID LIKE '" + auctionID + "'"
							+ " GROUP BY b.auctionID;";
		
						ResultSet checkTopBidRes = stmt.executeQuery(checkTopBid);
						checkTopBidRes.next();
						
						String currentTopBidBidder = checkTopBidRes.getString("topBidder");
						double currentTopBidAmount = checkTopBidRes.getDouble("topBid");
						double currentTopBidAutoLimit = checkTopBidRes.getDouble("topBidAutoLimit");
						double nextAutoLimitBid = newBid + bidIncrements;

						
					//IF TOP BID: NO AUTO OR AUTO CANNOT BE FULFILLED, EMAIL THAT BID HAS BEEN BEAT
					//USER: POST BID
					if ((currentTopBidAutoLimit <= currentTopBidAmount) || (nextAutoLimitBid > currentTopBidAutoLimit)){
												
						String insert = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
								+ " VALUES (?, ?, ?, ?)";
						
							PreparedStatement ps = con.prepareStatement(insert);
							ps.setInt(1, auctionID);
							ps.setString(2, thisNewBidder);
							ps.setDouble(3, newBid);
							ps.setDouble(4, newUpperLimit);
							ps.executeUpdate();
							ps.close();
						
						String sendManualEmail = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)" 
								+ " VALUES (?, ?, ?, ?, ?)";
		
							ps = con.prepareStatement(sendManualEmail);
							ps.setString(1, "BuyMyFurnitureAlerts");
							ps.setString(2, currentTopBidBidder);
							ps.setTimestamp(3, newTimeDate);
							ps.setString(4, "You have been outbid!");
							ps.setString(5, "Someone has outbid you on auction #" + auctionID + ". Please visit the auction page to bid again.");
							ps.executeUpdate();
							ps.close();
											
						con.close();

						%>		
						<script> 
						    alert("Success! Your Bid has been posted.");
					    	window.location.href = "../viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp";
						</script>
						<%
						
					//ELSE USER: POSTS BID WITH NO AUTOBID FEATURE
					//TOP BID: TOPBIDUSER WILL AUTOBID TO BEAT YOUR BID
					//EMAIL YOU THAT YOUR BID HAS BEEN BEATEN
					} else if ((newUpperLimit <= newBid) || (newBid + bidIncrements > newUpperLimit)) {
							//YOU: post new bid
							String insert = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
									+ " VALUES (?, ?, ?, ?)";
							
								PreparedStatement ps = con.prepareStatement(insert);
								ps.setInt(1, auctionID);
								ps.setString(2, thisNewBidder);
								ps.setDouble(3, newBid);
								ps.setDouble(4, newUpperLimit);
								ps.executeUpdate();
								ps.close();
								
							//OTHER PERSON: auto bid kicks in
							String insert2 = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
									+ " VALUES (?, ?, ?, ?)";
								
								ps = con.prepareStatement(insert2);
								ps.setInt(1, auctionID);
								ps.setString(2, currentTopBidBidder);
								ps.setDouble(3, nextAutoLimitBid);
								ps.setDouble(4, currentTopBidAutoLimit);
								ps.executeUpdate();	
								ps.close();
								
							//outbid email	
							String sendManualEmail = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)" 
									+ " VALUES (?, ?, ?, ?, ?)";
			
								ps = con.prepareStatement(sendManualEmail);
								ps.setString(1, "BuyMyFurnitureAlerts");
								ps.setString(2, thisNewBidder);
								ps.setTimestamp(3, newTimeDate);
								ps.setString(4, "You have been outbid!");
								ps.setString(5, "Someone has outbid you on auction #" + auctionID + ". Please visit the auction page to bid again.");
								ps.executeUpdate();			
								ps.close();
						
							con.close();
							
							%>		
							<script> 
							    alert("Your Bid has been posted. \n"
							    		+ " ALERT: Someone's autobid has beat your bid!");
						    	window.location.href = "../viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp";
							</script>
							<%
							
						// ELSE AUTO BID VERSUS AUTO BID	
						} else {
							while(								
								//WHILE USER CAN STILL AUTOBID
								(newUpperLimit >= newBid)
								||
								//OR TOPBIDUSER CAN STILL AUTOBID
								(currentTopBidAutoLimit >= nextAutoLimitBid)
								){
								
								
								//IF YOU CAN STILL AUTOBID --> BID
								if (newUpperLimit >= newBid){
									//YOU: post new bid
									String insert = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
										+ " VALUES (?, ?, ?, ?)";
								
										PreparedStatement ps = con.prepareStatement(insert);
										ps.setInt(1, auctionID);
										ps.setString(2, thisNewBidder);
										ps.setDouble(3, newBid);
										ps.setDouble(4, newUpperLimit);
										ps.executeUpdate();
										ps.close();
										
										newBid = newBid + bidIncrements + bidIncrements;
										
									//ELSE YOU WILL BE OUTBID >> SEND EMAIL	
								} else {								
									String sendManualEmail = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)" 
											+ " VALUES (?, ?, ?, ?, ?)";
					
										PreparedStatement ps2 = con.prepareStatement(sendManualEmail);
										ps2.setString(1, "BuyMyFurnitureAlerts");
										ps2.setString(2, thisNewBidder);
										ps2.setTimestamp(3, newTimeDate);
										ps2.setString(4, "You have been outbid!");
										ps2.setString(5, "Someone has outbid you on auction #" + auctionID + ". Please visit the auction page to bid again.");
										ps2.executeUpdate();		
										ps2.close();		
										con.close();
										
										%>		
										<script> 
											alert("Your Bid has been posted. \n"
								    			+ " ALERT: Someone's autobid has beat your bid!");
											window.location.href = "../viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp";
										</script>
										<%
										return;
								}
								
								//IF THEY CAN STILL AUTOBID IN RESPONSE TO YOUR BID
								if  (currentTopBidAutoLimit >= nextAutoLimitBid) {
									String insert2 = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
										+ " VALUES (?, ?, ?, ?)";
									
										PreparedStatement ps = con.prepareStatement(insert2);
										ps.setInt(1, auctionID);
										ps.setString(2, currentTopBidBidder);
										ps.setDouble(3, nextAutoLimitBid);
										ps.setDouble(4, currentTopBidAutoLimit);
										ps.executeUpdate();	
										ps.close();
										
										nextAutoLimitBid = nextAutoLimitBid + bidIncrements + bidIncrements;
									
									//ELSE THEY WILL BE OUTBID >> SEND EMAIL	
									} else {
										String sendManualEmail = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)" 
												+ " VALUES (?, ?, ?, ?, ?)";
						
											PreparedStatement ps = con.prepareStatement(sendManualEmail);
											ps.setString(1, "BuyMyFurnitureAlerts");
											ps.setString(2, thisNewBidder);
											ps.setTimestamp(3, newTimeDate);
											ps.setString(4, "You have been outbid!");
											ps.setString(5, "Someone has outbid you on auction #" + auctionID + ". Please visit the auction page to bid again.");
											ps.executeUpdate();		
											ps.close();		
											con.close();
											
											%>		
											<script> 
										   			alert("Your Bid has been posted!");
										   			window.location.href = "../viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp";
											</script>
											<%
											return;
									}									

							}
					}	

				//no other bids, post bid
				} else {
					String insert = "INSERT INTO Bids (auctionID, bidder, bid_amount, AutoUpperLimit)"
							+ " VALUES (?, ?, ?, ?)";
					
						PreparedStatement ps = con.prepareStatement(insert);
						ps.setInt(1, auctionID);
						ps.setString(2, thisNewBidder);
						ps.setDouble(3, newBid);
						ps.setDouble(4, newUpperLimit);
						ps.executeUpdate();
					ps.close();
					con.close();
					
					%> 
					<script> 
					    alert("You have placed the starting bid on this auction!");
					    window.location.href = "../viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp";
					</script>
					<%
				}
				
					
				
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../viewAuctions/sortedAuctions/viewCurrentAuctions.jsp";
			</script>
			<%	
		}
		%>
		

</body>
</html>