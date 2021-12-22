import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

@WebServlet(name = "AdminProfileUpdateServlet")
@MultipartConfig
public class AdminProfileUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phno = request.getParameter("phno");
        String name = request.getParameter("name");
        String nofile = request.getParameter("nofile");
        HttpSession session = request.getSession();
        InputStream inputStream = null;
        Part filePart = request.getPart("img");
        if(filePart != null)
            inputStream = filePart.getInputStream();

        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
            String sql = "update manager set phoneNo = ?, managerName = ? where managerID = '" + session.getAttribute("username") + "'";
            if(nofile.equals("0"))
                sql = "update manager set phoneNo = ?, managerName = ?, imageSource = ? where managerID = '" + session.getAttribute("username") + "'";
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, phno);
            stm.setString(2, name);
            //store the image as a binary in DB
            if(nofile.equals("0"))
                stm.setBlob(3, inputStream);
            stm.execute();

            response.sendRedirect("admin_settings.jsp");
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
