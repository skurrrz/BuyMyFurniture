<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
edit's a user's question
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
		int edit_Bid_AuctionID = Integer.parseInt(request.getParameter("edit_Bid_AuctionID"));
		String edit_Bid_Bidder = request.getParameter("edit_Bid_Bidder");
		
		double edit_Bid_Bid_Amount = Double.parseDouble(request.getParameter("edit_Bid_Bid_Amount"));
		String edit_Bid_Bid_AmountStr = String.format("%.02f", edit_Bid_Bid_Amount);
		
		double edit_Bid_New_Bid_Amount = Double.parseDouble(request.getParameter("edit_Bid_New_Bid_Amount"));
		String edit_Bid_New_Bid_AmountStr = String.format("%.02f", edit_Bid_New_Bid_Amount);
		
		%>
		<!-----------------------------------------------------------------------------------------------
			     		           EDIT BID FROM DATABASE
		------------------------------------------------------------------------------------------------>		
		<% 
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

				String editAnswer = "UPDATE Bids SET bid_amount = ? WHERE"
						+ " auctionID LIKE '" + edit_Bid_AuctionID + "' AND bidder LIKE '" + edit_Bid_Bidder + "'"
						+ " AND bid_amount LIKE '" + edit_Bid_Bid_AmountStr + "';";
				PreparedStatement ps = con.prepareStatement(editAnswer);
				ps.setString(1, edit_Bid_New_Bid_AmountStr);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! The bid has been edited. Returning to Forum Home.");
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