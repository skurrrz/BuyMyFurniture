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
		String current_username = request.getParameter("current_username");
		String new_password = request.getParameter("password");
		String new_email = request.getParameter("email");
		String new_firstName = request.getParameter("firstName");
		String new_lastName = request.getParameter("lastName");
		String new_isLocked = request.getParameter("isLocked");
		
		String queryUsername = "";
		String queryPassword = "";
		String queryEmail = "";
		String queryFirstName = "";
		String queryLastName = "";
		String queryIsLocked = "";
		
		//check if all fields are empty
		if ((new_password.equals("")) && (new_email.equals("")) && (new_firstName.equals(""))
				&& (!new_lastName.equals("")) && (new_isLocked.equals(""))){
			%> 
			<script> 
			    alert("Error: All fields are blank");
			    window.location.href = "../searchUser.jsp";
			</script>
			<%
		}
				
		
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

			
			//check if email is taken
			String checkEmail = "SELECT * FROM Users WHERE email LIKE '" + new_email +  "';";
			ResultSet checkEmailRes = stmt.executeQuery(checkEmail);
						
			if(checkEmailRes.next() ){
				%> 
				<script> 
				    alert("Error: Email has already been taken.");
				    window.location.href = "../searchForUsers.jsp";
				</script>
				<%
				con.close();
				return;
			}	
			checkEmailRes.close();
			
			//get current characteristics
			String checkUser = "SELECT * FROM Users WHERE username LIKE '" + current_username +  "';";
			ResultSet res = stmt.executeQuery(checkUser);
			res.next();
				String curr_username = res.getString("username");
				String curr_password = res.getString("password");
				String curr_email = res.getString("email");
				String curr_firstName = res.getString("firstName");
				String curr_lastName = res.getString("lastName");
				int curr_isLocked = res.getInt("locked");
				
				//build queries
				if (!new_password.equals("")){
					queryPassword = " password = '" + new_password + "',";
				} else {
					queryPassword = " password = '" + curr_password + "',";
				}
				
				if (!new_email.equals("")){
					queryEmail = " email = '" + new_email + "',";
				} else {
					queryEmail = " email = '" + curr_email + "',";
				}
				
				if (!new_firstName.equals("")){
					queryFirstName = " firstName = '" + new_firstName + "',";
				} else {
					queryFirstName = " firstName = '" + curr_firstName + "',";
				}
				
				if (!new_lastName.equals("")){
					queryLastName = " lastName = '" + new_lastName + "',";
				} else {
					queryLastName = " lastName = '" + curr_lastName + "',";
				}
				
				if (!new_isLocked.equals("")){
					queryIsLocked = " locked = '" + new_isLocked + "'";
				} else {
					queryIsLocked = " locked = '" + curr_isLocked + "'";
				}
			res.close();	
			
			//update user
			String updateUser = "UPDATE Users SET" + queryPassword + queryEmail 
								+ queryFirstName + queryLastName + queryIsLocked
								+ " WHERE username LIKE '" + current_username +  "';";
			PreparedStatement ps = con.prepareStatement(updateUser);
			ps.executeUpdate();
			con.close();

				%>		
				<script> 
				    alert("Success! The User has been edited.");
			    	window.location.href = "../searchForUsers.jsp";
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