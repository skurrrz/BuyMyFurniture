<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
see forumsHome.jsp for full details

Takes parameters from searchForums and queries database for validation
 --------------------------------------------------------------------------------------->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Redirecting...</title>
	</head>
	
<body>
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../../../home/home.jsp"><img src="../../../images/websiteLogo.png"></a></p>
	
	
	
		<!-----------------------------------------------------------------------------------------------
			                    KEYWORD PARAMETERS FROM searchForums.jsp
		------------------------------------------------------------------------------------------------>
		<%
		String newKeyWord1 = request.getParameter("keyword1");
		String newKeyWord2 = request.getParameter("keyword2");
		String newKeyWord3 = request.getParameter("keyword3");
		String newKeyWord4 = request.getParameter("keyword4");
		String newKeyWord5 = request.getParameter("keyword5");

		
		%>
		<!-----------------------------------------------------------------------------------------------
			        QUERIES THE DATABASE FOR MATCHING POSTS, THEN DISPLAYS FOR USER
		------------------------------------------------------------------------------------------------>		
<%
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();
						
				String searchForums = "SELECT * FROM Questions WHERE questionSubject LIKE '%" + newKeyWord1 + "%' AND"
										+ " questionContent LIKE '%" + newKeyWord2 + "%' AND questionContent LIKE '%" + newKeyWord3 + "%' AND"
										+ " questionContent LIKE '%" + newKeyWord4 + "%' AND questionContent LIKE '%" + newKeyWord5 + "%'"
										+ "ORDER BY questionDatetime DESC;";							
				ResultSet res = stmt.executeQuery(searchForums);	
				
				%>
				<!----------------------  DISPLAYS ANY QUESTIONS FOUND  --------------------------->
				<% 	
				if(res.next()) {
					res.beforeFirst();
					int i = 1;
					out.print("<div class='form'>");	
					%>
					<h1>Questions containing keywords: </h1>
					<hr>	
					<%
					while (res.next()) {
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
						<form action="../createNewAnswer.jsp" method="get">
							  <input type="hidden" name="questionID" value="<%=questionID%>">
							  <input type="submit" value="View Question" style="height:50px; width:200px">
						</form>
						<hr>
						<% 
						i++; 
					}
				out.print("</div>");
				} else {
					%>
					<div class ='form'>
					<h2>No questions were found containing these keywords</h2>
					</div>			
					<% 
				}
				
				
				%>
				<!---------------------- DISPLAYS ANY ANSWERS  --------------------------->
				<% 	
			
				String searchAnswers = "SELECT * FROM Answers WHERE answerContents LIKE '%" + newKeyWord1 + "%' AND"
						+ " answerContents LIKE '%" + newKeyWord2 + "%' AND answerContents LIKE '%" + newKeyWord3 + "%' AND"
						+ " answerContents LIKE '%" + newKeyWord4 + "%' AND answerContents LIKE '%" + newKeyWord5 + "%'"
						+ "ORDER BY answerDatetime DESC;";							
				ResultSet res2 = stmt.executeQuery(searchAnswers);			

				if(res2.next()) {
					res2.beforeFirst();
					int i = 1;
					out.print("<div class='form'>");	
					%>
					<h1>Answers containing key words:</h1>
					<hr>	
					<%
					while (res.next()) {
						int questionID = res2.getInt("questionID");
						
						out.print("<strong>" + i + ". Question #</strong>" + questionID);			
						%>
						<br>
						<% 
						out.print("<strong>Posted By: </strong>" + res2.getString("answerPoster"));
						%>
						<br>
						<% 
						out.print("<strong>Posted On: </strong>" + res2.getTimestamp("answerDatetime"));
						%>
						<br>
						<% 
						out.print("<strong>Subject: </strong>" + res2.getString("answerContents"));
						%>
						<br><br>
						<form action="../createNewAnswer.jsp" method="get">
							  <input type="hidden" name="questionID" value="<%=questionID%>">
							  <input type="submit" value="View Original Question" style="height:50px; width:200px">
						</form>
						<hr>
						<% 
						i++; 
					}
				out.print("</div>");
			
				con.close();
				%>
				
					<div class='form'>
					  	<form>
					 		<button formaction="../searchForums.jsp">Search Again</button>
						 	<button formaction="../../../home/home.jsp">Return Home</button>
					  	</form>	  	
					</div>
				
				<%
				} else {
					%>
					<div class ='form'>
					<h2>No answers were found containing these keywords</h2>
					</div>
					<div class='form'>
					  	<form>
					 		<button formaction="../searchForums.jsp">Search Again</button>
						 	<button formaction="../../../home/home.jsp">Return Home</button>
					  	</form>	  	
					</div>
					<% 
				}
				
				
			%>
			<!---------------------- ELSE: GIVE ERROR ALERT AND RETURN ---------------------------------->
			<%
			
		} catch (Exception ex) {
			%> 
	
			<script> 
				alert(" Exception: An unexpected error has occurred. Please try again.");
			    window.location.href = "../searchForums.jsp";
			</script>
			<%
		}
		%>

</body>
</html>