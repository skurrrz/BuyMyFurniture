<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


 <!---------------------------------- HOW THIS WORKS -------------------------------------
Step 3A of Item Search (see search/searchForItems.jsp for full details)
	- All items stored in the Items DB Table have 11 total characteristics,
		5 of these categories are shared across all item types and the remaining 
		6 are 2 unique characteristics per item type
	- This search only filters for items using the first 5 characteristics,
		and returns active Auctions with these items
	- This file queries the database looking for tuples that match the characteristics
		that the user desires
 --------------------------------------------------------------------------------------->
 

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
	<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>
	  
	  
	<!---------------------- ITEM PARAMETERS RETRIEVED FROM search/newItemsSearch.jsp  ----------------------->	  
	<%
	String newKeyWord1 = request.getParameter("keyword1");
	String newKeyWord2 = request.getParameter("keyword2");
	String newKeyWord3 = request.getParameter("keyword3");
	
	String newItemManufacturer = request.getParameter("item_manufacturer");
	String newItemCondition = request.getParameter("item_condition");
	String newItemColor = request.getParameter("item_color");
	String newItemMaterial = request.getParameter("item_material");
	
	%>
	<!----------- IF USER DID NOT SELECT "ANY," CHARACTERISTIC WILL BE ADDED TO THE QUERY  --------------->
	<%
	String queryItemManufacturer = "";
	String queryItemCondition = "";
	String queryItemColor = "";
	String queryItemMaterial = "";
	
	if (!newItemManufacturer.equals("Any")) {
		queryItemManufacturer = " AND i.item_manufacturer LIKE '" + newItemManufacturer + "'";
	} 
	
	if (!newItemCondition.equals("Any")) {
		queryItemCondition = " AND i.item_condition LIKE '" + newItemCondition + "'";
	}

	if (!newItemColor.equals("Any")) {
		queryItemColor = " AND i.item_color LIKE '" + newItemColor + "'";
	}
	
	if (!newItemMaterial.equals("Any")) {
		queryItemMaterial = " AND i.item_material LIKE '" + newItemMaterial + "'";
	} 

	%>
	<!------ QUERIES THE DATABASE FOR MATCHING CHARACTERISTICS, THEN DISPLAYS CURRENT AUCTIONS FOR USER  ------>
	<%
	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();
					
			String searchForItem = "SELECT * FROM Auctions a LEFT JOIN Items i ON a.auctionID = i.auctionID"
									+ " WHERE a.isActive LIKE '1' AND a.title LIKE '%" + newKeyWord1 + "%'"
									+ " AND a.title LIKE '%" + newKeyWord2 + "%' AND a.title LIKE '%" + newKeyWord3 + "%'"
									+ queryItemManufacturer + queryItemCondition + queryItemColor + queryItemMaterial
									+ " ORDER BY a.auction_startDate DESC;";
			ResultSet res = stmt.executeQuery(searchForItem);	
			
			%>
			<!---------------------- IF ANY RESULTS: DISPLAYS ALL RESULTS IN A FORM  --------------------------->
			<% 	
			if(res.next()) {
				res.beforeFirst();
				out.print("<div class='form'>");	
				%>
				<h1>Search Results: </h1>
				<hr>	
				<%
				
				while (res.next()) {
					%>
					<br>
					<% 
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
					out.print("<strong>Starting Bid:</strong> $" + String.format("%.02f", (res.getDouble("starting_bid"))));	
					%>
					<br>
					<% 
					out.print("<strong>Auction Beginning:</strong> " + res.getTimestamp("auction_startDate"));	
					%>
					<br>
					<% 
					out.print("<strong>Auction End:</strong> " + res.getTimestamp("auction_endDate"));	
					%>	
					<br><br>				
					<form action="../../auctions/createBid/createNewBid.jsp" method="get">
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
				 		<button formaction="../searchForItems.jsp">Search For Another Item</button>
					 	<button formaction="../../home/home.jsp">Return Home</button>
				  	</form>	  	
				</div>

			<!---------------------- ELSE: GIVE ERROR ALERT AND RETURN ---------------------------------->
			<% 	
			} else {
				%>
				<script> 
				    alert("No results were found. Please try again with different less restrictions.");
				    window.location.href = "../searchForItems.jsp";
				</script>
				<% 
				con.close();
				return;
			}
		
	} catch (Exception ex) {
		%> 
		<script> 
			alert("SERVER ERROR: An unexpected error has occurred. Please try again.");
		    window.location.href = "../searchForItems.jsp";
		</script>
		<%
	}
	%>

</body>
</html>