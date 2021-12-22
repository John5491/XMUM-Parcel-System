<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
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
		<script
				src="http://code.jquery.com/jquery-3.5.1.min.js"
				integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
				crossorigin="anonymous">
		</script>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		<script>
			window.onload = function() {
				localStorage.clear();
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


			<div class = "border profile" style="font-family: 'Times New Roman'">
				<div style="clear: both; height: 30px"></div>
				<table width = "100%" style = "padding: 8px; text-align: center;" cellpadding="2px">
					<tr><td> <img src="<%=propic%>.png" onerror="this.onerror=null; this.src='avatar.png'" alt="Profile Picture" class="profile_pic"> </td></tr>
					<tr><td><b><%=session.getAttribute("username")%></b></td></tr>
					<tr><td><b> <%=rs.getString("managerName")%> </b></td></tr>
				</table>
				<div style="clear: both; height: 30px"></div>

				<table width = "100%" style="text-align: center;" cellpadding="5px 0px">
					<tr><td>
						<a href="admin_settings.jsp"><button class = "button"> Profile Settings </button> </a><!--link-->
					</td></tr>
					<tr><td>
						<a href="admin_history.jsp"><button class = "button" style="border-left:2px solid black;">  History</button></a> <!--link-->
					</td></tr>
				</table>
			</div>

		<div class = "border settings">
			<div class = "selection">
				<table width = "100%" style="text-align: center;" cellpadding="3px 0px">
					<tr><td>
						<a href="admin_history.jsp"><button class = "button"> All</button></a>
					</td></tr>
					<tr><td>
						<a href="admin_history_uncollected.jsp"><button class = "button"> Uncollected</button></a> <!--LINKSSS!!!-->
					</td></tr>
					<tr><td>
						<a href="admin_history_ongoing.jsp"><button class = "button" style="border-left:2px solid black;">Ongoing</button></a>
					</td></tr>
					<tr><td>
						<a href="admin_history_collected.jsp"><button class = "button"> Collected</button></a>
					</td></tr>
				</table>
			</div>
			<div class = "edit">
				<div style="text-align: center;">
					<h1 style="font-size: 2em"> Pending Parcels </h1> <!--Uncollected-->
					<hr>
				</div>
				<table class="table table-striped" width = "100%" cellpadding="6.5px"; style = "margin: 10px auto; padding: 5px" id="uncollected">
					<thead class="thead-inverse">
						<tr style="font-size:1.1em; background-color:#84a8e1;">
							<th width="10%"><b>No.</b></th>
							<th width="10%"><b>Parcel No.</b></th>
							<th width="20%"><b>Tracking Number</b></th>
							<th width="10%"><b>Student Name</b></th>
							<th width="10%"><b>Student ID</b></th>
							<th width="10%"><b>Courier</b></th>
							<th width="10%"><b>Arrival Date</b></th>
							<th width="10%"><b>Status</b></th>
						</tr>
					</thead>
					<tbody>
						<%
							sql = "select parcelNo, trackingNo, student.studentName as studentName, student.studentID, courierName, exptArrivalDate, status\n" +
									"from pendingparcel, student\n" +
									"where pendingparcel.studentID = student.studentID";
							rs = stm.executeQuery(sql);
							int counter = 0;
							while(rs.next()) {
								counter++;
								if(counter%2 == 0) {
						%>
									<tr>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("parcelNo")%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentName")%></td>
										<td><%=rs.getString("studentID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("exptArrivalDate")%></td>
										<td><%=rs.getString("status")%></td>
									</tr>
						<%
								}
								else {
						%>
									<tr>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("parcelNo")%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentName")%></td>
										<td><%=rs.getString("studentID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("exptArrivalDate")%></td>
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
	<footer>
	<img src = "images/logo.png" class ="bottomleft">
		<div style = "padding: 15px;">
			Copyright 2020, Xiamen University Malaysia <br/>
			JTT Development Team
		</div>
	</footer>
		
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/tableSorter2.js"></script>
	</body>
</html>