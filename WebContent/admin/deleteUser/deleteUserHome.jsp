<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
The admin is able to input a username to delete the account
 ------------------------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Admin</title>
	</head>

<body>

		<!-----------------------------------------------------------------------------------------------
				SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
		<%
		if(session.getAttribute("user_type") == null){
	    	%>
	    	<script>
    			alert("Administrator authority check failed, please login again!");
    			window.location.href = "../login.jsp";
    		</script>
    		<%
		}
		//Check if both user type and username is admin
		else if(session.getAttribute("user_type").toString().equals("rep")){
			String user_username = session.getAttribute("user_username").toString();
			
			if(!user_username.equals("admin")){
	    		%>
	    		<script>
	    			alert("Administrator authority check failed, please login again!");
	    			window.location.href = "../login.jsp";
	    		</script>
	    		<%
			}
		}
		%>
		
		
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p> 
		
		
		
		<!-----------------------------------------------------------------------------------------------
			        FORM TO INPUT USERNAME OF USER TO BE DELETED
		------------------------------------------------------------------------------------------------>		    	
	  <div class="form">  
		    <form class="deleteUser-form" method="post" action="checkDeleteUser.jsp">
				<h3>Enter the username of the account to be deleted</h3>
			      <input type="text" placeholder="Username" name="user_username" required maxlength="20"/>
			      <input type="submit" value="Submit">
			      <p class="message">Warning: Deleting an Account cannot be undone</p>     	    	      
		    </form> 
		</div>
		<div class="form">
			<form>
			    <button formaction="../../home/home.jsp">Home</button>
			</form>	 
		</div>
	
</body>
</html>