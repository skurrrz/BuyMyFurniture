<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date"%>

<!---------------------------------- HOW THIS WORKS -------------------------------------
Step 2 of User Search (see search/searchForUsers.jsp for full details)
	- Checks if user exists, and if does displays user, auctions they have created,
		and bids they have made
 --------------------------------------------------------------------------------------->

<!DOCTYPE html >
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
	<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>
	
	
	<!---------------------- USER PARAMETERS RETRIEVED FROM search/searchForUsers.jsp  ----------------------->
	<%
	String searchedUser = request.getParameter("search_username");
	String newSender = session.getAttribute("user_username").toString();
	
	
	%>
	<!------ QUERIES THE DATABASE FOR MATCHING USERNAME, THEN DISPLAYS RESULTS  ------>
	<%
//	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();

			String searchForUser = "SELECT * FROM Users u WHERE u.username ='" + searchedUser + "';";
			ResultSet res1 = stmt.executeQuery(searchForUser);
		%>	
		<%
			if (session.getAttribute("user_type").toString().equals("rep")){
				%>
				<div class='form'>
				<h3>REP FUNCTIONS:</h3>
					<form action="../repTools/editUser.jsp">
						  <input type="hidden" name="current_username" value="<%=searchedUser%>">
						  <input type="password" name="password" placeholder="*change password*" maxlength="50">
						  <input type="text" name="email" placeholder="*change email*" maxlength="50">
						  <input type="text" name="firstName" placeholder="*change first name" maxlength="25">
						  <input type="text" name="lastName" placeholder="*change last name*" maxlength="25">
						  <input type="text" class="lockedStatus" name="isLocked" placeholder="*change locked status (1 is locked, 0 is not)*" maxlength="1">
						  <input type="submit" value="Edit this User" >
						  <p class="message">*Make any edits, then click submit to update</p>
						  <p class="message">*NOTE: Locked status must be 0 or 1</p>
					</form>		
					</div>
	
				<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
				<script type="text/javascript">
				$('.lockedStatus').keyup(function(e) {
				    if(this.value != '0' && this.value != '1') {
				        this.value = '';   
				    }
				});
				</script>
				<%
			}
			%>
			
		<!---------------------- IF ANY RESULTS: DISPLAYS ALL AUCTIONS AND BID HISTORY  --------------------------->
		<% 	
		if (res1.next()) {
			String userAuctionQuery= "SELECT * FROM Auctions a LEFT JOIN Items i ON a.auctionID = i.auctionID LEFT JOIN (SELECT"
					+ " auctionID, MAX(bid_amount) AS top_Bid FROM Bids GROUP BY auctionID) t1 "
				+ " ON a.auctionID = t1.auctionID WHERE a.seller LIKE '%" + searchedUser +"%'";	
			ResultSet res2 = stmt.executeQuery(userAuctionQuery);	
			
			%>
			<!--------------------- DISPLAYS ALL AUCTIONS  ----------------------->
			<%
			out.print("<div class='form'>");
			%>
			<h1><%=searchedUser%>'s Auctions</h1>
			<hr>
			<%
			while (res2.next()) {
				int auctionID = res2.getInt("a.auctionID");
				out.print("<strong>AuctionID:</strong> #" + res2.getInt("a.auctionID"));
				%>
				<br>
				<% 
				out.print("<strong>Auction created by:</strong> " + res2.getString("a.seller"));
				%>
				<br>
				<% 
				out.print("<strong>Title:</strong> " + res2.getString("a.title"));
				%>
				<br>
				<% 
				out.print("<strong>Item Category:</strong> " + res2.getString("a.item_category"));	
				%>
				<br>
				<% 
				out.print("<strong>Starting Bid:</strong> $" + String.format("%.02f", (res2.getDouble("a.starting_bid"))));	
				%>
				<br>
				<% 
				out.print("<strong>Auction End:</strong> " + res2.getTimestamp("a.auction_endDate"));	
				%>
				<br>
				<% 
				if(res2.getBoolean("a.wasSold")){
					out.print("<strong>Item sold for</strong> $" + String.format("%.02f", (res2.getDouble("t1.top_Bid"))));
				} else if (!res2.getBoolean("a.isActive")){
					out.print("This Auction ended before a high enough bid was reached.");
				}
				%>
				<br>					
				<form action="../../auctions/createBid/createNewBid.jsp" method="get">
					<input type="hidden" name="auctionID" value="<%=auctionID%>"/>
					<input type="submit" value="View Auction"/>
				</form>
				<hr>
			<%
			}		
			out.print("</div>");
			res2.close();
			
			%>
			<!------------------------------ DISPLAYS BIDDING HISTORY  ------------------------------------>
			<%
			String userBidsQuery= "SELECT * FROM Bids b LEFT JOIN Auctions a ON b.auctionID=a.auctionID WHERE"
					+ " b.bidder LIKE '" + searchedUser + "';";
			ResultSet res3 = stmt.executeQuery(userBidsQuery);	

			out.print("<div class='form'>");
			%>
			<h1><%=searchedUser%>'s Bidding History</h1>
			<hr>
			<%
			while (res3.next()) {
				int auctionID2 = res3.getInt("a.auctionID");
				out.print("User bid $" + String.format("%.02f", (res3.getDouble("b.bid_amount"))) + " on auction #" + res3.getInt("b.auctionID"));
				%>
				<br><br>				
				<form action="../../auctions/createBid/createNewBid.jsp" method="get">
					<input type="hidden" name="auctionID" value="<%=auctionID2%>"/>
					<input type="submit" value="View Auction"/>
				</form>
				<hr>
				<%
			}
			out.print("</div>");
			res3.close();
			con.close();
			%>
		
			<div class='form'>
			  	<form>
			 		<button formaction="../searchForUsers.jsp">Search For Another User</button>
				 	<button formaction="../../home/home.jsp">Return Home</button>
			  	</form>	  	
			</div>			

		<!---------------------- ELSE: GIVE ERROR ALERT AND RETURN ---------------------------------->	
		<%
		
		} else {
			%>
			<script> 
			    alert("No Users were found by this username.");
			    window.location.href = "../searchForUsers.jsp";
			</script>
			<% 
			con.close();
			return;	
		}

//	} catch (Exception e) {
		%>
		<script> 
//	    alert("Server Error: An unexpected error has occurred. Please try again.");
//	    window.location.href = "../searchForUser.jsp";
		</script>
		<%	
//	}
	%>

</body>
</html>