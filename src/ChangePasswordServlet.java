import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet(name = "ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldpassword = request.getParameter("oldp");
        String newpassword = request.getParameter("newp");
        String cnewpassword = request.getParameter("cnewp");
        HttpSession session = request.getSession();

        //check if password and confirm password are matching
        if(!newpassword.equals(cnewpassword)) {
            response.sendRedirect("setting_password.jsp?status=1");
        }
        else {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
                String sql = "select * from student where studentID = '" + session.getAttribute("username") + "'";
                Statement stm = conn.createStatement();
                ResultSet rs = stm.executeQuery(sql);
                rs.next();
                //check if oldpassword match in database
                if(rs.getString("password").equals(oldpassword)) {
                    sql = "update student set password = " + newpassword + " where studentID = '" + session.getAttribute("username") + "'";
                    //update password
                    stm.execute(sql);

                    response.sendRedirect("setting_password.jsp?status=3");
                }
                else {
                    response.sendRedirect("setting_password.jsp?status=2");
                }
            }
            catch (Exception ex)
            {
                ex.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
