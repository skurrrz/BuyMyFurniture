<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html >
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>		
		<link rel="stylesheet" type="text/css" href="../../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auctions</title>
	</head>
	
<body>
		
		<!-----------------------------------------------------------------------------------------------
					        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../../../home/home.jsp"><img src="../../../images/websiteLogo.png"></a></p> 
		
		
		<!-----------------------------------------------------------------------------------------------
				     QUERIES DATABASE TO RETURN A SORTED LIST OF CURRENT AUCTIONS
		------------------------------------------------------------------------------------------------>		
		<%
		String thisUser = session.getAttribute("user_username").toString();
		
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//QUERY: Get list of all auctions that this user has bid on
			String queryYourAuctions= "SELECT a.*, i.*, t1.*, t2.topBidder FROM Auctions a LEFT JOIN Items i ON a.auctionID"
							+ " = i.auctionID LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid, AutoUpperLimit AS"
							+ " topBidAutoLimit, COUNT(bid_amount) AS numBids FROM Bids GROUP BY auctionID) t1 ON a.auctionID"
							+ " = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON"
							+ " a.auctionID = t1.auctionID AND t1.topBid = t2.bid_amount LEFT JOIN (SELECT auctionID, bidder,"
							+ " bid_amount FROM Bids) t3 ON a.auctionID = t3.auctionID WHERE a.isActive LIKE '1' AND"
							+ " t3.bidder LIKE '" + thisUser + "' GROUP BY a.auctionID ORDER BY a.auctionID ASC;";
				
			ResultSet res = stmt.executeQuery(queryYourAuctions);
			%>
			<!-----------------------------------------------------------------------------------------------
					               IF ANY RESULTS: DISPLAYS ALL RESULTS IN A FORM
			------------------------------------------------------------------------------------------------>	
			<% 	
				if(res.next()) {
					res.beforeFirst();
					out.print("<div class='form'>");	
					%>
					<h1>Active Auctions You Are In</h1>
					<hr>	
					<%
										
					while (res.next()) {
						int auctionID = res.getInt("auctionID");
						out.print("<strong>AuctionID:</strong> #" + auctionID);
						%>
						<br>
						<% 
						out.print("<strong>Auction created by:</strong> " + res.getString("seller"));
						%>
						<br>
						<% 
						out.print("<strong>Title:</strong> " + res.getString("title"));
						%>
						<br>
						<% 
						out.print("<strong>Item Category:</strong> " + res.getString("item_category"));		
						%>
						<br>
						<% 
						if( (res.getDouble("topBid")) >= (res.getDouble("starting_bid")) ){
							out.print("<strong>Current Top Bid:</strong> $" + String.format("%.02f", (res.getDouble("topBid"))));
							%>
							<br>
							<% 
							out.print("<strong>Number of Bids:</strong> " + res.getInt("numBids"));
						} else {
							out.print("<strong>Starting Bid:</strong> $" + String.format("%.02f", (res.getDouble("starting_bid") + 0.00)));
						}
						%>
						<br>
						<% 
						out.print("<strong>Auction Beginning:</strong> " + res.getTimestamp("auction_startDate"));	
						%>
						<br>
						<% 
						out.print("<strong>Auction End:</strong> " + res.getTimestamp("auction_endDate"));	
						%>	
						<br>
						<% 
						if((res.getString("topBidder") != null) && (!res.getString("topBidder").equals(thisUser))){
							%>
							<font color="red"><b>Your bid has been beaten!</b></font>
							<%
						}
						%>	
						<br><br>						
						<form action="../../createBid/createNewBid.jsp" method="get">
							<input type="hidden" name="auctionID" value="<%=auctionID%>"/>
							<input type="submit" value="View Auction"/>
						</form>
						<hr>
						
						<%
					}
					out.print("</div>");
					con.close();
					%>
					
					<div class='form'>
					  	<form>
					 		<button formaction="../../auctionsHome.jsp">Return to Auction Home</button>
						 	<button formaction="../../../home/home.jsp">Return Home</button>
					  	</form>	  	
					</div>				
			<!-----------------------------------------------------------------------------------------------
					                       ELSE: REPORT NO AUCTIONS
			------------------------------------------------------------------------------------------------>				
				
				<% 					
				} else {
					%>
					<div class='form'>
					<%
					out.print("You are currently not participating in any auctions.");	
					%>
					</div>
					<%
					con.close();
				}
				
			} catch (Exception e) {
				%>
				<script>
				alert("Server Error: An unexpected error has occurred. Please try again.");
			    window.location.href = "../../auctionsHome.jsp";
				</script>
				<%
		}		
			%>	
	</body>
	</html>	