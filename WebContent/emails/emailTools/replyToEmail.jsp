<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
See emails/emailHome.jsp for full details about the emails folder
	- This redirects from emailHome.jsp
	- Sends a new email with the new subject replaced with "RE: 'old_subject'" and the
		new recipient is the old email's sender
 ------------------------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Email</title>
	</head>

<body>	
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>


		<!-----------------------------------------------------------------------------------------------
			     RETURN EMAIL PARAMETERS RECEIVED FROM emailHome.jsp
		------------------------------------------------------------------------------------------------>
		<%
		String emailSendTo = request.getParameter("email_replyTo");
		String emailSubject = "RE: " + request.getParameter("email_subject");
		%>
		 
		<!-----------------------------------------------------------------------------------------------
			      USER IS GIVEN A FORM TO WRITE A REPLY MESSAGE, RECIPIENT AND SUBJECT ALREADY FILLED
		------------------------------------------------------------------------------------------------>		
		   	
		<div class="form">    
		    <form class="newRep-form" method="post" action="checkNewEmail.jsp">
				<h2 id="register">Replying to <%=emailSendTo%></h2>
				
			      <input type="text" placeholder="Send to <%=emailSendTo%>" name="email_recipient" 
			      		value="<%=emailSendTo%>" readonly required min="1" maxlength="20"/>
			      		
			      <input type="text" placeholder="<%=emailSubject%>" name="email_subject" 
			      		value="<%=emailSubject%>" readonly required min="1" maxlength="50"/>
			      		
			      <input type="text" placeholder="Enter email contents" name="email_message" required min="1" maxlength="200"/>
			      
			      <input type="submit" value="Submit">
			      
			      <p class="message">*Email contents must be less than 200 characters</p>     	    	      
		    </form>    
	 	 </div>	
	 	 <div class='form'>
		  	<form>
		 		<button formaction="../emailHome.jsp">Return to Inbox</button>
			 	<button formaction="../../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>	

</body>
</html>

