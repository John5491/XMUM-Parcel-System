import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
/*
import java.io.File;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;*/


@WebServlet(name = "ProfileUpdateServlet")
@MultipartConfig

public class ProfileUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phno = request.getParameter("phNo");
        String nofile = request.getParameter("nofile");
        HttpSession session = request.getSession();
        InputStream inputStream = null;
        Part filePart = request.getPart("img");

        if(filePart != null)
            inputStream = filePart.getInputStream();

        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
            String sql = "update student set phoneNo = ? where studentID = '" + session.getAttribute("username") + "'";
            if(nofile.equals("0"))
                sql = "update student set phoneNo = ?, imageSource = ? where studentID = '" + session.getAttribute("username") + "'";
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, phno);
            if(nofile.equals("0"))
                stm.setBlob(2, inputStream);
            stm.execute();

            response.sendRedirect("setting_user.jsp");
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
