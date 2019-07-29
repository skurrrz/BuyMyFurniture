<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. forumsHome.jsp

2A. searchForums.jsp
	- User can type up to 5 keywords to search for a question
	- Redirects to checkSearchForums.jsp
	
2B. check/checkSearchForums.jsp
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
					SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
	<%
	String user_username;
	if(session.getAttribute("user_username") == null){
	   	%>
	   	<script>
	  			alert("User session check failed, please login!");
	  			window.location.href = "../../login.jsp";
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
	<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>     
	
	

		<!-----------------------------------------------------------------------------------------------
			        USER INPUTS USERNAME THEY ARE SEARCHING FOR
		------------------------------------------------------------------------------------------------>	

			<div class="form">
	   			<form class="forumsSearch" method="post" action="check/checkSearchForums.jsp">
			    	<h1> Item Search </h1>
			    	<br>
			    	<hr>
			    	<p class="message">Search for up to 5 keywords that may be included in the the contents of a question or answer:</p>
					<input type="text" min="0" maxlength="50" placeholder="" name="keyword1"/>
					<input type="text" min="0" maxlength="50" placeholder="" name="keyword2"/>
					<input type="text" min="0" maxlength="50" placeholder="" name="keyword3"/>
					<input type="text" min="0" maxlength="50" placeholder="" name="keyword4"/>
					<input type="text" min="0" maxlength="50" placeholder="" name="keyword5"/>
					<input type="submit" value="Search Forums">
				</form>
			</div>
			
			<div class='form'>
			  	<form>
			 		<button formaction="../forumsHome.jsp">Return to Forums</button>
				 	<button formaction="../../home/home.jsp">Return Home</button>
			  	</form>	  	
			</div>	
	
</body>
</html>