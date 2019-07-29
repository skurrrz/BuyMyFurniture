<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!---------------------------------- HOW THIS WORKS -------------------------------------
1. forumsHome.jsp
	- displays a list of all questions in order newest to oldest
	- Can "View Question Thread" to see list of answers
	- Can create new Question and post it
	
2A. createNewQuestion.jsp
	- Sends user to a form where they can create a new question
2B. checkNewQuestion.jsp
	- Checks for validation and inserts into DB
	
3A. createNewAnswer.jsp
	- This displays the current question and a thread of all answers, newest to oldest
	- displays a form for the user to write an answer
3B. checkNewAnswer.jsp
	- checks for validation and inserts into DB
	
4. repTools let anyone who is a rep delete or edit questions and answers
 --------------------------------------------------------------------------------------->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		 <link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta charset="UTF-8">
		<title>Forums</title>
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
			                             TABLE DISPLAYING OPTIONS
		------------------------------------------------------------------------------------------------>

		<div class='form'>
			<h1>BuyMyFurniture Forums</h1>
			<hr>
			<form>
				<button formaction="forumTools/createNewQuestion.jsp">Post a New Question</button>
			</form>	  	
			<br>
			<form>
				<button formaction="forumTools/searchForums.jsp">Search Forums</button>
			</form>	 
		</div>
		
		
		
		<!-----------------------------------------------------------------------------------------------
			                       TABLE DISPLAYING RECENT QUESTIONS
		------------------------------------------------------------------------------------------------>
		<%
		String emailRecipient = session.getAttribute("user_username").toString();
		
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//QUERY: Generate a list of newest Questions (only title shows, user can click to see more)
			String findQuestions = "SELECT * FROM Questions ORDER BY questionDatetime DESC;";
			ResultSet res = stmt.executeQuery(findQuestions);	
			
			%>
			<!-----------------------------------------------------------------------------------------------
			                       IF ANY RESULTS: DISPLAY TOP 10 MOST RECENT POSTS
			------------------------------------------------------------------------------------------------>
				<% 
			out.print("<div class='form'>");	
			if(res.next()) {
				res.beforeFirst();
				int i = 1;
				%>
				<h1>10 Most Recent Questions</h1>
				<hr>
				<% 
			
				while (res.next() && (i < 11)) {
					int questionID = res.getInt("questionID");
					
					out.print("<strong>" + i + ". Question #</strong>" + questionID);			
					%>
					<br>
					<% 
					out.print("<strong>Posted By: </strong>" + res.getString("questionPoster"));
					%>
					<br>
					<% 
					out.print("<strong>Posted On: </strong>" + res.getTimestamp("questionDatetime"));
					%>
					<br>
					<% 
					out.print("<strong>Subject: </strong>" + res.getString("questionSubject"));
					%>
					<br><br>
					<form action="forumTools/createNewAnswer.jsp" method="get">
						  <input type="hidden" name="questionID" value="<%=questionID%>">
						  <input type="submit" value="View Question" style="height:50px; width:200px">
					</form>
					<hr>
					<% 
					i++; 
				}
				con.close();
				%>
				<br>
				<%
				out.print("</div>");	
				%>
				
			<!-----------------------------------------------------------------------------------------------
			                       ELSE: NO QUESTIONS POSTED
			------------------------------------------------------------------------------------------------>
		<% 	
		} else {
			out.print("There are currently no questions posted.");		
			con.close();
		}
		%>
		</div>
		<div class='form'>
			<form>
				<button formaction="../home/home.jsp">Return Home</button>
			</form>	  
		</div>
		
		<%
		} catch (Exception e) {
			%>
			<script> 
		    alert("Server Error: An unexpected error has occurred. Please try again.");
		    window.location.href = "../home/home.jsp";
			</script>
		<%	
		}
		%>

</body>
</html>	