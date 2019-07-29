<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
This deletes a user's selected wishlist item
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
			                EMAIL PARAMETERS RECEIVED FROM wishlistHome.jsp
		------------------------------------------------------------------------------------------------>	
		<%
		String wishID = request.getParameter("wishID");
		String username = request.getParameter("username");
		
		%>
		<!----------------- DELETE EMAIL FROM DATABASE ---------------------------> 
		<%	
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();
	
				String deleteUser = "DELETE FROM Wishlist WHERE wishID = '" + wishID
									+ "' AND username = '" + username + "';";
								
				PreparedStatement ps = con.prepareStatement(deleteUser);
				ps.executeUpdate();
				con.close();
	
			%>
			<script> 
			    alert("The wishlist item has been deleted.");
		    	window.location.href = "wishlistHome.jsp";
			</script>
			
			<%
		} catch (Exception ex) {
			%> 
			<script> 
			    alert("Server Error: Item could not be deleted, please try again.");
			    window.location.href = "wishlistHome.jsp";
			</script>
			<%
			return;
		}
		%>
</body>
</html>