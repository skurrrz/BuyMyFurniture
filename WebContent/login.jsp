<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!-- 
HOW THIS WORKS
login.jsp is the first page a user is directed to when they visit our website

If a user tries to visit another page from the website and they don't have a valid
session user_username attribute, it will redirect them back here to login

1. login.jsp
	- User can choose to either log in or create a new account
	
2A. checkExistingUser.jsp
	- If a User logs in, it redirects here to check with the database that the username
		exists and the password is correct for this account
	- Success will create a new session and redirect to home.jsp, repHome.jsp, or adminHome.jsp
		depending on their account details
	- Any failures redirects back to login.jsp
	
2B. checkNewUser.jsp
	- If a User creates a new account, it redirects here to insert into the database
		after making sure all information is valid
	- Success will create a new tuple in the database table Users, create a new session,
		and redirect to home.jsp
	- NOTE that customer rep accounts can only be created by Admins and is found under the
		admin folder
	- Any failures redirects back to login.jsp
	
c. home.jsp
	- Once a user logs in, or creates a new account, they are redirected here where they 
		can choose from a list of pages to visit: auctions/auctionsHome.jsp, search/searchForItems.jsp,
		 search/searchForUsers.jsp, forums/forumHome.jsp, emails/emailHome.jsp, wishlist/wishlistHome.jsp,
		 or can log out (logout.jsp)
		 
d. logout.jsp
	- Invalidates the user's session and returns to login.jsp
 -->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Buy My Furniture</title>
	</head>

<body>

	<%
	//Just in case: Session user is cleared
	session.setAttribute("user_username", "");
	%>
	
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><img src="images/websiteLogo.png"></p>      	
		<div class="login-page">
		  <div class="form">
		  
		  	<!-- Register Form --> 
		    <form class="register-form" method="post" action="home/checkNewUser.jsp">
		    <h3 id="register">Please enter the following information</h3>
		      <input type="text" placeholder="Username" name="user_username" required required min="1" maxlength="20"/>
		      <input type="password" placeholder="Password" name="user_password" required min="8" maxlength="50"/>    
		      <input type="email" placeholder="Email Address" name="user_email" required/>
		      <input type="text" placeholder="First Name" name="user_first_name" required/>
		      <input type="text" placeholder="Last Name" name="user_last_name" required/>
	
		      <input type="submit" value="Submit">
		      <p class="message">* All fields are required for registration</p>
		      <p class="message">Password must be between 8 and 50 characters</p>
		      <p class="message">Already registered? <a href="#login">Click here to sign in</a></p>
		    </form>
		    
		   <!-- Login Form --> 
		    <form class="login-form" method="post" action="home/checkExistingUser.jsp">
			<h2 id="login">Login to your account</h2>
		      <input type="text" placeholder="username" name="user_username" required required min="1" maxlength="20"/>
		      <input type="password" placeholder="password" name="user_password" required min="8" maxlength="50"/>
		      <input type="submit" value="Submit">
		      
		      <p class="message">Not registered? <a href="#register">Click here</a> to create an account</p>
		    </form>
		     
		  </div>
		</div>
		
		<!-- 
		Example given by TA, used to make the log in screen look nicer
		Will either show login form or register form, but not both
		-->
		
		<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
		<script type="text/javascript">
		$(document).ready(function(){
			if (window.location.href.indexOf('signup')!=-1){
				$('.login-form').hide();
				$('.register-form').show();
			}
		});
		
		$('.message a').click(function(){
			   $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
			});
		</script>

</body>
</html>