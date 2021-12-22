import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "AdminAddParcelServelet")
public class AdminAddParcelServelet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");      //prepare format
        Date d = new Date();
        String trackNo = request.getParameter("trackID");
        String sname = request.getParameter("sname");
        String cur_date = sdf.format(d);                                        //current date setup
        String sid = null;
        String courierName = "";


        if(trackNo == null || trackNo.equals("")) {
            response.sendRedirect("admin_tracking.jsp?status=3&target=");
        }
        else {
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
                String sql = "select parcelNo from parcel";
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery(sql);
                int parcelcount = 0;       //cast String to int
                while(rs.next())
                {
                    int a = Integer.parseInt(rs.getString("parcelNo"));
                    if(parcelcount < a)
                        parcelcount = a;
                }
                parcelcount++;                                                              //increment current parcelNo

                sql = "select * from parcel where trackingNo = '" + trackNo + "'";
                rs = stm.executeQuery(sql);
                if(rs.next()) {
                    response.sendRedirect("admin_tracking.jsp?status=2&target=");           //redirect with status 2 if existing parcel present in parcel DB
                }
                else {
                    sql = "select * from pendingparcel where trackingNo = '" + trackNo + "'";   //search if student had prepare a pending parcel in DB
                    rs = stm.executeQuery(sql);
                    if(rs.next()) {
                        //retrieve pending parcel info
                        sid = rs.getString("studentID");
                        courierName = rs.getString("courierName");
                    }
                    else {
                        //if no such trackingNo in pending parcel, we look for matching studentName in student DB
                        sql = "select * from student where studentName = '" + sname + "'";
                        rs = stm.executeQuery(sql);
                        if(rs.next()) {
                            sid = rs.getString("studentID");
                        }
                        //courierName auto detector
                        for(char c :trackNo.toCharArray()) {
                            if (Character.isLetter(c)) {
                                courierName += c;
                            }
                        }
                        switch(courierName){
                            case "GDE":
                                courierName = "GDex";
                                break;

                            case "MY":
                                courierName = "PosLaju";
                                break;

                            case "DHL":
                                courierName = "DHL";
                                break;

                            case "FED":
                                courierName = "FeDex";
                                break;

                            case "ARAK":
                                courierName = "ARAMEX";
                                break;

                            case "JT":
                                courierName = "J&T";
                                break;

                            case "NJV":
                                courierName = "NinjaVan";
                                break;
                        }
                    }
                    sql = "delete from pendingparcel where trackingNo = '" + trackNo + "'"; //remove parcel from pendingparcel DB
                    stm.execute(sql);
                    sql = "insert into parcel(parcelNo, trackingNo, student_ID, courierName, dateReceived, datePickup, manager_ID, status)" +
                            "value(?, ?, ?, ?, ?, null, ?, 'Ready')";                   //transfer to parcel DB
                    stm = conn.prepareStatement(sql);

                    stm.setString(1, String.valueOf(parcelcount));
                    stm.setString(2, trackNo);
                    stm.setString(3, sid);
                    stm.setString(4, courierName);
                    stm.setString(5, cur_date);
                    stm.setString(6, (String)session.getAttribute("username"));
                    stm.execute();
                    response.sendRedirect("admin_tracking.jsp?status=1&target=");
                }
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
