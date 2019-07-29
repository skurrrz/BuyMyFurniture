<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. searchForItems.jsp
	- User is directed here from home/home.jsp 
	- User is prompted to choose what type of item they are searching for
	
2. newItemsSearch.jsp
	- Depending on which item they selected from the list, they are presented 
		with one of four forms where they can fill out characteristics of
		items they are looking for
	- All Items, Chairs, Lamps, Tables Search
	
3A. check/checkAllSearch.jsp
	- All items stored in the Items DB Table have 11 total characteristics,
		5 of these categories are shared across all item types and the remaining 
		6 are 2 unique characteristics per item type
	- This search only filters for items using the first 5 characteristics,
		and returns active Auctions with these items
	- This file queries the database looking for tuples that match the characteristics
		that the user desires
	
3B. check/checkChairSearch.jsp
3C. check/checkLampSearch.jsp
3D. check/checkTableSearch.jsp
	- These three files are similar to checkAllSearch, but they search for 7
		characteristics (5 shared + 2 unique characteristics), queries the 
		database and returns any current auctions with these items
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
			        FORM TO NARROW DOWN WHAT TYPE OF ITEM THE USER IS SEARCHING FOR
		------------------------------------------------------------------------------------------------>
	<div class="search">
	  <div class="form">
	    <form method="post" action="newItemsSearch.jsp">
	    <h2>What type of item are you searching for?</h2>
   			<select name="item_category" required>
   				<option value="any">Any Item</option>
				<option value="chair">Chair</option>
				<option value="table">Table</option>
				<option value="lamp">Lamp</option>
			</select>
	 	    <input type="submit" value="Continue">
	      <p class="message">Changed your mind? <a href="../home/home.jsp">Click here to go back home.</a></p>
	    </form>
	  </div>
	</div>

</body>
</html>