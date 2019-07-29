<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
The admin is able to input a username to delete the account
 ------------------------------------------------------------------------------------------------------->
 
 
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
		
	  
	<%
	//Store user information
	String newUsername = request.getParameter("user_username");
	
	try {

		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();
		
		// 1. check if required fields are empty
		if(newUsername.equals("")){
			%> 
			<!-- On Error, show Alert and return to sign-up screen --> 
			<script> 
			    alert("Error: A username must be given to delete an account");
			    window.location.href = "deleteUserHome.jsp";
			</script>
			<%
			
			return;
		}
		//2. Check if trying to delete Admin account
		if(newUsername.equals("admin")){
			%> 
			<script> 
			    alert("Error: Cannot delete Admin account");
			    window.location.href = "deleteUserHome.jsp";
			</script>
			<%
			return;
		} 
		
		// 3. Checking if username exists
	    String checkUsernameStr = "SELECT * FROM Users u WHERE u.username= '" + newUsername + "'" ;
		ResultSet checkUsernameResult = stmt.executeQuery(checkUsernameStr);

		if(checkUsernameResult.next() == false){
			%> 
			<script> 
			    alert("Error: Username does not exist");
			    window.location.href = "deleteUserHome.jsp";
			</script>
			<%
			return;
		}

		//4. Delete account
		//Make an SQL delete statement for the Users table:
		String deleteUser = "DELETE FROM Users WHERE username = '" + newUsername + "';";
		PreparedStatement ps = con.prepareStatement(deleteUser);
		ps.executeUpdate();
		con.close();

		%>
		<script> 
		    alert("The account has been deleted. Returning home.");
	    	window.location.href = "../../home/home.jsp";
		</script>
		
		<%
	} catch (Exception ex) {
		%> 
		<script> 
		    alert("Server Error: Account could not be created, please try again.");
		    window.location.href = "../../home/home.jsp";
		</script>
		<%
		return;
	}
%>
</body>
</html>