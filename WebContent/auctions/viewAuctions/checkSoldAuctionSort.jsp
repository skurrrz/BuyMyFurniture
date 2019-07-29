<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
See auctions/auctionsHome for full details about this folder

This page takes the choice the user made in auctionsHome.jsp, redirects to the view file
stored in sortedSoldAuctions folder, and displays the sold auctions in the desired 
sorted order
 --------------------------------------------------------------------------------------->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auctions</title>
	</head>
	
<body>

	<!-----------------------------------------------------------------------------------------------
			   SORTED PREFERENCES PARAMETERS RECEIVED FROM auctions/auctionsHome.jsp
			   THIS REDIRECTS USERS TO A PAGE WHERE SORTED AUCTIONS ARE DISPLAYED
	------------------------------------------------------------------------------------------------>
	<%
	String newAuctionItemCategory = request.getParameter("viewSoldSortedAuctions");
	
	try {
		//REDIRECT TO ALL SOLD AUCTIONS
		if(newAuctionItemCategory.equals("all_Auctions")){
			%> 
			<script> 
			    window.location.href = "sortedSoldAuctions/viewSoldAuctions.jsp";
			</script>
			<%
			return;
		} else if(newAuctionItemCategory.equals("was_In")){
			%> 
			<script> 
			    window.location.href = "sortedSoldAuctions/soldAuctionsIn.jsp";
			</script>
			<%
			return;
			
		//REDIRECT TO POPULAR SOLD AUCTIONS
		} else if (newAuctionItemCategory.equals("popular_Auctions")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldPopularAuctions.jsp";
			</script>
			 <%
			 
		//REDIRECT TO NEW TO OLD SOLD AUCTIONS
		} else if (newAuctionItemCategory.equals("new_To_Old")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldNewToOld.jsp";
			</script>
			 <%
			 
		//REDIRECT TO OLD TO NEW SOLD AUCTIONS
		} else if (newAuctionItemCategory.equals("old_To_New")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldOldToNew.jsp";
			</script>
			 <%

		//REDIRECT TO AUCTIONS WITH SOLD BID ASCENDING
		} else if (newAuctionItemCategory.equals("bid_Asc")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldBidsAsc.jsp";
			</script>
			 <%
		
		//REDIRECT TO AUCTIONS WITH SOLD BID DESCENDING	 
		} else if (newAuctionItemCategory.equals("bid_Desc")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldBidsDesc.jsp";
			</script>
			 <%
			
		//REDIRECT TO ONLY SOLD CHAIR AUCTIONS	 
		} else if (newAuctionItemCategory.equals("only_Chairs")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldOnlyChairs.jsp";
			</script>
			 <%
			 
		//REDIRECT TO ONLY SOLD LAMP AUCTIONS	 
		} else if (newAuctionItemCategory.equals("only_Lamps")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldOnlyLamps.jsp";
			</script>
			 <%
			 
		//REDIRECT TO ONLY SOLD TABLE AUCTIONS	 
		} else if (newAuctionItemCategory.equals("only_Tables")) {
			%>
			<script> 
	    	window.location.href = "sortedSoldAuctions/viewSoldOnlyTables.jsp";
			</script>
			 <%
			 			 
		//IN CASE OF ERROR REDIRECT BACK TO AUCTION HOME
		} else {
			%> 
			<script>
			    alert("Error: Please select a sorting preference from the list");
			    window.location.href = "../auctionsHome.jsp";
			</script>
			<%	
		}
		
		
	} catch (Exception ex) {
		%> 
		<script> 
		    alert("An unexpected error has occurred. Please try again.");
		    window.location.href = "../auctionsHome.jsp";
		</script>
		<%
	}
	%>
</body>
</html>