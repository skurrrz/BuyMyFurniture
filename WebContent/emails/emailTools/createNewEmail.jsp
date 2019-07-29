<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!---------------------------------- HOW THIS WORKS -------------------------------------
See emails/emailHome.jsp for full details about the emails folder

User is redirected here from emailHome.jsp after selecting "Create a New Email"
	- Writes a new email (To, From, Datetime, Subject, Contents)
	- Redirects to checkNewEmail.jsp to check validation
 --------------------------------------------------------------------------------------->
 
 
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
			       USER FILLS OUT A FORM OF WHO TO SEND EMAIL TO, SUBJECT, AND CONTENTS
		------------------------------------------------------------------------------------------------> 		
		<div class="form">    
			<form class="newRep-form" method="post" action="checkNewEmail.jsp">
				<h2 id="register">Write your email</h2>
			     <input type="text" placeholder="Recipient's Username" name="email_recipient" required min="1" maxlength="20"/>
			     <input type="text" placeholder="Enter subject of your email" name="email_subject" required min="1" maxlength="50"/>
			     <input type="text" placeholder="Enter email contents" name="email_message" required min="1" maxlength="200"/>
			     <input type="submit" value="Submit">
			     <p class="message">*Subject must be less than 50 characters</p>
			     <p class="message">*Email contents must be less than 200 characters</p>     	    	      
			</form>        
		</div>
		<br>
		<div class='form'>
		  	<form>
		 		<button formaction="../emailHome.jsp">Return to Inbox</button>
			 	<button formaction="../../home/home.jsp">Home</button>
		  	</form>	  	
		</div>			 
		 
</body>
</html>