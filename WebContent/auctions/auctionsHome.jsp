<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. auctionsHome.jsp
	- Users are able to post a new auction, view a sorted list of current auctions, or 
		view a sorted list of sold, closed auctions
		
2. CreateNewAuction/createNewAuction.jsp
	- Users pick which type of item they want to sell, fill out information, and if it 
		is valid with the database, it is inserted into the table Auctions
	2A. checkAuctionType.jsp
	2B. 
	
3. checkAuctionSort.jsp
	- This returns a list of all current auctions, sorted by the user's preference as picked
		from the drop down list
	- User's pick from list, redirects to sortedAuctions and returns list

4. checkSoldAuctionSort.jsp
	- This returns a list of all sold auctions, sorted by the user's preference as picked
		from the drop down list
	- User's pick from list, redirects to sortedSoldAuctions and returns list
	
		
AUCTION CLOSING PROCEDURE:
When an auction is successfully created and inserted into the database, an alert
is also created and inserted into the database, and after the duration of the auction,
it automatically sets the auction to closed, then
	IF the top bid was greater than the minimum sell price
		Email both seller and bidder and set wasSold to true
	ELSE
		Email the seller and set wasSold to false
 --------------------------------------------------------------------------------------->


<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			        CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATIOD
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta charset="UTF-8">
		<title>Auctions</title>
	</head>
	
<body>

		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../home/home.jsp"><img src="../images/websiteLogo.png"></a></p>   


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
				USERS CAN SELECT TO POST A NEW AUCTION, VIEW SORTED CURRENT AUCTIONS, OR
						            VIEW SORTED SOLD AUCTIONS 
		------------------------------------------------------------------------------------------------>
		<div class="form">	
			<h1>Welcome to the BuyMyFurniture Auctions!</h1>
		  	<br>
	
			
			<form>
			    <button formaction="createNewAuction/createNewAuction.jsp">Create a New Auction</button>
			</form>		
			<form>
			    <button formaction="viewAuctions/sortedAuctions/yourAuctions.jsp">Your Auctions</button>
			</form>				  	
			<form>
			    <button formaction="viewAuctions/sortedAuctions/auctionsCurrentlyIn.jsp">Active Auctions You Bid On</button>
			</form>	
							
			<br>
			<hr>
			<br>		  	  
			<form class="auctionHome" method="post" action="viewAuctions/checkAuctionSort.jsp">
				<h2 id="currentAuctions">View Current Auctions</h2>
				<p class="message">See the current items listed, with optional sorting preferences</p>
	   			<select name="viewSortedAuctions" required>
	   				<option value="all_Auctions">All Auctions</option>
	   				<option value="popular_Auctions">Popular Auctions</option>
					<option value="new_To_Old">Newest to Oldest</option>
					<option value="old_To_New">Oldest to Newest</option>
					<option value="bid_Asc">Current Bid Ascending</option>
					<option value="bid_Desc">Current Bid Descending</option>
					<option value="only_Chairs">Chairs Only</option>
					<option value="only_Lamps">Lamps Only</option>
					<option value="only_Tables">Tables Only</option>			
				</select>
		      	<input type="submit" value="View Auctions">
		    </form>	
		    <br>	  
		    <hr>
		    <br>
			<form class="auctionHome" method="post" action="viewAuctions/checkSoldAuctionSort.jsp">
				<h2 id="soldAuctions">View Sold Auctions</h2>
				<p class="message">See previously sold items, with optional sorting preferences</p>
	   			<select name="viewSoldSortedAuctions" required>
	   				<option value="all_Auctions">All Auctions</option>
	   				<option value="was_In">Auctions You Were In</option>
	   				<option value="popular_Auctions">Popular Auctions</option>
					<option value="new_To_Old">Newest to Oldest</option>
					<option value="old_To_New">Oldest to Newest</option>
					<option value="bid_Asc">Current Bid Ascending</option>
					<option value="bid_Desc">Current Bid Descending</option>
					<option value="only_Chairs">Chairs Only</option>
					<option value="only_Lamps">Lamps Only</option>
					<option value="only_Tables">Tables Only</option>
				</select>
		      	<input type="submit" value="View Auctions">
		    </form>	   
		</div>
		<div class="form">
			<form>
			    <button formaction="../home/home.jsp">Return Home</button>
			</form>	
		</div>
</body>
</html>

