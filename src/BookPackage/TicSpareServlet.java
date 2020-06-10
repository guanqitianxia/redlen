package BookPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TicSpareServlet")
public class TicSpareServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	private static Connection conn;
	private static Statement st;
	public TicSpareServlet() {
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
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String nid_temp=request.getParameter("nid");int nid=Integer.parseInt(nid_temp);
		String id_temp=request.getParameter("id");int id=Integer.parseInt(id_temp);//获取用户id
		String usertype=request.getParameter("usertype");//获取用户类型
		String con=request.getParameter("con");
		
		String array[]=null;
		if(con!=null) {
			array=con.split(",");
		}
		int tic_num=Integer.parseInt(array[0]);
		int judge=0;
		//System.out.println(nid+" "+tic_num);
		if(tic_judge(id,tic_num)) {
			//chage novelreaderwaller和novelmessage表
			try{
				//更新钱包表
				String sql="update novelreaderwallet set rticket=rticket-"+tic_num+" where rid="+id;			
				PreparedStatement ps=conn.prepareStatement(sql);
				ps.executeUpdate();
				//更新小说数据表
				String sql1="update novelmessage set ticket=ticket+"+tic_num+" where nid="+nid;
				ps=conn.prepareStatement(sql1);
				ps.executeUpdate();
				//更新消费记录表
				String sql2="Insert into novelreadersubscribe(rid,nid,btype,bname,bmoney,bnumber,btime) value(?,?,?,?,?,?,?)";
				ps=conn.prepareStatement(sql2);
				ps.setInt(1, id);ps.setInt(2, nid);ps.setInt(3, 0);
				ps.setString(4, array[1]);ps.setInt(5, 0);ps.setInt(6, tic_num);
				Timestamp d = new Timestamp(System.currentTimeMillis());
				ps.setTimestamp(7, d);
				ps.executeUpdate();
				
				ps.close();
				conn.close();
			}catch(Exception e){
				System.out.println("error"+e.toString());
			}
			
			judge=1;
		}
		
		String url="novel_item_info.jsp?id="+id+"&usertype="+usertype+"&nid="+nid+"&judge="+judge;
		request.getRequestDispatcher(url).forward(request, response);
		
	}
	public boolean tic_judge(int id,int tic_num){
		String sql="select * from novelreaderwallet where rid="+id;
		int rticket=0;
		try {
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()) {
				rticket=rs.getInt("rticket");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		if(rticket>=tic_num) {
			return true;
		}
		return false;
		
	}

}
