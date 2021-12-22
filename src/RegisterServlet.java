import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String privilege = request.getParameter("privilege");
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String phoneNo = request.getParameter("phoneNo");
        String pass = request.getParameter("pass");
        String cpass = request.getParameter("cpass");

        if(id!="" && name!="" && email!="" && gender!="" && phoneNo!="" && pass!=""&& cpass!="")
        {
            String idrgscheck = "";
            for(char c :id.toCharArray()) {
                if (Character.isLetter(c)) {
                    idrgscheck += c;
                }
            }
            if(idrgscheck.equals("SWE") && privilege.equals("1") || idrgscheck.equals("STF") && privilege.equals("2"))
            {
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
                    String sql;
                    PreparedStatement stm;
                    ResultSet rs;
                    if(privilege.equals("1"))
                    {
                        sql = "select * from student where studentID = '" + id + "' or studentName = '" + name + "'";
                    }
                    else {
                        sql = "select * from manager where managerID = '" + id + "' or managerName = '" + name + "'";
                    }
                    stm = conn.prepareStatement(sql);
                    rs = stm.executeQuery();
                    if(rs.next()) {
                        response.sendRedirect("register.jsp?status=2");
                    }
                    else {
                        if((id+"@xmu.edu.my").equals(email)) {
                            if(pass.equals(cpass)) {
                                if(gender.equals("Male"))
                                    gender = "0";
                                else
                                    gender = "1";
                                if(privilege.equals("1"))
                                {
                                    sql = "insert into student(studentID, studentName, password, gender, phoneNo, email)" +
                                            "value(?, ?, ?, ?, ?, ?)";
                                }
                                else {
                                    sql = "insert into manager(managerID, managerName, password, gender, phoneNo, email)" +
                                            "value(?, ?, ?, ?, ?, ?)";
                                }
                                stm = conn.prepareStatement(sql);

                                stm.setString(1, id);
                                stm.setString(2, name);
                                stm.setString(3, pass);
                                stm.setString(4, gender);
                                stm.setString(5, phoneNo);
                                stm.setString(6, email);
                                stm.execute();

                                response.sendRedirect("index.jsp?status=2");
                            }
                            else {
                                response.sendRedirect("register.jsp?status=3");
                            }
                        }
                        else {
                            response.sendRedirect("register.jsp?status=4");
                        }
                    }
                }
                catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            else {
                response.sendRedirect("register.jsp?status=5");
            }
        }
        else {
            response.sendRedirect("register.jsp?status=6");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
