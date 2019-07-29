<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
edit's a user's Auction
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
			              PARAMETERS RECEIVED FROM createNewAnswer.jsp
		------------------------------------------------------------------------------------------------>		
		<%	
		int edit_auctionID = Integer.parseInt(request.getParameter("edit_auctionID"));
		String edit_auctionTitle = request.getParameter("edit_auctionTitle");
		double edit_starting_bid = Double.parseDouble(request.getParameter("edit_auctionStartingBid"));
		String edit_starting_bidStr = String.format("%.02f", edit_starting_bid);
		%>


		<!-----------------------------------------------------------------------------------------------
			     		           DELETE ANSWER FROM DATABASE
		------------------------------------------------------------------------------------------------>		
		<% 
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

				String editAnswer = "UPDATE Auctions SET title = ?, starting_bid = ? WHERE"
						+ " auctionID LIKE '" + edit_auctionID + "';";
				PreparedStatement ps = con.prepareStatement(editAnswer);
				ps.setString(1, edit_auctionTitle);
				ps.setString(2, edit_starting_bidStr);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! The auction has been edited. Returning to Forum Home.");
			    	window.location.href = "../auctionsHome.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			con.close();
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../auctionsHome.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>