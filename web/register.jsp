<html>
	<head>
		<!---CSS Link--->
		<link rel="stylesheet" type="text/css" href="style25.css">
		<link rel="shortcut icon" href="images/xmux.png">
	</head>
	
	<body class = "background">
		<div class = "intro" style="margin-top: 4%; margin-bottom: 3%"> XMUM PARCEL SYSTEM </div>
			<div class = "border frame" style="width: 55%; height: 60%; padding: 0px">
				<div style = "margin-top: 2%; text-align: center;">
					<div style = "font-size: 2.5em; padding-bottom: 15px; ">
						<b> Register </b>
					</div>

					<form id="register" method="post" action="RegisterServlet">
						<table class = "login_text" cellpadding= "5px;">
							<tr>
								<td style=" width: 42%"> <!--bottom will follow this width-->
									Student/Staff ID:
								</td>
								<td>
									<input name="id" type="text" placeholder="SWE18044XX" class = "text_holder">
								</td>
							</tr>
							<tr>
								<td>Name:</td>
								<td>
									<input name="name" type="text" placeholder="John" class = "text_holder">
								</td>
							</tr>
							<tr>
								<td>Email:</td>
								<td>
									<input name="email" type="text" placeholder="SWE18044XX@xmu.edu.my" class = "text_holder">
								</td>
							</tr>
							<tr>
								<td>Gender:</td>
								<td>
									<select name="gender">
										<option value="Male">Male</option>
										<option value="Female">Female</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Phone Number:</td>
								<td>
									<input name="phoneNo" type="text" placeholder="60123456789" class = "text_holder">
								</td>
							</tr>
							<tr>
								<td>Password:</td>
								<td>
									<input name="pass" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;" class = "text_holder">
								</td>
							</tr>
							<tr>
								<td>Confirm Password:</td>
								<td>
									<input name="cpass" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;" class = "text_holder">
								</td>
							</tr>
						</table>
					</form>

					<script>
						function submit(value)
						{
							console.log(value)
							if (value == "1") {
								//change action of form
								document.getElementById('register').action = 'RegisterServlet?privilege=1'
								document.getElementById('register').submit(); //submit
							} else {
								document.getElementById('register').action = 'RegisterServlet?privilege=2'
								document.getElementById('register').submit();
							}
						}
					</script>

					<%
						if(request.getParameter("status").equals("2"))
						{
					%>
							<div style="color: red; text-align: center; padding: 5px" class = "alert">
								ID or Name entered had been used
							</div>
					<%
						}
						else if(request.getParameter("status").equals("3"))
						{
					%>
							<div style="color: red; text-align: center; padding: 5px" class = "alert">

							</div>
					<%
						}
						else if(request.getParameter("status").equals("4"))
						{
					%>
							<div style="color: red; text-align: center; padding: 5px" class = "alert">
								ID and Email Initials Mismatched
							</div>
					<%
						}
						else if(request.getParameter("status").equals("5"))
						{
					%>
							<div style="color: red; text-align: center; padding: 5px" class = "alert">
								Your ID Does Not Match The Privilege You Are Allow To Register
							</div>
					<%
						}
						else if(request.getParameter("status").equals("6"))
						{
					%>
							<div style="color: red; text-align: center; padding: 5px" class = "alert">
								Please Fill All Column
							</div>
					<%
						}
						else
						{
					%>
							<div style="height:28px; clear:both;"></div>
					<%
						}
					%>

					<table style="margin: 15px auto; font-size: 1.4em">
						<tr>
							<td style=" width: 60%"> 
								<button class="button_type" value="1" onclick="submit(this.value)" style="border-radius: 10px; background-color: #292b2c"> <!--link-->
									Student
								</button>
							</td>
							<td> 
								<button class="button_type" value="2" onclick="submit(this.value)" style="border-radius: 10px; background-color: #292b2c"><!--link-->
									Staff
								</button>
							</td>
						</tr>
					</table>

					<div class="ques_pos" style="margin-top: 20px">
						Already have an account? &rarr; 
						<button class = "button_reg"> <a href="index.jsp" style="color: black;">
						<b> <u> Login! </u> </b> </a> </button> 
					</div>
				</div>
			</div>
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
	</body>
</html>