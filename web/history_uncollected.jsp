<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.OutputStream" %>

<%
	if(session.getAttribute("username") == null)			//check if session is logged in
		response.sendRedirect("index.jsp?status=4");		//if not redirect to loginpage with status 4
	else if(session.getAttribute("privilege").equals("2"))	//check if privilege of current user match with page they are accessing
		response.sendRedirect("admin_privilege.jsp");		//if not match prompt to privilege denied page
%>

<html>
	<head>
		<!---CSS Link--->
		<link rel="stylesheet" type="text/css" href="style25.css">
		<link rel="shortcut icon" href="images/xmux.png">
		<script
				src="http://code.jquery.com/jquery-3.5.1.min.js"
				integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
				crossorigin="anonymous">
		</script>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		<script>
			window.onload = function() {
				localStorage.setItem("page", "history");
				console.log(localStorage.getItem("page"));
			}
		</script>
		<style>
			th.highlightcA
			{
				background-image: url("images/asc.png");
				background-color: #3399FF;
				background-repeat: no-repeat;
				background-position: center right 5px;
			}
			th.highlightcD
			{
				background-image: url("images/desc.png");
				background-color: #3399FF;
				background-repeat: no-repeat;
				background-position: center right 5px;
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

		<%
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
			Statement stm = conn.createStatement();
			String sql = "select * from student where studentID = '" + session.getAttribute("username") + "'";
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

		<div class = "border profile" style="font-family: 'Times New Roman'">
			<div style="clear: both; height: 30px"></div>
			<table width = "100%" style = "padding: 8px; text-align: center;" cellpadding="2px">
				<tr><td> <img src="<%=propic%>.png" onerror="this.onerror=null; this.src='avatar.png'" alt="Profile Picture" class="profile_pic"> </td></tr>
				<tr><td><b><%=session.getAttribute("username")%></b></td></tr>
				<tr><td><b> <%=rs.getString("studentName")%> </b></td></tr>
			</table>
			<div style="clear: both; height: 30px"></div>
			<table width = "100%" style="text-align: center;" cellpadding="5px 0px">
				<tr><td>
					<a href="setting_user.jsp"><button class = "button"> Profile Settings </button></a>
				</td></tr>
				<tr><td>
					<a href="history.jsp"><button class = "button" style="border-left:2px solid black;">  History</button></a>
				</td></tr>
			</table>
		</div>

		<div class = "border settings">
			<div class = "selection">
				<table width = "100%" style="text-align: center;" cellpadding="3px 0px">
					<tr><td>
						<a href="history.jsp"><button class = "button"> All</button></a>
					</td></tr>
					<tr><td>
						<a href="history_uncollected.jsp"><button class = "button" style="border-left:2px solid black;"> Uncollected</button></a>
					</td></tr>
					<tr><td>
						<a href="history_ongoing.jsp"><button class = "button"> Pending</button></a>
					</td></tr>
					<tr><td>
						<a href="history_collected.jsp"><button class = "button"> Collected</button></a>
					</td></tr>
				</table>
			</div>
			<div class = "edit">
				<div style="text-align: center;">
					<h1 style="font-size: 2em"> Uncollected Parcels </h1> <!--Uncollected-->
					<hr>
				</div>
				<table class="table" width = "100%" cellpadding="6.5px"; style = "margin: 10px auto; padding: 5px" id="uncollected">
					<thead class="thead-inverse">
					<tr style="font-size:1.1em; background-color:#84a8e1;">
						<th width="10%"><b>No.</b></th>
						<th width="25%"><b>Tracking Number</b></th>
						<th width="15%"><b>Courier</b></th>
						<th width="20%"><b>Arrival Date</b></th>
						<th width="20%"><b>Collection Date</b></th>
						<th width="10%"><b>Status</b></th>
					</tr>
					</thead>
					<tbody>
						<%
							sql = "select * from parcel where status = 'Ready' and (student_ID = '" + session.getAttribute("username") + "')";
							rs = stm.executeQuery(sql);
							int counter = 0;
							while(rs.next()) {
								counter++;
								if(counter%2 == 0) {
						%>
									<tr>
										<td><b><%out.print(counter);%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("dateReceived")%></td>
										<td><%=rs.getString("datePickup")%></td>
										<td><%=rs.getString("status")%></td>
									</tr>
						<%
								}
								else{
						%>
									<tr>
										<td><b><%out.print(counter);%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("dateReceived")%></td>
										<td><%=rs.getString("datePickup")%></td>
										<td><%=rs.getString("status")%></td>
									</tr>
						<%
								}
							}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div> <!---End of wrap--->

	<!---Footer--->
	<footer style="margin-top: -29px">
	<img src = "images/logo.png" class ="bottomleft">
		<div style = "padding: 15px;">
			Copyright 2020, Xiamen University Malaysia <br/>
			JTT Development Team
		</div>
	</footer>
		
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
	</body>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/tableSorter2.js"></script>
</html>