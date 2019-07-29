<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!-- 
Displays all answers to a question
and gives user a form to post a reply
 -->
 
 
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Forums</title>
	</head>

<body>	

	<!-----------------------------------------------------------------------------------------------
				        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
	------------------------------------------------------------------------------------------------>
	<p class="app-name"><a href="../../home/home.jsp"><img src="../../images/websiteLogo.png"></a></p>      		
		
		
	<!-----------------------------------------------------------------------------------------------
			   		          QUERY DATABASE TO GET INFORMATION ABOUT QUESTION
	------------------------------------------------------------------------------------------------>		
	<% 		
	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();

		String thisQuestionID = request.getParameter("questionID");
		
		%>
		<!-----------------------------------------------------------------------------------------------
				   							QUESTION INFORMATION
		------------------------------------------------------------------------------------------------>	
		<%	
		String questionQuery= "SELECT * FROM Questions WHERE questionID LIKE '" + thisQuestionID + "';";	
		ResultSet res = stmt.executeQuery(questionQuery);	
		res.next();
		
			out.print("<div class='form'>");
			String thisQuestionSubject = res.getString("questionSubject");
			String thisQuestionContent = res.getString("questionContent");
			%>
			<h1>Question #<%=thisQuestionID%></h1>
				<%
				out.print("<strong>Posted By: </strong>" + res.getString("questionPoster"));
				%>
				<br>
				<% 
				out.print("<strong>Subject: </strong>" + thisQuestionSubject);
				%>
				<br>
				<%
				out.print("<strong>Date Posted: </strong>" + res.getTimestamp("questionDatetime"));	
				%>
				<br>
				<% 
				out.print("<strong>Question: </strong>" + thisQuestionContent);	
				%>
				<br>
				<hr>
				<%
				if (session.getAttribute("user_type").toString().equals("rep")){
				%>
				<h3>REP FUNCTIONS:</h3>
					<form action="../repTools/repDeleteQuestion.jsp">
						  <input type="hidden" name="delete_QuestionID" value="<%=thisQuestionID%>">
						  <input type="submit" value="Delete this Question" >
						  <p class="message">This cannot be undone</p>
					</form>
					<hr>
					<form action="../repTools/repEditQuestion.jsp">
						  <input type="hidden" name="edit_QuestionID" value="<%=thisQuestionID%>">
						  <input type="text" name="edit_QuestionSubject" placeholder="****** Write new subject here ******" style="width:400px">
						  <input type="text" name="edit_QuestionContent" placeholder="****** Write new content here ******" style="width:400px">
						  <input type="submit" value="Edit this Question" >
						  <p class="message">*Make any edits, then click submit to update</p>
						  <p class="message">*Subject must be less than 50 characters</p>
						  <p class="message">*Question content must be less than 200 characters.</p>
					</form>		
					<hr>
				<%				
				}
				out.print("</div>");
		%>

		<!-----------------------------------------------------------------------------------------------
	                                    SUBMIT RESPONSE FORM
		------------------------------------------------------------------------------------------------>
		<%
		int thisQuestionIDint = Integer.parseInt(request.getParameter("questionID"));
		%>		
		<div class="form">
		<h2> Reply to this Question </h2>
			<form action="check/checkNewAnswer.jsp" method="get">
				<input type="hidden" name="answer_questionID" value="<%=thisQuestionIDint%>" required/>
				<input type="text" placeholder = "Enter your reply here" name="answer_Contents" maxlength="200" required/>
				<input type="submit" value="Submit Reply"/>
				<p class="message">*Reply message cannot be more than 200 characters.</p>
			</form>
		</div>

		<!-----------------------------------------------------------------------------------------------
   										   ANSWERS TABLE
		------------------------------------------------------------------------------------------------>	
		<%	
		String answerQuery= "SELECT * FROM Answers WHERE questionID LIKE '" + thisQuestionID + "' ORDER"
				+ " BY answerDatetime DESC;";	
		ResultSet res2 = stmt.executeQuery(answerQuery);	
		
		out.print("<div class='form'>");
		if (res2.next()){	
			res2.beforeFirst();
			%>
			<h1>Answers to This Question: </h1>
			<hr>
			<%
			while (res2.next()){	
				int thisAnswerID = res2.getInt("answerID");
				out.print("<strong>Answer: #</strong>" + res2.getInt("answerID"));	
				%>
				<br>
				<% 
				out.print("<strong>User: </strong>" + res2.getString("answerPoster"));	
				%>
				<br>
				<% 
				out.print("<strong>Date Replied:</strong> " + res2.getTimestamp("answerDatetime"));	
				%>
				<br>
				<% 
				out.print("<strong>Answer:</strong> " + res2.getString("answerContents"));	
				%>
				<br>
				<hr>
				<%
				if (session.getAttribute("user_type").toString().equals("rep")){
				%>
				<hr>
				<h3>REP FUNCTIONS:</h3>
					<form action="../repTools/repDeleteAnswer.jsp">
						  <input type="hidden" name="delete_AnswerID" value="<%=thisAnswerID%>">
						  <input type="submit" value="Delete this Answer" >
						  <p class="message">*This cannot be undone</p>
					</form>
					<hr>
					<form action="../repTools/repEditAnswer.jsp">
						  <input type="hidden" name="edit_AnswerID" value="<%=thisAnswerID%>">
						  <input type="text" name="edit_answerContents" placeholder="****** Write new content here ******" style="width:400px">
						  <input type="submit" value="Edit this Question" >
						  <p class="message">*Make any edits, then click submit to update</p>
						  <p class="message">*Subject must be less than 50 characters</p>
						  <p class="message">*Question content must be less than 200 characters.</p>
					</form>		
					<hr>
				<%				
				}
				%>
				<hr>
			<% 	
			}
			con.close();
			out.print("</div>");

		} else {
			%>
			<h2>Answers to This Question: </h2>
			<hr>
			<%
			out.print("There are currently no answers to this question.");		
			con.close();
			out.print("</div>");
		}
		%>

		<!-----------------------------------------------------------------------------------------------
			   		          RETURN HOME // EXCEPTIONS
		------------------------------------------------------------------------------------------------>	
		<div class='form'>
		  	<form>
		 		<button formaction="../forumsHome.jsp">Return to Forums Home</button>
			 	<button formaction="../../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>	
	
	<%
    } catch (Exception e) {
		%>
		<script> 
	    alert("Server Error: Please try again");
	    window.location.href = "../forumsHome.jsp";
		</script>
		<%
	}
	%>

</body>
</html>