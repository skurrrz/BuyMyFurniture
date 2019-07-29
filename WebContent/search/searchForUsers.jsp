<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. searchForUsers.jsp
	- User is directed here from home/home.jsp 
	- User is prompted to enter the name of the username they are searching for
	
2. check/checkUser.jsp
	- Checks if user exists, and if does displays user, auctions they have created,
		and bids they have made
 --------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Search</title>
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
	
	

		<!-----------------------------------------------------------------------------------------------
			        USER INPUTS USERNAME THEY ARE SEARCHING FOR
		------------------------------------------------------------------------------------------------>	

	<div class="form">    
		<form class="searchUser" method="post" action="check/checkUser.jsp">
			<h2 id="register">Enter the name of the user you would like to look up:</h2>
			<input type="text" placeholder="Enter username here" name="search_username" required min="1" maxlength="20"/>
			<input type="submit" value="Submit">
			<p class="message">Note: Looking up a User shows their Auction and Bid history</p>  
		</form>    
	</div>

	
	<div class='form'>
	  	<form>
		 	<button formaction="../home/home.jsp">Return Home</button>
	  	</form>	  	
	</div>	
	
</body>
</html>