
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!-----------------------------------------------------------------------------------------------
			        ENDS USER'S CURRENT SESSION AND RETURNS TO login.jsp
------------------------------------------------------------------------------------------------>
<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>	
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta charset="UTF-8">
		<title>Redirecting...</title>
	</head>

<body>

	<%
		session.invalidate();
		response.sendRedirect("../login.jsp");
	%>


</body>
</html>
