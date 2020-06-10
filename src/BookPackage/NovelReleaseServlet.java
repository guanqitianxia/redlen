package BookPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/NovelReleaseServlet")
public class NovelReleaseServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{
	private static Connection conn;
	private static Statement st;
	public NovelReleaseServlet() {
		super();
	}
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			st=conn.createStatement();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		String aid_temp=request.getParameter("aid");int aid=Integer.parseInt(aid_temp);
		String nid_temp=request.getParameter("nid");int nid=Integer.parseInt(nid_temp);
		System.out.println(aid_temp+" "+nid_temp);
		try{
			String sql="update novelbase set pass=2 where nid="+nid;
			
			PreparedStatement ps=conn.prepareStatement(sql);
			
			ps.executeUpdate();
			ps.close();
			//conn.close();
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
		
		String url="author_bookmanage.jsp?booktype=netmanage&aid"+aid;
		request.getRequestDispatcher(url).forward(request, response);
	}
}
