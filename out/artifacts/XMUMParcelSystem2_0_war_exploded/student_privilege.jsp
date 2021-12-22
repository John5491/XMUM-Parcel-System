<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>

<%
	if(session.getAttribute("username") == null)			//check if session is logged in
		response.sendRedirect("index.jsp?status=4");		//if not redirect to loginpage with status 4
	else if(session.getAttribute("privilege").equals("2"))	//check if privilege of current user match with page they are accessing
		response.sendRedirect("admin_privilege.jsp");		//if not match prompt to privilege denied page
%>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="style25.css">
		<link rel="shortcut icon" href="images/xmux.png">
		<script
				src="http://code.jquery.com/jquery-3.5.1.min.js"
				integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
				crossorigin="anonymous">
		</script>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		<style>
			.privilege
			{
				background-image: url("images/student_privillege.png");
				max-height: 100%;
				max-width: 100%;
				background-repeat: no-repeat;
				padding-top: 570px;
				background-position: center;
			}
		</style>
	</head>

	<body>
	<div class = "content-wrap">
		<!---Header--->
		<header>
			<div class = "header" style="height: 100px">
				<table width = "100%" >
					<tr>
						<td width = "30%" style="padding-left: 20px">
							<div class = "title">
								<button class = "homeButton" onclick="location.href='home_student_all.jsp'">
									<i class="fas fa-boxes" style = "color:white"></i> XMUM Parcel System  </a>
								</button>
							</div>
						</td>
						<td width = "30%" style = "text-align: right;">
							<div class = "dropdown">
								<img src="<%=session.getAttribute("username")%>.png" onerror="this.onerror=null; this.src='avatar.png'" class="profileIcon" style="margin-top: 15px;">
								<div class="dropdown_content">
									<a href = "notice.jsp">Notice </a>
									<a href="setting_user.jsp">Settings</a> <!---Update links!!!!--->
									<a href="history.jsp">History</a>
									<a href="LogoutServlet">Log out</a>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</header>


			<div class="privilege">
				<div style="text-align: center">
						<button style="
								padding: 5px;
								border: none;
								border-radius: 25px;
								display: inline-block;
								background-color: #292b2c;
								width: 100px;
								font-size: 1.2em;
								color: white;"
								 onclick="window.location='home_student_all.jsp'">
							Go Back
						</button>
				</div>
			</div> <!---End of wrap--->
	</div>
		<!---Footer--->
			<footer style="position: absolute">
			<img src = "images/logo.png" class ="bottomleft">
				<div style = "padding: 15px;">
					Copyright 2020, Xiamen University Malaysia <br/>
					JTT Development Team
				</div>
			</footer>

			<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
	</body>
</html>