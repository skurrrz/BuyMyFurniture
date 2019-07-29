<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
This allows the admin to create a new representative
DB Validation: checkNewRep.jsp
 ------------------------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
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
			                              FORM TO CREATE A NEW REP
		------------------------------------------------------------------------------------------------>			
		<div class="form">    
		    <form class="newRep-form" method="post" action="checkNewRep.jsp">
				<h2 id="register">Creating a New Representative</h2>
			      <input type="text" placeholder="Username" name="user_username" required min="1" maxlength="20"/>
			      <input type="password" placeholder="Password" name="user_password" required min="8" maxlength="50"/>    
			      <input type="email" placeholder="Email Address" name="user_email" required/>
			      <input type="text" placeholder="First Name" name="user_first_name" required/>
			      <input type="text" placeholder="Last Name" name="user_last_name" required/>
		
			      <input type="submit" value="Submit">
			      <p class="message">* All fields are required to register a representative</p>
			      <p class="message">Password must be between 8 and 50 characters</p>     	    	      
		    </form>
		</div>
		<div class="form">
			<form>
			    <button formaction="../../home/home.jsp">Home</button>
			</form>	 
		</div>
	
</body>
</html>