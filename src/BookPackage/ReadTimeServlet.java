package BookPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ReadTimeServlet")
public class ReadTimeServlet extends HttpServlet{
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String rid_temp=request.getParameter("id");int rid=Integer.parseInt(rid_temp);
		String usertype_temp=request.getParameter("usertype");int usertype=Integer.parseInt(usertype_temp);
		String nid_temp=request.getParameter("nid");int nid=Integer.parseInt(nid_temp);
		String chapter=request.getParameter("chapter");
		String t_temp=request.getParameter("time");int t=Integer.parseInt(t_temp);
		
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			
			String sql="select * from readtime where rid="+rid+" and nid="+nid;
			Statement stmt=conn.createStatement();
			ResultSet rs=stmt.executeQuery(sql);
			String sql1="";
			if(rs.next())
			{
				sql1="update readtime set rtimes=rtimes+"+t+" where rid="+rid+" and nid="+nid;
			}else {
				sql1="insert into readtime values("+rid+","+usertype+","+nid+","+t+")";
			}
			PreparedStatement ps=conn.prepareStatement(sql1);

			ps.executeUpdate();
			
			ps.close();
			conn.close();
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
		String url="novel_read.jsp?id="+rid+"&usertype="+usertype+"&nid="+nid+"&chapter="+chapter;
		response.sendRedirect(url);
	}

 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);

	}
}
