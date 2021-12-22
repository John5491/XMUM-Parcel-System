<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>

<%
	if(session.getAttribute("username") == null)			//check if session is logged in
		response.sendRedirect("index.jsp?status=4");		//if not redirect to loginpage with status 4
	else if(session.getAttribute("privilege").equals("1"))	//check if privilege of current user match with page they are accessing
		response.sendRedirect("student_privilege.jsp");		//if not match prompt to privilege denied page
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
		
		<div class = "border track">
			<div class="adminhomebg">
				<div style="font-size: 1.5em; color: white">
					Please Enter A Tracking Number
				</div>
				<div>
					<form id="forms" method="post" action="admin_tracking.jsp">
						<input name="target" type="input" placeholder = "TrackingNo..." class = "text_search"/>
						<i class="fas fa-search fa-2x" style="color: white"></i>
					</form>
				</div>
				<script>
					function submit(value)
					//function to determine which button is clicked
					{
						console.log(value)
						if (value == "add") {
							//determine which page to be redirected
							document.getElementById('forms').action = 'admin_tracking.jsp?status='
							document.getElementById('forms').submit(); //submit
						} else {//save the value entered into the form
							//retrieve value entered in forms
							var save = document.getElementById('forms')[0].value;
							localStorage.clear();
							//save the value into a variable: save
							localStorage.setItem("save", save);
							//counter to check refresh time
							localStorage.setItem("counter", "0");
							document.getElementById('forms').action = 'admin_home_result.jsp'
							document.getElementById('forms').submit();
						}
					}
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
				<button class="button_search" value = "add" onclick="submit(this.value)">
					Add New
				</button>
				<button class="button_search" value = "srch" onclick="submit(this.value)">
					Search
				</button>
			</div>

			<div style="clear: both; height: 30px"></div>
			<div class = "Your_title">
				<h1> Readied Parcels </h1>
				<hr>
			</div>
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
								"order by parcelNo asc";
						ResultSet rs = stm.executeQuery(sql);
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
		
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
	</body>

	<script type="text/javascript" src="${pageContext.request.contextPath}/js/tableSorter2.js"></script>
</html>