<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html >
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta charset="UTF-8">
		<title>Reports</title>
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
		
		
		<!-----------------------------------------------------------------------------------------------
					                     GENERATE REPORT
		------------------------------------------------------------------------------------------------>
		
		<%
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//QUERY: Generate a list of all sold Auctions and their highest bid, then return a sum of all of those highest bids
			String query= "SELECT SUM(t1.soldPrice) AS totalEarnings FROM (SELECT a.auctionID, MAX(b.bid_Amount) AS soldPrice FROM Auctions a LEFT JOIN Bids b ON a.auctionID = b.auctionID WHERE a.wasSold LIKE '1' GROUP BY auctionID) AS t1;";
			ResultSet res = stmt.executeQuery(query);	
			
			if(res.next()){	
				res.beforeFirst();
				out.print("<div class='form'>");
				int i = 1;
				%>
				<h1>Total Overall Earnings</h1>
				<hr>
				<br>
				<%
				while (res.next()) {	
					out.print( "The sum of all sales that have occured is: $" +  String.format("%.02f", (res.getDouble("totalEarnings"))) + ".");
				}
				out.print("</div>");
				con.close();
				%>
	
			<div class='form'>
			<form>
				<button formaction="adminToolsHome.jsp">Generate Another Report</button>
			</form>
			<form>
				<button formaction="../../home/home.jsp">Return Home</button>
			</form>	 		
			</div>	
			
			<%	
			} else {	
				%>
				<div class='form'>
				<h1>Total Overall Earnings</h1>
				<%
				out.print("There have not been any sales.");	
				%>
				</div>
				<div class='form'>
					<form>
				    	<button formaction="adminToolsHome.jsp">Generate Another Report</button>
					</form>
					<form>
				    	<button formaction="../../home/home.jsp">Return Home</button>
					</form>	 		
				</div>	
				<%
				con.close();
			}
		} catch (Exception e) {
			%>
			<script> 
			alert("Server Error: An unexpected error has occurred. Please try again.");
			window.location.href = "adminToolsHome.jsp";
			</script>
			<%			
		}
		%>
		
</body>
</html>