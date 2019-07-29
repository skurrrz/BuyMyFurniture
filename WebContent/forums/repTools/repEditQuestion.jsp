<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
edit's a user's question
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
		int edit_QuestionID = Integer.parseInt(request.getParameter("edit_QuestionID"));
		String edit_QuestionContent = request.getParameter("edit_QuestionContent");
		String edit_QuestionSubject = request.getParameter("edit_QuestionSubject");
		
		if ((edit_QuestionContent.equals("****** Write new content here ******")) ||  
				(edit_QuestionContent.equals(""))){
			%>		
			<script> 
			    alert("You must write a new subject to replace the old one.");
		    	window.location.href = "../forumsHome.jsp";
			</script>
			<%
		} else if((edit_QuestionSubject.equals("****** Write new content here ******")) ||  
				(edit_QuestionSubject.equals(""))){
			%>		
			<script> 
			    alert("You must write a new message to replace the old one.");
		    	window.location.href = "../forumsHome.jsp";
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

				String editAnswer = "UPDATE Questions SET questionSubject = ?, questionContent = ? WHERE"
						+ " questionID LIKE '" + edit_QuestionID + "';";
				PreparedStatement ps = con.prepareStatement(editAnswer);
				ps.setString(1, edit_QuestionSubject);
				ps.setString(2, edit_QuestionContent);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! The question has been edited. Returning to Forum Home.");
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