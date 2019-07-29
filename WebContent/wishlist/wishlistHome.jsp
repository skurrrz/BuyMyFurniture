<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. wishlistHome.jsp
	- User can choose to create a new wish list item
	- A table displays all items currently in the user's wishlist
		+ Delete Wishlist Item
	
2. createNewWishlist.jsp
	2A.checkAllWishlist.jsp
	2B. checkChairWishlist.jsp
	2C. checkLampWishlist.jsp
	2D. checkTableWishlist.jsp
		
WISHLIST ALERT:
Every time a new auction is created, it is referenced with wishlist 
If a match is found, delete wishlist entry and send email		
 --------------------------------------------------------------------------------------->


<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Wishlist</title>
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
			                                WELCOME
		------------------------------------------------------------------------------------------------>
		<div class="form">
	    	<h1>Welcome to Your Wishlist</h1>
	    	<h4>
				You can describe an item you would like to be notified about,
				and if someone posts an auction with characteristics that match
				you will be alerted via email!
			</h4>
		</div>
		
		<!-----------------------------------------------------------------------------------------------
			                          CREATE A NEW WISHLIST ITEM
		------------------------------------------------------------------------------------------------>
		<div class="form">
		    <form method="post" action="createNewWishlist.jsp">
		    	<h1>Add to your Wishlist</h1>
		    	<h4>Choose a category to add a new item to your Wishlist</h4>
		    	<hr>
	   			<select name="item_category" required>
	   				<option value="any">Any Item</option>
					<option value="chair">Chair</option>
					<option value="table">Table</option>
					<option value="lamp">Lamp</option>
				</select>
		 	    <input type="submit" value="Continue">
		    </form>
		</div>
		
	
		<!-----------------------------------------------------------------------------------------------
			                       DISPLAYS USERS CURRENT WISHLIST ITEMS
		------------------------------------------------------------------------------------------------>
		<%
		  String thisUsername = session.getAttribute("user_username").toString();
		
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//QUERY: Generate a list of emails where the emailTo = username
			String findWishlist = "SELECT * FROM Wishlist WHERE username LIKE '" + thisUsername + "';";
			ResultSet res = stmt.executeQuery(findWishlist);	
			
			if(res.next()) {
				res.beforeFirst();
				out.print("<div class='form'>");
				int i = 1;
				%>
				<h1>Your Wishlist:</h1>
				<hr>
				<% 
			
				while (res.next()) {
					int wishID = res.getInt("wishID");
					String wish_username = session.getAttribute("user_username").toString();
					String itemCategory = res.getString("item_category");	
					
					out.print("<strong>Item  #" + i + ":</strong>");			
					%>
					<br>
					<% 
					out.print("<strong>Date added:</strong> " + res.getTimestamp("date_added"));	
					%>
					<br>	
					<%		
					out.print("<strong>Item Category:</strong> " + res.getString("item_category"));	
					%>
					<br>
					<%		
					out.print("<strong>Item Type:</strong> " + res.getString("item_type"));	
					%>
					<br>
					<% 
					out.print("<strong>Manufacturer:</strong> " + res.getString("item_manufacturer"));	
					%>
					<br>
					<% 
					out.print("<strong>Condition:</strong> " + res.getString("item_condition"));	
					%>
					<br>
					<% 
					out.print("<strong>Color:</strong> " + res.getString("item_color"));	
					%>
					<br>
					<% 
					out.print("<strong>Material:</strong> " + res.getString("item_material"));	
					%>
					<br>
					<% 
					if(itemCategory.equals("lamp")){
						out.print("<strong>Light Type:</strong> " + res.getString("lamp_light_type"));	
						%>
						<br>
						<% 
						out.print("<strong>Number of Bulbs:</strong> " + res.getString("lamp_num_bulbs"));	
						%>
						<br>
						<% 
					} else if(itemCategory.equals("chair")){
						
						out.print("<strong>Fabric:</strong> " + res.getString("chair_fabric"));	
						%>
						<br>
						<% 
						out.print("<strong>Number of Legs:</strong> " + res.getString("chair_num_legs"));	
						%>
						<br>
						<% 
					} else if(itemCategory.equals("table")){
						out.print("<strong>Shape:</strong> " + res.getString("table_shape"));	
						%>
						<br>
						<% 
						out.print("<strong>Number of Legs:</strong> " + res.getString("table_num_legs"));	
						%>
						<br>
						<% 
					}
					%>
					<br><br>
					<form action="deleteWishlistItem.jsp">
						  <input type="hidden" name="wishID" value="<%=wishID%>">
						  <input type="hidden" name="username" value="<%=wish_username%>">
						  <input type="submit" value="Delete Wishlist Item" style="width:400px">
					</form>
					<hr>
					<% 
					i++; 
				}
				con.close();
				%>
				<br>
				</div>
				<div class='form'>
					<form>
						<button formaction="../home/home.jsp">Return Home</button>
					</form>	  
				</div>
				<%

			return;
			} else {
				%>
				<div class='form'>
				<h1>Your Wishlist Items:</h1>
				<%
				out.print("Your wishlist is currently empty.");	
				%>
				</div>
				<%
				con.close();
			}
		%>
		<div class='form'>
			<form>
			 	<button formaction="../home/home.jsp">Return Home</button>
		  	</form>	 
		</div>
		
		<%
		    } catch (Exception e) {
		%>
		<script> 
	    alert("Server Error: Please try again");
	    window.location.href = "../home/home.jsp";
		</script>
		<%
		}	
		%>

</body>
</html>