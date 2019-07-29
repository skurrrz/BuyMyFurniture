<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


 <!---------------------------------- HOW THIS WORKS -------------------------------------

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
	  
	  
	<!---------------------- ITEM PARAMETERS  ----------------------->	  
	<%
	String username = session.getAttribute("user_username").toString();
	String newItemType = request.getParameter("item_type");
	String newItemManufacturer = request.getParameter("item_manufacturer");
	String newItemCondition = request.getParameter("item_condition");
	String newItemColor = request.getParameter("item_color");
	String newItemMaterial = request.getParameter("item_material");
	String newFabric = request.getParameter("chair_fabric");
	String newNumLegs = request.getParameter("chair_num_legs");
	
	int wishID = (int)((new java.util.Date().getTime() / 1000L) % Integer.MAX_VALUE);
	java.sql.Timestamp newdateAdded = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());

	%>
	<!------ ADDS ITEMT TO WISHLIST  ------>
	<%
	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();
					
			String addWishlist = "INSERT INTO Wishlist(wishID, username, item_category, date_added, item_type,"
								+ " item_manufacturer, item_condition, item_color, item_material, chair_fabric, chair_num_legs)"
								+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

				PreparedStatement ps = con.prepareStatement(addWishlist);
				ps.setInt(1, wishID);
				ps.setString(2, username);
				ps.setString(3, "Chair");
				ps.setTimestamp(4, newdateAdded);
				ps.setString(5, newItemType);
				ps.setString(6, newItemManufacturer);
				ps.setString(7, newItemCondition);
				ps.setString(8, newItemColor);
				ps.setString(9, newItemMaterial);
				ps.setString(10, newFabric);
				ps.setString(11, newNumLegs);
				ps.executeUpdate();
				con.close();
			
			%>
			<script> 
			    alert("Success! The item has been added to your wishlist.");
		    	window.location.href = "../wishlistHome.jsp";
			</script>
			<%

		
	} catch (Exception ex) {
		%> 
		<script> 
			alert("SERVER ERROR: An unexpected error has occurred. Please try again.");
		    window.location.href = "../wishlistHome.jsp";
		</script>
		<%
	}
	%>

</body>
</html>