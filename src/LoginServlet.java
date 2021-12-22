import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends javax.servlet.http.HttpServlet {
    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
            PreparedStatement stm = conn.prepareStatement("select * from student where studentID = ? and password = ?");
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();
            if(rs.next())
            {
                session.setAttribute("username", username);
                session.setAttribute("privilege", "1");
                response.sendRedirect("home_student_all.jsp");
            }
            else
            {
                stm = conn.prepareStatement("select * from manager where managerID = ? and password = ?");
                stm.setString(1, username);
                stm.setString(2, password);
                rs = stm.executeQuery();
                if(rs.next())
                {
                    session.setAttribute("username", username);
                    session.setAttribute("privilege", "2");
                    response.sendRedirect("admin_home.jsp");
                }
                else
                {
                    response.sendRedirect("index.jsp?status=3");
                }
            }
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }

    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {

    }
}
