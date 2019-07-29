<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta charset="UTF-8">
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
    			window.location.href = "../../login.jsp";
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
	    			window.location.href = "../../login.jsp";
	    		</script>
	    		<%
			}
		}
		%>
		<!-----------------------------------------------------------------------------------------------
					   HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>	
		<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>
		
		 <div class="form">
		<h2> Administrative Tools </h2>
		<hr>	  	  
		  	  
		<form class="adminTools" method="post" action="totalEarnings.jsp">
			<h3 id="overallEarnings">Total Overall Earnings</h3>
			<p class="message">Total earnings of all sold items</p>
	      	<input type="submit" value="Generate Report">
	    </form>	   
		<hr>	
		 	  
		<form class="adminTools" method="post" action="earningsPerItem.jsp">
			<h3 id="earningsPerItem">Total Earnings Per Item</h3>
			<p class="message">All sold items and their sell price</p>
	      	<input type="submit" value="Generate Report">
	    </form>			  
		<hr>	
			  
		<form class="adminTools" method="post" action="earningsPerItemType.jsp">
			<h3 id="earningsPerItemType">Total Earnings Per Item Type</h3>
			<p class="message">Total earnings per item category</p>
	      	<input type="submit" value="Generate Report">
	    </form>
	    <hr>	
	    	  	  
		<form class="adminTools" method="post" action="earningsPerUser.jsp">
			<h3 id="earningsPerUser">Total Earnings Per User</h3>
			<p class="message">Total earnings generated per User</p>
	      	<input type="submit" value="Generate Report">
	    </form>
	    <hr>
	    
		<form class="adminTools" method="post" action="bestSellingItems.jsp">
			<h3 id="bestSellingItems">Best-Selling Items</h3>
			<p class="message">Items that have sold for the highest amount</p>
   			<select name="numer_display" required>
   				<option value="5">Top 5</option>
				<option value="10">Top 10</option>
				<option value="20">Top 20</option>
				<option value="50">Top 50</option>
			</select>
	      	<input type="submit" value="Generate Report">
	    </form>	    		  
		<hr>  
		
		<form class="adminTools" method="post" action="bestSellingUsers.jsp">
			<h3 id="bestSellingUsers">Best-Selling Users</h3>
			<p class="message">Users that have generated the highest amounts</p>
   			<select name="numer_display" required>
   				<option value="5">Top 5</option>
				<option value="10">Top 10</option>
				<option value="20">Top 20</option>
				<option value="50">Top 50</option>
			</select>			
	      	<input type="submit" value="Generate Report">
	    </form>	 		  
		<hr>  
		
		<form class="adminTools" method="post" action="bestBuyers.jsp">
			<h3 id="bestBuyers">Best Buyers</h3>
			<p class="message">Users that have spent the most money</p>
   			<select name="numer_display" required>
   				<option value="5">Top 5</option>
				<option value="10">Top 10</option>
				<option value="20">Top 20</option>
				<option value="50">Top 50</option>
			</select>			
	      	<input type="submit" value="Generate Report">
	    </form>	 	
		<hr>
		</div>
		<div class='form'>
			<form>
			    <button formaction="../../home/home.jsp">Home</button>
			</form>	  		   
			<br>   
		</div>
</body>
</html>

