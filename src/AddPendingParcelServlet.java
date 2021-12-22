import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.plaf.nimbus.State;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "AddPendingParcelServlet")
public class AddPendingParcelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trackingNo = request.getParameter("trackID");
        String exptarrivedate = request.getParameter("exptarrivedate"); //get input date from user
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");  //prepare date format
        try {
            Date d1 = sdf.parse(exptarrivedate);        //cast string date into date object
            exptarrivedate = sdf.format(d1);            //cast date to string with prepared format
        } catch (ParseException e) {
            e.printStackTrace();
        }
        HttpSession session = request.getSession();

        if(trackingNo == null || exptarrivedate == null || trackingNo.equals("") || exptarrivedate.equals("")) {
            response.sendRedirect("tracking.jsp?status=3&target=");
        }
        else {
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/xmumparcelsystem", "root" , "SWE1804422");
                String sql = "select * from parcel where trackingNo = '" + trackingNo + "'";
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery();
                if(rs.next()) {
                    response.sendRedirect("tracking.jsp?status=2&target=");     //redirect if trackingNo had exist in parcel DB
                }
                else
                {
                    sql = "select * from pendingparcel where trackingNo = '" + trackingNo + "'";
                    rs = stm.executeQuery(sql);
                    if(rs.next())
                    {
                        response.sendRedirect("tracking.jsp?status=2&target=");     //redirect if trackingNo had exist in pendingparcel DB
                    }
                    else
                    {
                        sql = "select parcelNo from parcel";                   //prepare parcelNo by incrementing current biggest parcelNo
                        Statement stm2 = conn.createStatement();
                        rs = stm2.executeQuery(sql);
                        int totalp = 0;
                        while(rs.next())
                        {
                            int a =Integer.parseInt(rs.getString("parcelNo"));      //cast String to int
                            if(totalp < a)
                                totalp = a;
                        }
                        totalp++;
                        sql = "insert into pendingparcel(parcelNo, trackingNo, studentID, courierName, exptArrivalDate, status)\n" +
                                "value(?, ?, ?, ?, ?, 'Pending')";
                        stm = conn.prepareStatement(sql);

                        String courierName = "";
                        //courierName auto detector
                        for(char c :trackingNo.toCharArray()) {
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
                        stm.setString(1, String.valueOf(totalp));
                        stm.setString(2, trackingNo);
                        stm.setString(3, (String)session.getAttribute("username"));
                        stm.setString(4, courierName);
                        stm.setString(5, exptarrivedate);
                        stm.execute();

                        response.sendRedirect("tracking.jsp?status=1&target=");     //redirect with status 1 (parcel added successfully)
                    }
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
