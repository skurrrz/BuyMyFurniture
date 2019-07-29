<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
edit's a user's answers
 --------------------------------------------------------------------------------------->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Redirecting...</title>
	</head>
<body>

		<!-----------------------------------------------------------------------------------------------
			              PARAMETERS RECEIVED FROM createNewAnswer.jsp
		------------------------------------------------------------------------------------------------>		
		<%	
		int edit_AnswerID = Integer.parseInt(request.getParameter("edit_AnswerID"));
		String edit_answerContents = request.getParameter("edit_answerContents");
		
		if ((edit_answerContents.equals("****** Write new content here ******")) ||  
				(edit_answerContents.equals(""))){
			%>		
			<script> 
			    alert("Must write content to replace answer.");
		    	window.location.href = "../forumTools/createNewAnswer.jsp";
			</script>
			<%
		} 
		%>
		
		
		<!-----------------------------------------------------------------------------------------------
			     		           DELETE ANSWER FROM DATABASE
		------------------------------------------------------------------------------------------------>		
		<% 
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

				String editAnswer = "UPDATE Answers SET answerContents = '" + edit_answerContents + "'"
								+ " WHERE answerID LIKE '" + edit_AnswerID + "';";
				PreparedStatement ps = con.prepareStatement(editAnswer);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! The answer has been edited. Returning to Forum Home.");
			    	window.location.href = "../forumsHome.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			con.close();
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../forumTools/createNewAnswer.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>