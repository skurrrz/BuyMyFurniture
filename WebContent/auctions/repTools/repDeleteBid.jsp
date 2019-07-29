<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
deletes a user's answer
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
		int delete_Bid_AuctionID = Integer.parseInt(request.getParameter("delete_Bid_AuctionID"));
		String delete_Bid_Bidder = request.getParameter("delete_Bid_Bidder");
		double delete_Bid_Bid_Amount = Double.parseDouble(request.getParameter("delete_Bid_Bid_Amount"));
		String delete_Bid_Bid_AmountStr = String.format("%.02f", delete_Bid_Bid_Amount);

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

				String deleteAnswer = "DELETE FROM Bids WHERE auctionID LIKE '" + delete_Bid_AuctionID + "' AND"
										+ " bidder LIKE '" + delete_Bid_Bidder + "' AND bid_amount LIKE '"
										+ delete_Bid_Bid_AmountStr + "';";
				PreparedStatement ps = con.prepareStatement(deleteAnswer);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! The bid has been deleted. Returning to Auction Home.");
			    	window.location.href = "../auctionsHome.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../auctionsHome.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>