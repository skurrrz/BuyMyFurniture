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
			     USER IS GIVEN A FORM TO WRITE A REPLY MESSAGE, RECIPIENT AND SUBJECT ALREADY FILLED
		------------------------------------------------------------------------------------------------>		  	
		<div class="form">    
		    <form class="newRep-form" method="post" action="checkEmailRep.jsp">
				<h2 id="register">Contact a Representative</h2>		      		
			      <input type="text" placeholder="Enter email subject" name="email_subject" required maxlength="50"/>
			      <input type="text" placeholder="Enter email message" name="email_message" required maxlength="200"/>
			      
			      <input type="submit" value="Submit">
			      
			      <p class="message">*Email contents must be less than 200 characters</p>     	    	      
		    </form>    
	 	 </div>	
	 	 <div class='form'>
		  	<form>
			 	<button formaction="../../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>	

</body>
</html>