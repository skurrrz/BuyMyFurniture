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
		String newEmailSubject = request.getParameter("email_subject");
		String newEmailMessage = request.getParameter("email_message");
		String newSender = session.getAttribute("user_username").toString();
		java.sql.Timestamp newEmailDatetime = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());
		
		
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
			
			//PICK RANDOM REPRESENTATIVE
			String selectRandomRep = "SELECT username FROM Users WHERE isRep = '1' ORDER BY RAND() LIMIT 1;";
			ResultSet res = stmt.executeQuery(selectRandomRep);
			res.next();
			String randomRep = res.getString("username");
			res.close();
			
			//INSERT EMAIL TUPLE TO REP
				String insert = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)"
						+ " VALUES (?, ?, ?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);
				ps.setString(1, newSender);
				ps.setString(2, randomRep);
				ps.setTimestamp(3, newEmailDatetime);
				ps.setString(4, newEmailSubject);
				ps.setString(5, newEmailMessage);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! Your email has been sent.");
			    	window.location.href = "../../home/home.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../../home/home.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>