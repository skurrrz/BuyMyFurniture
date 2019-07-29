<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
See emails/emailHome.jsp for full details about the emails folder
	- This redirects from emailHome.jsp
	- Deletes email from the database
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
			                EMAIL PARAMETERS RECEIVED FROM emailHome.jsp
		------------------------------------------------------------------------------------------------>	
		<%
		String newEmailTo = request.getParameter("email_To");
		String newEmailFrom = request.getParameter("email_From");
		String newEmailDateTime = request.getParameter("email_datetime");
		newEmailDateTime = newEmailDateTime.substring(0, newEmailDateTime.length()-2);
		
		%>
		<!----------------- DELETE EMAIL FROM DATABASE ---------------------------> 
		<%	
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();
	
				String deleteUser = "DELETE FROM Email WHERE emailFrom LIKE '" + newEmailFrom + "' AND"
										+ " emailTO LIKE '" + newEmailTo + "' AND emailDatetime LIKE '" + newEmailDateTime + "';";
				PreparedStatement ps = con.prepareStatement(deleteUser);
				ps.executeUpdate();
				con.close();
	
			%>
			<script> 
		    	window.location.href = "../emailHome.jsp";
			</script>
			
			<%
		} catch (Exception ex) {
			%> 
			<script> 
			    alert("Server Error: Email could not be deleted, please try again.");
			    window.location.href = "../emailHome.jsp";
			</script>
			<%
			return;
		}
		%>
</body>
</html>