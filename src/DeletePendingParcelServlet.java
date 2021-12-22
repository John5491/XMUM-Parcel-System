import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

@WebServlet(name = "DeletePendingParcelServlet")
public class DeletePendingParcelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trackNo = request.getParameter("target");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
            Statement stm = conn.createStatement();
            String sql = "delete from pendingparcel where trackingNo = '" + trackNo + "'";
            //remove the parcel from DB
            stm.execute(sql);

            response.sendRedirect(request.getParameter("from") + "?" + request.getParameter("query"));
            //redirect to jsp origin with parameter origin
        } catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
