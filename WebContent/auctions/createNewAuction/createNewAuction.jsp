<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!--               HOW createNewAuction WORKS

Written by: Shelby Kurz 4/19/2019
On User's homepage >> Selects "Auctions" and then "Create an Auction"

1. createNewAuction.jsp
	- Prompts User to pick which type of category they want to post
		(Chair, Table, or Lamp)
		
2. getAuctionInfo.jsp
	- Website checks which item was selected then provide information boxes 
		for the user to either select or input information
	- in addition to having shared information, each category has two unique
		attributes
		
3. checkAuction.jsp
	- This checks that information from 3 is valid for the database, sets information
		such as Auction End Date, creates closing event for Database, and sets a 
		Timeout script to run when the Auction closes (End Results are then determined
		and ifSold, update DB and email both seller and bidder, else just email seller)
	* Note that all Alerts for Bidding is handled in the createBid files
	
	AUCTION CLOSING PROCEDURE: in checkAuction.jsp

 -->


<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			        CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATIOD
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auctions</title>
	</head>
<body>

		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>      	



		<!-----------------------------------------------------------------------------------------------
			        Provides a selection form for the User to pick what type of item they want to sell
		------------------------------------------------------------------------------------------------>

	  <div class="form">
	    <form method="post" action="getAuctionInfo.jsp">
	    <h2>What kind of item do you want to sell? </h2>
   			<select name="item_category" required>
   				<option value="null">Select Item Type</option>
				<option value="chair">Chair</option>
				<option value="table">Table</option>
				<option value="lamp">Lamp</option>
			</select>
	 	    <input type="submit" value="Continue">
	    </form>
	  </div>
	  <div class='form'>
		  	<form>
		 		<button formaction="../auctionsHome.jsp">Return to Auction Home</button>
			 	<button formaction="../../home/home.jsp">Return Home</button>
		  	</form>	  	  
	  </div>

</body>
</html>