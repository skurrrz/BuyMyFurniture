<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!-- 
This is step C in the home folder (See login.jsp for description of entire home folder)
	- Once a user logs in, or creates a new account, they are redirected here where they 
		can choose from a list of pages to visit: auctions/auctionsHome.jsp, search/searchForItems.jsp,
		 search/searchForUsers.jsp, forums/forumHome.jsp, emails/emailHome.jsp, wishlist/wishlistHome.jsp,
		 or can log out (logout.jsp)
 -->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta charset="UTF-8">
		<title>Buy My Furniture</title>
	</head>
	
	
<body>
		<!-----------------------------------------------------------------------------------------------
				SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
		<%
		String user_username = "User";
		if(session.getAttribute("user_username") == null){
	    	%>
	    	<script>
    			alert("User session check failed, please login again!");
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
		<p class="app-name"><a href="home.jsp"><img src="../images/websiteLogo.png"></a></p>

		
		<!-- Home: list of pages to visit  -->	
		<div class="home-page">
		  <div class="form">
		
			  <p class="message"> Welcome to Buy My Furniture, <%=user_username%>!<br>
			  <p class="message"> Where would you like to go? </p>
			  <p class="message"> </p>
			<%
			if ((session.getAttribute("user_type").toString().equals("rep")) &&
					(session.getAttribute("user_username").toString().equals("admin"))){ 	 
			%>
			<form>
		    	<button formaction="../admin/adminTools/adminToolsHome.jsp">Sales Reports</button>
			</form>		
				  	  
		  	<form>
		    	<button formaction="../admin/createRep/createRepHome.jsp">Create a New Representative</button>
		  	</form>
		  	
		 	 <form>
		    	<button formaction="../admin/deleteUser/deleteUserHome.jsp">Delete an Account</button>
		  	</form>			  	
			  <br>
			 <%
			}
			 %> 
			  <form>
			    <button formaction="../auctions/auctionsHome.jsp">Auctions</button>
			  </form>	
			  
			  <form>
			    <button formaction="../search/searchForItems.jsp">Search Items</button>
			  </form>	 
			  
			  <form>
			    <button formaction="../search/searchForUsers.jsp">Search Users</button>
			  </form>	  
			  <br>			  
			  <form>
			    <button formaction="../forums/forumsHome.jsp">Forums</button>
			  </form>
			  
			  
			  <form>
			    <button formaction="../emails/emailHome.jsp">Emails</button>
			  </form>		 
			  
			  <form>
			    <button formaction="../wishlist/wishlistHome.jsp">Wishlist</button>
			  </form>
			  <br>			  
			  <form>
			    <button formaction="../emails/emailTools/emailRep.jsp">Contact a Representative</button>
			  </form>		
			  
			  <br>
			  <form>
			    <button formaction="logout.jsp">Logout</button>
			  </form>	  		   
			  <br>
		    
		  </div>
		</div>
</body>
</html>



	