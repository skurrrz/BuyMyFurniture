<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
See emails/emailHome.jsp for full details about the emails folder
	- This redirects from createNewEmail.jsp
	- This file checks the newEmail, and if valid, inserts into Emails table in DB
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
			     PARAMETERS RECEIVED FROM createNewEmail.jsp
		------------------------------------------------------------------------------------------------>		
		<%
		String newUsername = request.getParameter("email_recipient");
		String newEmailSubject = request.getParameter("email_subject");
		String newEmailMessage = request.getParameter("email_message");
		String newSender = session.getAttribute("user_username").toString();
		
		Calendar cal = Calendar.getInstance();
		java.sql.Timestamp newEmailDatetime = new java.sql.Timestamp(cal.getTimeInMillis());
		
		
		%>
		<!-----------------------------------------------------------------------------------------------
			     		QUERIES DATABASE FOR EMAIL VALIDATION BEFORE INSERTING
		------------------------------------------------------------------------------------------------>		
		<% 
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//Website should not allow empty fields, but this checks just in case
			 if ((newUsername.equals("")) || (newEmailSubject.equals("")) || (newEmailMessage.equals(""))){
				%>
				<script> 
				    alert("All fields must contain information to be sent");
				    window.location.href = "createNewEmail.jsp";
				</script>
				<% 
				con.close();
				return;
				
			//2. Check if recipient username does not exist
			} else {
			    String checkUsernameStr = "SELECT * FROM Users u WHERE u.username= '" + newUsername + "'" ;
				ResultSet checkUsernameResult = stmt.executeQuery(checkUsernameStr);
			
				if(checkUsernameResult.next() == false){
					%> 
					<script> 
					    alert("Error: The user you are trying to send this email to does not exist");
					    window.location.href = "createNewEmail.jsp";
					</script>
					<%
					con.close();
					return;
				}
			}
			
			//3. DATA IS VALID >> Insert into database Emails table
				String insert = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)"
						+ " VALUES (?, ?, ?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);
				ps.setString(1, newSender);
				ps.setString(2, newUsername);
				ps.setTimestamp(3, newEmailDatetime);
				ps.setString(4, newEmailSubject);
				ps.setString(5, newEmailMessage);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! Your email has been sent.");
			    	window.location.href = "../emailHome.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../emailHome.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>