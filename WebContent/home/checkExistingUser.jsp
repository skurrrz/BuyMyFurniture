<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!-- 
HOW THIS WORKS
This is step 2A of "home" (See login.jsp for description of entire home folder)
	- If a User logs in, it redirects here to check with the database that the username
		exists and the password is correct for this account
	- Success will create a new session and redirect to home.jsp, repHome.jsp, or adminHome.jsp
		depending on their account details
	- Any failures redirects back to login.jsp
 -->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Redirecting...</title>
	</head>
<body>
		<!-----------------------------------------------------------------------------------------------
			     QUERY DATABASE TO SEE IF THE USERNAME + PASSWORD EXISTS
		------------------------------------------------------------------------------------------------>	
		<%
		try {
			String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
			Statement stmt = con.createStatement();
			
		    String setDatabase = "Use BuyMyFurniture;";
			ResultSet checkSetDatabase = stmt.executeQuery(setDatabase);
			
			String loginUsername = request.getParameter("user_username");
			String loginPassword = request.getParameter("user_password");
		    
			//CHECK if username or password fields is blank
			//Website should check this, but this is just in case
			 if ((loginUsername.equals(""))&&(loginPassword.equals(""))){
				%>
				<script> 
				    alert("Please enter your email and password");
				    window.location.href = "../login.jsp";
				</script>
				<% 
				con.close();
				return;
			
			//QUERY DATABASE to see if username + password exist in a tuple
			} else {
				String checkForUser = "SELECT * FROM Users u WHERE u.username ='" + loginUsername + "' and u.password='" + loginPassword + "'";
				ResultSet result = stmt.executeQuery(checkForUser);
	
				//If User exists:
				if (result.next()) {
						
					//Checks if User+password is locked
						if((result.getObject("locked") == null) || (result.getInt("locked") == 0)){
							
								//Checks if user is a non-Representative User
								if((result.getObject("isRep") == null) || (result.getInt("isRep") == 0)){
									session.setAttribute("user_username", loginUsername);
									session.setAttribute("user_type", "user");
									%>
									<script> 
							    		window.location.href = "home.jsp";
									</script>
									 <%
									 con.close();
									 return;
									 
								//checks if User is the Rep	 
								} else {
									session.setAttribute("user_username", loginUsername);
									session.setAttribute("user_type", "rep");
									%>
									<script> 
							    		window.location.href = "home.jsp";
									</script>
									<%	
									con.close();
									return;
								}

					//if User is locked, then deny login and return to login screen	
					} else if (result.getInt("locked") == 1){
							%>
							<script> 
							    alert("Your account is currently locked. Please try again at a future time.");
							    window.location.href = "../login.jsp";
							</script>
							<%		
							con.close();
						    return;
					}	
				//Else user+password does not exsit
				} else {
					%>
					<script> 
					    alert("Username or password cannot be found, please try again.");
					    window.location.href = "../login.jsp";
					</script>
					<%
					con.close();
				    return;
				}
			}
			
		} catch (Exception e) {
			%>
			<script> 
			    alert("Server Error: Please try again");
			    window.location.href = "../login.jsp";
			</script>
			<%			
		}
		%>

</body>
</html>