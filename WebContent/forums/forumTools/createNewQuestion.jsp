<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!---------------------------------- HOW THIS WORKS -------------------------------------
see forumsHome.jsp for full details

This file gives the user a form to fill out to post a new question
Validated by checkNewEmail.jsp
 --------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Forums</title>
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
			<form class="newQuestion" method="post" action="check/checkNewQuestion.jsp">
				<h2 id="register">Write your Question</h2>
			     <input type="text" placeholder="Enter the title of your quesiton" name="question_Subject" min="1" maxlength="50" required/>
			     <input type="text" placeholder="Enter contents of the question" name="question_Contents" min="1" maxlength="200" required/>
			     <input type="submit" value="Submit">
			     <p class="message">*Subject must be less than 50 characters</p>
			     <p class="message">*Question contents must be less than 200 characters</p>     	    	      
			</form>        
		</div>
		<br>
		<div class='form'>
		  	<form>
		 		<button formaction="../forumsHome.jsp">Return to Forums</button>
			 	<button formaction="../../home/home.jsp">Home</button>
		  	</form>	  	
		</div>			 
		 
</body>
</html>