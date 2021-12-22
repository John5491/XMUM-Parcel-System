import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "AdminCollectServlet")
public class AdminCollectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trackNo = request.getParameter("target");
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd"); //prepare date format
        String cur_date = sdf.format(d);        //get current time

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
            Statement stm = conn.createStatement();
            String sql = "update parcel set status = 'Picked-up', datePickup = '" + cur_date + "' where trackingNo = '" + trackNo + "'";
            //update parcel status and pickup date
            stm.execute(sql);

            response.sendRedirect(request.getParameter("from") + "?" + request.getParameter("query"));
            //redirect to jsp origin with parameter origin
        } catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
