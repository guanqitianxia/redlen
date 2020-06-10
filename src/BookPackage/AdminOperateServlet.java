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

@WebServlet("/AdminOperateServlet")
public class AdminOperateServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	private static Connection conn;
	private static Statement st;
	public AdminOperateServlet() {
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
		String con=request.getParameter("con");
		String id_temp=request.getParameter("id");int id=Integer.parseInt(id_temp);
		
		nb_update(con);
		
		String url="admin_main.jsp?id="+id+"&operate=d";
		request.getRequestDispatcher(url).forward(request, response);
	}
	public void nb_update(String con) {
		String array[]=null;
		if(con!=null) {
			array=con.split("&");
		}
		int nid=Integer.parseInt(array[2]);
		System.out.println(array[1]);
		try{
			String sql="update novelbase set pass=?,npres=? where nid="+nid;
			
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setInt(1,Integer.parseInt(array[0]));
			//ps.setInt(1, 2);
			ps.setString(2, array[1]);
			
			ps.executeUpdate();
			ps.close();
			conn.close();
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
	}

}
