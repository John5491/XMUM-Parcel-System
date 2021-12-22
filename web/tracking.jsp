<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
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
	<div>
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

		<script>
			function removep(value)
			{
				console.log(value)
				if(confirm('Delete pending parcel ' + value + '?'))
						<!--Redirect to delete servlet and keep track of current url and parameter-->
					window.location.replace("DeletePendingParcelServlet?target=" + value + "&from=${pageContext.request.requestURI}&query=${pageContext.request.queryString}");
			}
		</script>

		<div class = "addParcelBg">
			<div class = "addParcelform">
				<b>Add New Tracking</b>
			</div>
			<table width = "50%" cellpadding="15px"; style = "margin: 35px 0px 10px 35px; color: white; ">
				<form id="addnewparcel" method="post" action="AddPendingParcelServlet">
					<tr style="font-weight:700; font-size:1.2em">
						<td>Tracking Number:</td>
						<td><input name="trackID" type="input" placeholder = "Enter Tracking Number..." value = "<%=request.getParameter("target")%>" class = "text"/></td>
					</tr>
					<tr style="font-weight:700; font-size:1.2em">
						<td>Expected Date to Received:</td>
						<td><input name="exptarrivedate" type="input" placeholder = "YYYY-MM-DD" class = "text"/></td>
					</tr>
				</form>
			</table>
			<%
				//check fro message after redirect from AddPendingParcelServlet
				if(request.getParameter("status").equals("1"))
				{

			%>
					<div style="color: green;padding: 10px 0px 10px 280px" class = "alert">
						<b> Your Parcel Has Been Added to Pending List </b>
					</div>
			<%
				}
				else if(request.getParameter("status").equals("2"))
				{
			%>
					<div style="color: red;padding: 10px 0px 10px 280px" class = "alert">
						<b> ! Duplicate Tracking Number Detected </b>
					</div>
			<%
				}
				else if(request.getParameter("status").equals("3"))
				{
			%>
					<div style="color: red; padding: 10px 0px 10px 280px" class = "alert">
						<b> ! Please Fill All Field </b>
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
				Add Pending Parcel
				<button class="homeButton" onclick="document.getElementById('addnewparcel').submit()">
					 <i class="far fa-plus-square"></i>
				</button>
			</div>
		</div>
		
		<div class = "border track2"> 
			<div class = "Your_title">
				<h1>Uncollected Parcels</h1>
				<hr>
			</div>
			<table class="table" id="uncollected">
				<thead class="thead-inverse">
					<tr>
						<th width="5%">No.</th>
						<th width="15%" >Tracking Number</th>
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
									<td scope="row"><b><%out.print(counter);%></b></td>
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
									<td scope="row"><b><%out.print(counter);%></b></td>
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
					%>
				</tbody>
			</table>

			<div class = "Your_title">
				<h1>Pending Parcels</h1>
				<hr>
			</div>
			<table class="table" id="pending">
				<thead class="thead-inverse">
					<tr>
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
						//query 1 more time for another table access
						sql = "select * from pendingparcel where status = 'Pending' and (studentID = '" + session.getAttribute("username") + "') order by parcelNo desc";
						rs = stm.executeQuery(sql);
						counter = 0;
						boolean highlighted = false;
						while(rs.next()) {
							counter++;
							if(counter%2 == 0) {
					%>
								<tr>
									<td scope="row"><b><%out.print(counter);%></b></td>
									<td><%=rs.getString("trackingNo")%></td>
									<td><%=rs.getString("studentID")%></td>
									<td><%=rs.getString("courierName")%></td>
									<td><%=rs.getString("exptArrivalDate")%></td>
									<td>null</td>
									<td><%=rs.getString("status")%></td>
									<td>
										<!--Redirect to delete servlet and keep track of current url and parameter-->
										<button class = "button_table" value="<%=rs.getString("trackingNo")%>" onclick="removep(this.value)">
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
									<td scope="row"><b><%out.print(counter);%></b></td>
									<td><%=rs.getString("trackingNo")%></td>
									<td><%=rs.getString("studentID")%></td>
									<td><%=rs.getString("courierName")%></td>
									<td><%=rs.getString("exptArrivalDate")%></td>
									<td>null</td>
									<td><%=rs.getString("status")%></td>
									<td>
										<!--Redirect to delete servlet and keep track of current url and parameter-->
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
</div> <!---End of container--->

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
	</body>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/tableSorter2.js"></script>
</html>