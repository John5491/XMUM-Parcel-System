<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>

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
			<div class="homeBG">
				<div class = "header">
					<table width = "100%" >
						<tr>
							<td width = "30%" style = "text-align: right;">
								<div class = "dropdown">
									<img src="<%=session.getAttribute("username")%>.png" onerror="this.onerror=null; this.src='avatar.png'"  class="profileIcon">
									<div class="dropdown_content">
										<a href = "notice.jsp">Notice </a>
										<a href="setting_user.jsp">Settings</a>
										<a href="history.jsp">History</a>
										<a href="LogoutServlet">Log out</a>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="homeTitle">
					<button onclick="location.href = 'home_student_all.jsp'" class="homeButton">
						<i class="fas fa-boxes" style = "color:white"></i> XMUM Parcel System
					</button>
				</div>
				<div class="homeSubtitle">
					Please enter your tracking number.
				</div>
				<div class="border track">
					<form id="forms" method="post" action="tracking.jsp">
						<input name="target" type="input" placeholder = "TrackingNo..." class = "text_search"/>
						<i class="fas fa-search " style="color: white"></i>
					</form>
					<script>
						//function that determine which button user clicked
						function submit(value)
						{
							console.log(value)
							if (value == "add") {
								//determine which page to be redirected
								document.getElementById('forms').action = 'tracking.jsp?status='
								document.getElementById('forms').submit(); //submit
							} else {
								document.getElementById('forms').action = 'home_student_result.jsp'
								document.getElementById('forms').submit();
							}
						}
						function removep(value)
						{
							console.log(value)
							if(confirm('Delete pending parcel ' + value + '?'))
									<!--Redirect to delete servlet and keep track of current url and parameter-->
								window.location.replace("DeletePendingParcelServlet?target=" + value + "&from=${pageContext.request.requestURI}&query=${pageContext.request.queryString}");
						}
					</script>
					<!--call submit function when clicked-->
					<button class="button_search" value = "add" onclick="submit(this.value)">
						Add New
					</button>
					<button class="button_search" value = "srch" onclick="submit(this.value)">
						Search
					</button>
				</div>
			</div>

			<div class = "border track ">
				<div class = "Your_title">
					<h1> Your Parcels </h1>
					<hr>
				</div>

				<table class="table" id="uncollected">
					<thead class="thead-inverse">
						<tr style="font-weight:900; font-size:1.2em; background-color:#84a8e1;">
							<th width="5%">No.</th>
							<th width="15%">Tracking Number</th>
							<th width="10%">Student ID</th>
							<th width="10%">Courier</th>
							<th width="15%">Arrival Date</th>
							<th width="15%">Collection Date</th>
							<th width="10%">Status</th>
							<th width="10%">Operation</th>
						</tr>
					</thead>
					<tbody>
						<%
							Class.forName("com.mysql.jdbc.Driver");
							Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
							Statement stm = conn.createStatement();
							String sql = "select * from parcel where status = 'Ready' and (student_ID = '" + session.getAttribute("username") + "')";
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
										<td>[NULL]</td>
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
										<td>[NULL]</td>
									</tr>
						<%
								}
							}
							//query 1 more time for another table access
							sql = "select * from pendingparcel where status = 'Pending' and (studentID = '" + session.getAttribute("username") + "')";
							rs = stm.executeQuery(sql);
							while(rs.next()) {
								counter++;
								if(counter%2 == 0) {
						%>
									<tr>
										<td><b><%out.print(counter);%></b></td>
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("exptArrivalDate")%></td>
										<td>null</td>
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
										<td><%=rs.getString("trackingNo")%></td>
										<td><%=rs.getString("studentID")%></td>
										<td><%=rs.getString("courierName")%></td>
										<td><%=rs.getString("exptArrivalDate")%></td>
										<td>null</td>
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