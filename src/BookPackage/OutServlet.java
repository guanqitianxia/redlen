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

//注销
@WebServlet("/OutServlet")
public class OutServlet extends HttpServlet {


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//false代表：不创建session对象，只是从request中获取。
		HttpSession session = request.getSession(false);
		if(session==null){
			return;
		}
		//System.out.println(session.getAttribute("user"));
		session.removeAttribute("user");
		//System.out.println(session.getAttribute("user"));
		//修改loginrecord表
		String id_temp=request.getParameter("id");
		int id=Integer.parseInt(id_temp);
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			/*
			Statement stmt=conn.createStatement();
			String sql="select Max(num) num from loginrecord where id="+id;
			ResultSet rs=stmt.executeQuery(sql);
			while(rs.next()) {
				System.out.println(rs.getInt("num"));
			}
			*/
			Timestamp t = new Timestamp(System.currentTimeMillis());
			String sql="update loginrecord set exittime=? where id="+id+" and num =(select Max(num) num from (select Max(num) num from loginrecord where id="+id+") t1)";
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setTimestamp(1, t);
			ps.executeUpdate();
			
			ps.close();
			conn.close();
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
		response.sendRedirect("login.html");
	}

 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);

	}

}
