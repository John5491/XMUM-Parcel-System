<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.OutputStream" %>

<%
	if(session.getAttribute("username") == null)
		response.sendRedirect("index.jsp?status=4");
	else if(session.getAttribute("privilege").equals("1"))
		response.sendRedirect("student_privilege.jsp");
%>
<html>
	<head>
		<!---CSS Link--->
		<link rel="stylesheet" type="text/css" href="style25.css">
		<link rel="shortcut icon" href="images/xmux.png">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
	</head>

	<body>
	<div class = "content-wrap" style="font-family: 'Times New Roman'">
		<!--Header-->
		<header>
			<div class = "header" style="height: 100px">
				<table width = "100%" >
					<tr>
						<td width = "30%" style="padding-left: 20px">
							<div class = "title">
								<button class = "homeButton" onclick="location.href='admin_home.jsp'">
									<i class="fas fa-boxes" style = "color:white"></i>
									XMUM Parcel System
								</button>
							</div>
						</td>
						<td width = "15%" style = "text-align: center;"><div class="title" style="font-size: 25px"><button class = "homeButton" onclick="location.href='admin_students.jsp'">
							<i class="fas fa-users"></i> Students </button> </div>
						</td>
						<td width = "15%" style = "text-align: center;"> <div class="title" style="font-size: 25px"><button class = "homeButton" onclick="location.href='admin_notice.jsp'">
							<i class="fas fa-exclamation"></i> Notice </button> </div>
						</td>
						<td width = "30%" style = "text-align: right;">
							<div class = "dropdown">
								<img src="<%=session.getAttribute("username")%>.png" onerror="this.onerror=null; this.src='avatar.png'" class="profileIcon" style="margin-top: 15px;">
								<div class="dropdown_content">
									<a href="admin_settings.jsp">Settings</a> <!---links!!!!--->
									<a href="admin_history.jsp">History</a>
									<a href="LogoutServlet">Log out</a>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</header>

			<%
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
				Statement stm = conn.createStatement();
				String sql = "select * from manager where managerID = '" + session.getAttribute("username") + "'";
				ResultSet rs = stm.executeQuery(sql);
				rs.next();
				String propic = "avatar";				//set default profile picture name
				if(rs.getBlob("imageSource") != null) {
					if (rs.getBlob("imageSource").length() != 0) {    //if user update profile picture we retrieve the binary and decode it
						byte[] buffer = rs.getBlob("imageSource").getBytes(1, (int) rs.getBlob("imageSource").length());
						//change the image format to always png
						String path = request.getSession().getServletContext().getRealPath("/" + session.getAttribute("username") + ".png");
						OutputStream os = new FileOutputStream(path);
						os.write(buffer);
						os.flush();
						os.close();
						//update the profile picture name
						propic = (String) session.getAttribute("username");
					}
				}
			%>

		<div class = "border profile">
			<div style="clear: both; height: 30px"></div>
			<table width = "100%" style = "padding: 8px; text-align: center;" cellpadding="2px">
				<tr><td> <img src="<%=propic%>.png" onerror="this.onerror=null; this.src='avatar.png'" alt="Profile Picture" class="profile_pic"> </td></tr>
				<tr><td><b><%=session.getAttribute("username")%></b></td></tr>
				<tr><td><b> <%=rs.getString("managerName")%> </b></td></tr>
			</table>
			<div style="clear: both; height: 30px"></div>
			<table width = "100%" style="text-align: center;" cellpadding="5px 0px">
				<tr><td>
					<a href="admin_settings.jsp"><button class = "button" style="border-left:2px solid black;"> Profile Settings </button> </a><!--link-->
				</td></tr>
				<tr><td>
					<a href="admin_history.jsp"><button class = "button">  History</button></a> <!--link-->
				</td></tr>
			</table>
		</div>

			<div class = "border settings">
				<div class = "selection">
					<table width = "100%" style="text-align: center;"cellpadding="3px 0px">
						<tr><td>
							<a href="admin_settings.jsp"><button class = "button"> Edit Profile </button></a>
						</td></tr>
						<tr><td>
							<a href="admin_password.jsp?status="><button class = "button" style="border-left:2px solid black;"> Change Password</button></a>
						</td></tr>
					</table>
				</div>
				<div class = "edit">
					<table width = "100%" cellpadding= "15px;" style="text-align: center; width: 50%">
						<tr>
							<td style=" width: 9%">
								<img src="<%=propic%>.png" onerror="this.onerror=null; this.src='avatar.png'" alt="Profile Picture" class="small_pic">
							</td>
							<td style="font-size: 30px; width: 91%">
								<%=rs.getString("managerName")%>
							</td>
						</tr>
					</table>
					<form id="chngpass" method="post" action="AdminChangePasswordServlet">
						<table class = "edit_font" cellpadding= "15px;" width = "50%"  > <!--change password table!!!!-->
							<tr>
								<td style=" width: 39%"> <!--bottom will follow width-->
									Old Password:
								</td>
								<td>
									<input name="oldp" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
									class = "og_data">
								</td>
							</tr>
							<tr>
								<td>New Password:</td>
								<td>
									<input name="newp" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
									class = "og_data">
								</td>
							</tr>
							<tr>
								<td>Confirm New Password:</td>
								<td>
									<input name="cnewp" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
									class = "og_data">
								</td>
							</tr>
						</table>
					</form>
					<%
						if(request.getParameter("status").equals("1"))
						{
					%>
							<div style="color:red; text-align: center; padding: 10px; margin-right: 570px">
								Confirm Password and New Password Does Not Match
							</div>
					<%
						}
						else if(request.getParameter("status").equals("2"))
						{
					%>
							<div style="color:red; text-align: center; padding: 10px;margin-right: 570px">
								Incorrect Old Password Entered
							</div>
					<%
						}
						else if(request.getParameter("status").equals("3"))
						{
					%>
							<div style="color:green; text-align: center; padding: 10px; margin-right: 570px">
								Password Succcessfully Changed
							</div>
					<%
						}
						else
						{
					%>
							<div style="height:44px; clear:both;"></div>
					<%
						}
					%>
					<div style="width:75%; text-align: center; padding: 10px;">
						<button class="button_save" onclick="document.getElementById('chngpass').submit()">
							Change Password <!--change password!!!!-->
						</button>
					</div>
				</div>
			</div>
	</div> <!---End of wrap--->

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