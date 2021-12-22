<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>

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
		<script>
			window.onload = function() {
				localStorage.setItem("page", "adminhome");
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

			<div class = "addParcelBg">
				<div class = "addParcelform">
					<b>Add New Tracking</b>
				</div>
				<table width = "50%" cellpadding="15px"; style = "margin: 35px 0px 10px 35px; color: white; ">
					<form id="addnewparcel" method="post" action="AdminAddParcelServelet">
						<tr style="font-weight:900; font-size:1.2em">
							<td>Tracking Number:</td>
							<td><input name="trackID" type="input" placeholder = "Enter Tracking Number..." value = "<%=request.getParameter("target")%>" class = "text"/></td>
						</tr>
						<tr style="font-weight:900; font-size:1.2em">
							<td>Student Name:</td>
							<td><input name="sname" type="input" placeholder = "Enter Student Name..." class = "text"/></td>
						</tr>
					</form>
				</table>
				<%
						if(request.getParameter("status").equals("1"))
						{
				%>
							<div style="color: green; text-align: center; padding: 5px" class="alert">
								Parcel Have Been Added Successfully
							</div>
				<%
						}
						else if(request.getParameter("status").equals("2"))
						{
				%>
							<div style="color: red; text-align: center; padding: 5px" class="alert">
								Duplicate Tracking Number Detected
							</div>
				<%
						}
						else if(request.getParameter("status").equals("3"))
						{
				%>
							<div style="color: red; text-align: center; padding: 5px" class="alert">
								Please Fill Tracking Number Field
							</div>
				<%
						}
						else
						{
				%>
							<div style="height:62px; clear:both;"></div>
				<%
						}
				%>
				<div style="color: white; font-size: 1.2em; padding-left: 50px">
					Add Parcel
					<button class="homeButton" onclick="document.getElementById('addnewparcel').submit()">
						<i class="far fa-plus-square"></i>
					</button><!---Update link!!!--->
				</div>
			</div>

			<div class = "border track2">
				<div class = "Your_title">
					<h1> Readied Parcels </h1>
					<hr>
				</div>
				<script>
					function collect(value)
					{
						console.log(value)
						if(confirm('Collect parcel ' + value + '?'))
								<!--Redirect to collect servlet and keep track of current url and parameter-->
							window.location.replace("AdminCollectServlet?target=" + value + "&from=${pageContext.request.requestURI}&query=${pageContext.request.queryString}");
					}
					function remove(value)
					{
						console.log(value)
						if(confirm('Delete parcel ' + value + '?'))
								<!--Redirect to delete servlet and keep track of current url and parameter-->
							window.location.replace("AdminDeleteParcelServlet?target=" + value + "&from=${pageContext.request.requestURI}&query=${pageContext.request.queryString}");
					}
				</script>

				<table class="table table-striped" id="parcel">
					<thead class="thead-inverse">
						<tr style="font-size:1.1em; background-color:#84a8e1;">
							<th width="5%"><b>No.</b></th>
							<th width="7%"><b>Parcel No.</b></th>
							<th width="12%"><b>Tracking Number</b></th>
							<th width="13%"><b>Student Name</b></th>
							<th width="10%"><b>Student ID</b></th>
							<th width="8%"><b>Courier</b></th>
							<th width="9%"><b>Arrival Date</b></th>
							<th width="9%"><b>Collection Date</b></th>
							<th width="9%"><b>Manager Name</b></th>
							<th width="5%"><b>Status</b></th>
							<th width="8%"><b>Ops</b></th>
						</tr>
					</thead>
					<tbody>
						<%
							Class.forName("com.mysql.jdbc.Driver");
							Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
							Statement stm = conn.createStatement();
							String sql = "select parcelNo, trackingNo, studentName, student_ID, courierName, dateReceived, datePickup, managerName, status\n" +
									"from manager, parcel\n" +
									"left join student on parcel.student_ID = student.studentID\n" +
									"where manager.managerID = parcel.manager_ID and status = 'Ready'\n" +
									"order by parcelNo desc";
							ResultSet rs = stm.executeQuery(sql);
							int counter = 0;
							boolean highlighted = false;
							while(rs.next()) {
								counter++;
								if(counter%2 == 0) {
						%>
									<tr>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("parcelNo")%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentName")%></td>
										<td><%=rs.getString("student_ID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("dateReceived")%></td>
										<td><%=rs.getString("datePickup")%></td>
										<td><%=rs.getString("managerName")%></td>
										<td><%=rs.getString("status")%></td>
										<td>
											<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="collect(this.value)">
												Collect
											</button>
											<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="remove(this.value)">
												Delete
											</button>
										</td>
									</tr>
						<%
								}
								else {
									if(request.getParameter("status").equals("1") && !highlighted) {
										highlighted = true;
						%>
										<tr class="highlight">
						<%
									}
									else {
						%>
										<tr>
						<%
									}
						%>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("parcelNo")%></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentName")%></td>
										<td><%=rs.getString("student_ID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("dateReceived")%></td>
										<td><%=rs.getString("datePickup")%></td>
										<td><%=rs.getString("managerName")%></td>
										<td><%=rs.getString("status")%></td>
										<td>
											<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="collect(this.value)">
												Collect
											</button>
											<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="remove(this.value)">
												Delete
											</button>
										</td>
									</tr>
						<%
								}
							}
						%>
					</tbody>
				</table>
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
		<!---Icon Link--->
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/tableSorter2.js"></script>
	</body>
</html>