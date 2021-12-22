<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
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
		
			<div class = "border track">
				<div class="adminstudentbg">
					<div style="font-size: 1.5em; color: white; margin-top: 20px">
						Please Enter A Student ID Or Name
					</div>
					<div>
						<form id="srch" method="post" action="admin_students_result.jsp">
							<input name="target" type="input" placeholder = "Student Name/Student ID..." class = "text_search"/>
							<i class="fas fa-search fa-2x" style="color: white"></i>
						</form>
					</div>
					<button class="button_search" onclick="document.getElementById('srch').submit()">
						Search
					</button>
				</div>
				<div style="clear: both; height: 30px"></div>
				<div class = "Your_title">
					<h1> <%=request.getParameter("sid")%>'s Parcel </h1>
					<hr>
				</div>
				<div class = "border track2">
					<div class = "Your_title">
						<h3> <b> <u> Uncollected Parcels </u></b> </h3>
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
						function removep(value)
						{
							console.log(value)
							if(confirm('Delete pending parcel ' + value + '?'))
									<!--Redirect to delete servlet and keep track of current url and parameter-->
								window.location.replace("DeletePendingParcelServlet?target=" + value + "&from=${pageContext.request.requestURI}&query=${pageContext.request.queryString}");
						}
					</script>
					<table class="table table-striped" id="uncollected">
						<thead class="thead-inverse">
							<tr style="font-size:1.1em; background-color:#84a8e1;">
								<th width="10%">No.</th>
								<th width="10%">Tracking Number</th>
								<th width="10%">Student ID</th>
								<th width="10%">Courier</th>
								<th width="10%">Arrival Date</th>
								<th width="10%">Collection Date</th>
								<th width="10%">Status</th>
								<th width="10%">Operation</th>
							</tr>
						</thead>
						<tbody>
							<%
								Class.forName("com.mysql.jdbc.Driver");
								Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
								Statement stm = conn.createStatement();
								String sql = "select * from parcel where status = 'Ready' and (student_ID = '" + request.getParameter("sid") + "')";
								ResultSet rs = stm.executeQuery(sql);
								int counter = 0;
								while(rs.next()) {
									counter++;
									if(counter%2 == 0) {
							%>
									<tr>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("student_ID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("dateReceived")%></td>
										<td><%=rs.getString("datePickup")%></td>
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
							%>
										<tr>
											<td><b><%out.print(counter);%></b></td>
											<td><%=rs.getString("trackingNo")%></td>
											<td><%=rs.getString("student_ID")%></td>
											<td><%=rs.getString("courierName")%></td>
											<td><%=rs.getString("dateReceived")%></td>
											<td><%=rs.getString("datePickup")%></td>
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

					<div style="clear: both; height: 30px"></div>
					<div class = "Your_title">
						<h3><b> <u> Pending Parcels </u></b></h3>
					</div>
					<table class="table table-striped" id="pending">
						<thead class="thead-inverse">
							<tr style="font-size:1.1em; background-color:#84a8e1;">
								<th width="10%">No.</th>
								<th width="10%">Parcel No.</th>
								<th width="10%">Tracking Number</th>
								<th width="10%">Student ID</th>
								<th width="10%">Courier</th>
								<th width="10%">Arrival Date</th>
								<th width="10%">Status</th>
								<th width="10%">Operation</th>
							</tr>
						</thead>
						<tbody>
							<%
								sql = "select * from pendingparcel where status = 'Pending' and (studentID = '" + request.getParameter("sid") + "')";
								rs = stm.executeQuery(sql);
								counter = 0;
								while(rs.next()) {
									counter++;
									if(counter%2 == 0) {
							%>
										<tr>
											<td><b><%out.print(counter);%></b></td>
											<td><%=rs.getString("parcelNo")%></td>
											<td><%=rs.getString("trackingNo")%></td>
											<td><%=rs.getString("studentID")%></td>
											<td><%=rs.getString("courierName")%></td>
											<td><%=rs.getString("exptArrivalDate")%></td>
											<td><%=rs.getString("status")%></td>
											<td>
												<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="removep(this.value)">
													Delete
												</button>
											</td>
										</tr>
							<%
									}
									else {
							%>
										<tr>
											<td><b><%out.print(counter);%></b></td>
											<td><%=rs.getString("parcelNo")%></td>
											<td><%=rs.getString("trackingNo")%></td>
											<td><%=rs.getString("studentID")%></td>
											<td><%=rs.getString("courierName")%></td>
											<td><%=rs.getString("exptArrivalDate")%></td>
											<td><%=rs.getString("status")%></td>
											<td>
												<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="removep(this.value)">
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

					<div style="clear: both; height: 30px"></div>
					<div class = "Your_title">
						<h3><b> <u> Collected Parcels </u></b></h3>
					</div>
					<table class="table table-striped" id="collected">
						<thead class="thead-inverse">
							<tr style="font-size:1.1em; background-color:#84a8e1;">
								<th width="10%">No.</th>
								<th width="10%">Parcel No.</th>
								<th width="10%">Tracking Number</th>
								<th width="10%">Student ID</th>
								<th width="10%">Courier</th>
								<th width="10%">Arrival Date</th>
								<th width="10%">Collection Date</th>
								<th width="10%">Status</th>
							</tr>
						</thead>
						<tbody>
							<%
								sql = "select * from parcel where status = 'Picked-up' and (student_ID = '" + request.getParameter("sid") + "')";
								rs = stm.executeQuery(sql);
								counter = 0;
								while(rs.next()) {
									counter++;
									if(counter%2 == 0) {
							%>
										<tr>
											<td><b><%out.print(counter);%></b></td>
											<td><%=rs.getString("parcelNo")%></td>
											<td><%=rs.getString("trackingNo")%></td>
											<td><%=rs.getString("student_ID")%></td>
											<td><%=rs.getString("courierName")%></td>
											<td><%=rs.getString("dateReceived")%></td>
											<td><%=rs.getString("datePickup")%></td>
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
											<td><%=rs.getString("student_ID")%></td>
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
		<footer>
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