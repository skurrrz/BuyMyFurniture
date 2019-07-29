<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!---------------------------------- HOW THIS WORKS -------------------------------------
see forumsHome.jsp for full details

Takes parameters from createNewQuestion and queries database for validation
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
			     PARAMETERS RECEIVED FROM createNewEmail.jsp
		------------------------------------------------------------------------------------------------>		
		<%
		String newAnswerContents = request.getParameter("answer_Contents");
		String newAnswerPoster = session.getAttribute("user_username").toString();
		
		int newQuestionID = Integer.parseInt(request.getParameter("answer_questionID"));
		int newAnswerID = (int)((new java.util.Date().getTime() / 1000L) % Integer.MAX_VALUE);

		java.sql.Timestamp newAnswerDatetime = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());
		
		
		%>
		<!-----------------------------------------------------------------------------------------------
			     		QUERIES DATABASE FOR EMAIL VALIDATION BEFORE INSERTING
		------------------------------------------------------------------------------------------------>		
		<% 
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();

			//Website should not allow empty fields, but this checks just in case
			 if ((newAnswerContents.equals(""))){
				%>
				<script> 
				    alert("All fields must contain information to be sent");
				    window.location.href = "../createNewAnswer.jsp";
				</script>
				<% 
				con.close();
			} 

			//3. DATA IS VALID >> Insert into database Questions table
				String insert = "INSERT INTO Answers (questionID, answerID, answerPoster, answerDatetime, answerContents)"
						+ " VALUES (?, ?, ?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);
				ps.setInt(1, newQuestionID);
				ps.setInt(2, newAnswerID);
				ps.setString(3, newAnswerPoster);
				ps.setTimestamp(4, newAnswerDatetime);
				ps.setString(5, newAnswerContents);
				ps.executeUpdate();
				con.close();

				%>		
				<script> 
				    alert("Success! Your reply has been posted.");
			    	window.location.href = "../../forumsHome.jsp";
				</script>
				<%
				
		} catch (Exception e) {
			%>
			con.close();
			<script> 
		    alert("Server Error: Please try again");
		    window.location.href = "../createNewAnswer.jsp";
			</script>
			<%	
		}
		%>

</body>
</html>