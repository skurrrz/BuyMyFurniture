<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!-- 

 -->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auctions</title>
	</head>

<body>	

	<!-----------------------------------------------------------------------------------------------
				        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
	------------------------------------------------------------------------------------------------>
	<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>      	

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
		
	<div class="createNewBid">	
		<!-----------------------------------------------------------------------------------------------
			   		          QUERY DATABASE TO GET INFORMATION ABOUT AUCTION
		------------------------------------------------------------------------------------------------>		
	<% 		
	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();

		String thisAuctionID = request.getParameter("auctionID");

		String itemInfoQuery= "SELECT * FROM Auctions a LEFT JOIN Items i ON a.AuctionID = i.AuctionID"
							+ " LEFT JOIN (SELECT b.auctionID, COUNT(b.bid_amount) AS numBids, MAX(b.bid_amount) AS topBid FROM Bids b"
							+ " WHERE b.auctionID = '" + thisAuctionID + "') t1 ON a.AuctionID = t1.AuctionID"
				  			+ " WHERE a.auctionID LIKE '" + thisAuctionID + "';";			
							
		ResultSet itemInfoRes = stmt.executeQuery(itemInfoQuery);	
		itemInfoRes.next();		
		
		String itemCategory = itemInfoRes.getString("a.item_category");		
		String thisItemType = itemInfoRes.getString("i.item_type");
		java.sql.Timestamp auctionStart = itemInfoRes.getTimestamp("a.auction_startDate");
		double currentTopBid = 0.0;
		double bidIncrements = itemInfoRes.getDouble("a.bid_increments");
		
		%>
		<!-----------------------------------------------------------------------------------------------
   										AUCTION ITEM TABLE
		------------------------------------------------------------------------------------------------>	
		<div class="form">
		<h2>Information About Auction #<%=thisAuctionID%></h2>
			<%			
			out.print("<strong>Auctioned by:</strong> " + itemInfoRes.getString("a.seller"));
			%>
			<br>
			<% 
			out.print("<strong>Title:</strong> " + itemInfoRes.getString("a.title"));
			%>
			<br><br>
			<% 
			out.print("<strong>Item Type:</strong> " + itemInfoRes.getString("i.item_type"));	
			%>
			<br>
			<% 
			out.print("<strong>Manufacturer:</strong> " + itemInfoRes.getString("i.item_manufacturer"));	
			%>
			<br>
			<% 
			out.print("<strong>Condition:</strong> " + itemInfoRes.getString("i.item_condition"));	
			%>
			<br>
			<% 
			out.print("<strong>Color:</strong> " + itemInfoRes.getString("i.item_color"));	
			%>
			<br>
			<% 
			out.print("<strong>Material:</strong> " + itemInfoRes.getString("i.item_material"));	
			%>
			<br>
			<% 
			if(itemCategory.equals("lamp")){
				out.print("<strong>Light Type:</strong> " + itemInfoRes.getString("i.lamp_light_type"));	
				%>
				<br>
				<% 
				out.print("<strong>Number of Bulbs:</strong> " + itemInfoRes.getString("i.lamp_num_bulbs"));	
				%>
				<br><br>
				<% 
			} else if(itemCategory.equals("chair")){
				
				out.print("<strong>Fabric:</strong> " + itemInfoRes.getString("i.chair_fabric"));	
				%>
				<br>
				<% 
				out.print("<strong>Number of Legs:</strong> " + itemInfoRes.getString("i.chair_num_legs"));	
				%>
				<br><br>
				<% 
			} else if(itemCategory.equals("table")){
				out.print("<strong>Shape:</strong> " + itemInfoRes.getString("i.table_shape"));	
				%>
				<br>
				<% 
				out.print("<strong>Number of Legs:</strong> " + itemInfoRes.getString("i.table_num_legs"));	
				%>
				<br><br>
				<% 
			}
			
			if(itemInfoRes.getInt("t1.numBids") > 0){
				out.print("<strong>Current Top Bid:</strong> $" + String.format("%.02f", (itemInfoRes.getDouble("topBid"))));	
				%>
				<br>
			<%
			} else {
				out.print("<strong>Starting Bid:</strong> $" + String.format("%.02f", (itemInfoRes.getDouble("a.starting_bid"))));
				%>
				<br>
				<% 
			}
			out.print("<strong>Minimum Bid Increments: </strong> $" + String.format("%.02f", (itemInfoRes.getDouble("a.bid_increments"))));	
			%>
			<br>
			<% 
			out.print("<strong>Auction Start:</strong> " + itemInfoRes.getTimestamp("a.auction_startDate"));	
			%>
			<br>
			<% 
			out.print("<strong>Auction End:</strong> " + itemInfoRes.getTimestamp("a.auction_endDate"));	
			%>
			<%
			if (session.getAttribute("user_type").toString().equals("rep")){
				%>
				<hr>
				<h3>REP FUNCTIONS:</h3>
					<form action="../repTools/repDeleteAuction.jsp">
						  <input type="hidden" name="delete_auctionID" value="<%=thisAuctionID%>">
						  <input type="submit" value="Delete this Auction" >
						  <p class="message">*This cannot be undone</p>
					</form>
					<hr>
					<form action="../repTools/repEditAuction.jsp">
						  <input type="hidden" name="edit_auctionID" value="<%=thisAuctionID%>">
						  <input type="text" name="edit_auctionTitle" placeholder="****** Write new auction title here ******" style="width:400px" required>
						  <input type="number" name="edit_auctionStartingBid" placeholder="****** Write new starting bid here ******" min = "0.00" 
						  		step = "0.01" maxlength = "10000000.00" style="width:400px" required>
						  <input type="submit" value="Edit this Auction" >
						  
						  <p class="message">*Make any edits, then click submit to update</p>
						  <p class="message">*Title must be less than 50 characters</p>
					</form>		
					<hr>
				<%				
			}
			%>
		</div>
		
		
		<!-----------------------------------------------------------------------------------------------
			   		          QUERY TO FIND CURRENT TOP BID + SUBMIT BID FORM
		------------------------------------------------------------------------------------------------>			
		<%
		//QUERY to get Top Bid for this Auction
		String topBidQuery = "SELECT MAX(bid_amount) AS topBid, auctionID FROM Bids"
						+ " WHERE auctionID LIKE '" + thisAuctionID + "' ORDER"
						+ " BY bid_amount DESC;";					
		ResultSet topBidResult = stmt.executeQuery(topBidQuery);		
		topBidResult.next();
		double item_topBid = topBidResult.getDouble("topBid");
		
		//QUERY TO GET LIST OF TOP BID
		String query= " SELECT * FROM Auctions a LEFT JOIN (SELECT b.auctionID, MAX(b.bid_amount) AS"
						+ " topBid, COUNT(b.bid_amount) AS numBids FROM Bids b WHERE b.auctionID = '" + thisAuctionID + "') t1 ON a.AuctionID = t1.AuctionID"
						+ " WHERE a.auctionID LIKE '" + thisAuctionID + "';";					
		ResultSet res = stmt.executeQuery(query);	
		res.next();	
		double item_currentBid;
	
		//determine the minimum next bid that can be placed		
		if ((res.getInt("numBids")) < 1){
			item_currentBid = res.getDouble("a.starting_bid");
		} else {
			item_currentBid = res.getDouble("topBid") + res.getDouble("a.bid_increments");
		}
		String item_currentBidStr = String.format("%.02f", (item_currentBid));
 		item_currentBid = Double.parseDouble(item_currentBidStr);
 		
		//IF AUCTION IS ACTIVE: SHOW SUBMIT BID FORM
		if(res.getBoolean("a.isActive")){
			%>
			<div class="form">
			<h2>Bid on this Auction!</h2>
			<form action="../createBid/checkNewBid.jsp" method="get">
				<input type="number" placeholder = "Enter Bid Amount (min. $<%=item_currentBidStr%>)" name="bid_Amount" id="bid_Amount" min="0.01" step="0.01" max="10000.00" required/>
				<input type="number" placeholder = "(Optional) Enter Automatic Upper Limit*" name="bid_UpperLimit" id="bid_UpperLimit" value="bid_UpperLimit" min="<%=item_currentBid%>" step="0.01" maxlength="10"/>
				<input type="hidden" name="auctionID" value="<%=thisAuctionID%>"/>
				<input type="hidden" name=item_currentBid value="<%=item_currentBid%>"/>
				<input type="hidden" name=bidIncrements value="<%=bidIncrements%>"/>
				<input type="submit" value="Submit Bid" onclick="validateAutoBid()"/>
				<p class="message">*Upper Limit: If someone places a bid higher than yours, your bid will automatically increment above the new top bid as long as
									it is below your Upper Limit.</p>
				<p class="message">If you select an Upper Limit, please do not exit out of page until the bid has been posted.</p>
			</form>
			</div>
			<%
		} else {
			%>
			<div class="form">
			<h2> This Auction has ended. </h2>
			</div>
			<%		
		}
		
		%>
		
		
		<!-----------------------------------------------------------------------------------------------
			   		          LIST OF ALL BIDS ON THIS AUCTION (DESC)
		------------------------------------------------------------------------------------------------>	
		<%
		//QUERY TO GET LIST OF BID INFO
		String query2= "SELECT * FROM Bids WHERE auctionID LIKE '" + thisAuctionID + "' ORDER"
						+ " BY bid_amount DESC;";
							
		ResultSet res2 = stmt.executeQuery(query2);	
		if(res2.next()){
			int i=1;
			res2.beforeFirst();
			out.print("<div class='form'>");	
			%>
			<h2>Bidding History for Auction #<%=thisAuctionID%></h2>
			<hr>	
			<%
				while (res2.next()) {
					String thisBidder = res2.getString("bidder");
					double thisAmount = Double.parseDouble(res2.getString("bid_amount"));
					
					 if ((i==1)){
						%>
						<h2>Top Bid</h2>
						<%
					} else {
						%>
						<h2>Bid # <%=i%></h2>
						<%
					}
					out.print("<strong>Bidder:</strong> " + thisBidder);
					%>
					<br>
					<% 
					out.print("<strong>Bid Amount:</strong> $" + String.format("%.02f", (res2.getDouble("bid_amount"))));
					
					if (session.getAttribute("user_type").toString().equals("rep")){
						%>
						<hr>
						<h3>REP FUNCTIONS:</h3>
							<form action="../repTools/repDeleteBid.jsp">
								  <input type="hidden" name="delete_Bid_AuctionID" value="<%=thisAuctionID%>">
								  <input type="hidden" name="delete_Bid_Bidder" value="<%=thisBidder%>">
								  <input type="hidden" name="delete_Bid_Bid_Amount" value="<%=thisAmount%>">
								  <input type="submit" value="Delete this Bid" >
								  <p class="message">*This cannot be undone</p>
							</form>
							<hr>
							<form action="../repTools/repEditBid.jsp">
								  <input type="hidden" name="edit_Bid_AuctionID" value="<%=thisAuctionID%>">
								  <input type="hidden" name="edit_Bid_Bidder" value="<%=thisBidder%>">
								  <input type="hidden" name="edit_Bid_Bid_Amount" value="<%=thisAmount%>">
								  <input type="number" name="edit_Bid_New_Bid_Amount" placeholder="****** Edit new Bid Value here ******" min = "0.00" 
								  		step = "0.01" maxlength = "10000000.00" style="width:400px" required>
								  <input type="submit" value="Edit this Bid" >
								  
								  <p class="message">*Make any edits, then click submit to update</p>
								  <p class="message">*Title must be less than 50 characters</p>
							</form>		
							<hr>
						<%				
					}
					%>
					<hr>
					<%
					i++;
				}	
				con.close();
				%>
				<br>
				<br>
		</div>
		<div class='form'>
			<form action="../similarAuctions/viewSimilarAuctions.jsp">
				<input type="hidden" name="thisAuctionID" value="<%=thisAuctionID%>">
				<input type="hidden" name="thisItemType" value="<%=thisItemType%>">
				<input type="hidden" name="auctionStart" value="<%=auctionStart%>">
				<input type="submit" value="View Similar Past Auctions" >
			</form>
		  	<form>
		 		<button formaction="../auctionsHome.jsp">Return to Auction Home</button>
			 	<button formaction="../../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>
		<%
		return;
		} else {
			%>
			<div class='form'>
			<h1>Bidding History for Auction #<%=thisAuctionID%></h1>
			<%
			out.print("There are currently no bids on this auction.");	
			%>
			</div>
			<%
			con.close();
		}
		
   		
    } catch (Exception e) {
		%>
		<script> 
	    alert("Server Error: Please try again");
	    window.location.href = "../auctionsHome.jsp";
		</script>
		<%
	}
		%>
		
		<!-----------------------------------------------------------------------------------------------
			   		         SCRIPT to check if autobid is higher than current bid
		------------------------------------------------------------------------------------------------>	
		<script type="text/javascript">
		    function validateAutoBid()
		    {

		        var value1;
		        var value2;
		        var value3;
		        value1 = parseDouble(document.getElementById('bid_Amount').value);
		        value2 = parseDouble(document.getElementById('bid_UpperLimit').value);
		        if (value1 > value2)
		        {
		            //we're ok
		        }
		        else
		        {
		            alert("Auto Upper Limit cannot be less than current bid amount");
		            return false;
	       		}
	   		 }
		</script>		
		
	
</body>
</html>