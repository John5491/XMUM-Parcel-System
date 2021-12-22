<html>
	<head>
		<!---CSS Link--->
		<link rel="stylesheet" type="text/css" href="style25.css">
		<link rel="shortcut icon" href="images/xmux.png">
	</head>
	
	<body class = "background">
	
		<div class = "intro" style="margin-top: 4%; margin-bottom: 3%"> XMUM PARCEL SYSTEM </div>

			<div class = "border frame" style="padding: 0px; width: 55%; height: 60%">
				<div class = "right_side">
					<div style = "font-size: 2.5em; margin-bottom: 50px; margin-top: 10px;">
						<b> Login </b>
					</div>

					<table class = "login_text" cellpadding= "5px;">
						<form id="lg" method="post" action="LoginServlet">
							<tr>
								<td style=" width: 42%;">  <!--bottom will follow this width-->
									Student/Staff ID:
								</td>
								<td style="text-align: right;">
									<input name="username" type="text" placeholder="SWE1804XXX" class = "text_holder">
								</td>
							</tr>
							<tr style="clear: both; height: 20px">
							</tr>
							<tr>
								<td>Password:</td>
								<td style="text-align: right;">
									<input name="password" type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;" class = "text_holder">
								</td>
							</tr>
						</form>
					</table>

						<%
							//Check for redirect message, if status is present, prompt a message according to status
							if(request.getParameter("status")!=null)
							{
								if(request.getParameter("status").equals("1"))
								{
						%>
									<div style="color: green; text-align: center; padding: 5px" class = "alert">
										Session Logged Out
									</div>
						<%
								}
								if(request.getParameter("status").equals("2"))
								{
						%>
									<div style="color: green; text-align: center; padding: 5px" class = "alert">
										Account Created Successfully
									</div>
						<%
								}
								if(request.getParameter("status").equals("3"))
								{
						%>
									<div style="color: red; text-align: center; padding: 5px" class = "alert">
										Incorrect ID or Password
									</div>
						<%
								}
								if(request.getParameter("status").equals("4"))
								{
						%>
									<div style="color: red; text-align: center; padding: 5px" class = "alert">
										Session Not Log In
									</div>
						<%
								}
							}
							else
							{
						%>
								<div style="height:28px; clear:both;"></div>
						<%
							}
						%>

					<div class = "button_sub_pos" onclick="document.getElementById('lg').submit();" style="margin: 50px auto">
						<button class="button_sub" style="border-radius: 10px; background-color: #292b2c">
							Login <!--link-->
						</button>
					</div>

					<div class="ques_pos" style="margin-top: 100px">
						Do not have an account? &rarr; 
						<button class = "button_reg"> <a href="register.jsp?status=" style="color: black;">
						<b> <u> Register! </u> </b> </a> </button> <!--link-->
					</div>
				</div>

				<div class = "left_side" style="height: 47%">
					<div class="loginBG"> </div>
				</div>
			</div> <!--end of border frame-->
		<script src="https://kit.fontawesome.com/865a58ff37.js" crossorigin="anonymous"></script>
	</body>
</html>