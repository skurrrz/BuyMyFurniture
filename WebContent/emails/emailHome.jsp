<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. emailHome.jsp
	- Let's user choose to either check their inbox or write a new email to someone

1A. deleteEmail.jsp
	- Removes email from the database
	
1B. replyToEmail.jsp
	- Sends a new email with the new subject replaced with "RE: 'old_subject'" and the
		new recipient is the old email's sender

1C createNewEmail.jsp
	- Writes a new email (To, From, Datetime, Subject, Contents)

2. checkNewEmail.jsp
	- Checks the newEmail, and if valid, inserts into Emails table in DB
 --------------------------------------------------------------------------------------->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		 <link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta charset="UTF-8">
		<title>Emails</title>
	</head>
	
<body>
		<!-----------------------------------------------------------------------------------------------
					SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
		<%
		String user_username;
		if(session.getAttribute("user_username") == null){
		   	%>
		   	<script>
		  			alert("User session check failed, please login!");
		  			window.location.href = "../login.jsp";
		  		</script>
		  		<%
		  		return;
		} else {
				user_username = session.getAttribute("user_username").toString();
		}
		%>	
	

		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../home/home.jsp"><img src="../images/websiteLogo.png"></a></p>     
		
		<div class='form'>
			<form>
				<button formaction="emailTools/createNewEmail.jsp">Create a New Email</button>
			</form>	  
		</div>	
		<!-----------------------------------------------------------------------------------------------
			        GETS USERNAME FROM SESSION, QUERIES DATABASE TO RETURN EMAILS SENT TO USER
		------------------------------------------------------------------------------------------------>		
		<%
			out.print("<div class='form'>");
		  	String emailRecipient = session.getAttribute("user_username").toString();
		
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//QUERY: Generate a list of emails where the emailTo = username
			String findEmails = "SELECT emailFrom, emailDatetime, emailSubject, emailContent FROM"
								+ " Email WHERE emailTo = '" + emailRecipient + "' ORDER BY"
								+ " emailDatetime DESC;";
	
			ResultSet res = stmt.executeQuery(findEmails);	
			%>

		<!-----------------------------------------------------------------------------------------------
			        IF ANY RESULTS: DISPLAYS ALL EMAILS
		------------------------------------------------------------------------------------------------>			
			<% 	
			if(res.next()) {
				res.beforeFirst();
				int i = 1;
				%>
				<h1>Your Inbox:</h1>
				<hr>
				<% 
			
				while (res.next()) {
					String emailFrom = res.getString("emailFrom");
					String emailTo = session.getAttribute("user_username").toString();
					java.sql.Timestamp emailDatetime = res.getTimestamp("emailDatetime");
					String emailSubject = res.getString("emailSubject");
					
					out.print("<strong>Email  " + i + "</strong>");			
					%>
					<br>
					<% 
					out.print("<strong>Sender: </strong>" + emailFrom);
					%>
					<br>
					<% 
					out.print("<strong>Sent: </strong>" + emailDatetime);
					%>
					<br>
					<% 
					out.print("<strong>Subject: </strong>" + emailSubject);
					%>
					<br>
					<% 
					out.print("<strong>Content: </strong>" + res.getString("emailContent"));	
					%>
					<br><br>
					<form action="emailTools/replyToEmail.jsp" method="get">
						  <input type="hidden" name="email_replyTo" value="<%=emailFrom%>">
						  <input type="hidden" name="email_subject" value="<%=emailSubject%>">
						  <input type="submit" value="Reply" style="float:left; height:50px; width:200px">
					</form>
					<form action="emailTools/deleteEmail.jsp">
						  <input type="hidden" name="email_From" value="<%=emailFrom%>">
						  <input type="hidden" name="email_To" value="<%=emailTo%>">
						  <input type="hidden" name="email_datetime" value="<%=emailDatetime%>">
						  <input type="submit" value="Delete" style="float:right; height:50px; width:200px">
					</form>
					<br><br><br>
					<hr>
					<% 
					i++; 
				}
				con.close();
				%>
				<br>
				<form>
					<button formaction="../home/home.jsp">Return Home</button>
				</form>	  
				<%
				out.print("</div>");
				%>

		<!-----------------------------------------------------------------------------------------------
			        ELSE: GIVE NO EMAILS RESULT 
		------------------------------------------------------------------------------------------------>		
		<% 	
		} else {
			out.print("Your inbox is currently empty.");		
			con.close();
		}
		
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: An unexpected error has occurred. Please try again.");
		    window.location.href = "../../home/home.jsp";
			</script>
			<%	
		}
	%>

</body>
</html>				