<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
String user_sess=(String)session.getAttribute("user");
if (user_sess == null) {
	// 没有登录成功，跳转到登录页面
	response.sendRedirect(request.getContextPath() + "/login.html");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\author_noveldata.css" rel="stylesheet" type="text/css" media="all">
<title>作者专区--小说数据</title>
</head>
<body>
<%
String username=request.getParameter("aid");
if(username==null||username.equals("0")){username="999999";}
int aid=0;
if(username!=null){aid=Integer.parseInt(username);}

%>
<div class="header">
  <a href="index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\home.jpg" alt=""/>视听首页</button></a>
  <a href="novel_index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\bookhome.jpg" alt=""/>小说首页</button></a>
  <a href="OutServlet?id=<%=aid%>"><button style='float:right;font-size:15px;'>注销</button></a>
</div>
<div class="catalog">
   <ul>
     <li><a href="author_info.jsp?operate=read&aid=<%=aid%>">个人资料</a></li>
    <li class="dropbtn"><a href="">实体书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=entitymanage&aid=<%=aid%>">管理</a>
        <a href="author_bookdata.jsp?operate=all&aid=<%=aid%>">数据统计</a>
      </div>
    </li>
    <li class="dropbtn"><a href="">电子书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=netmanage&aid=<%=aid%>">管理</a>   
        <a href="author_noveldata.jsp?aid=<%=aid%>">数据统计</a>
      </div>
    </li>
   </ul>
</div>

<div class="data_show">
  <table>
    <caption>小说已获得的成绩</caption>
    <tr>
      <th>小说编号</th>
      <th>书名</th>
      <th>总字数</th>
      <th>收藏数</th>
      <th>月票数</th>
    </tr>
    <%
    String sql="select * from novelmessage m,novelbase b where m.nid=b.nid and b.nid in (select nid from novelbase where aid="+aid+")";
    try{
    	Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
		Statement stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(sql);
		while(rs.next()){
			%>
	<tr>
      <td><%=rs.getInt("m.nid") %></td>
      <td><%=rs.getString("b.name") %></td>
      <td><%=rs.getInt("m.worknumber") %></td>
      <td><%=rs.getInt("m.collection") %></td>
      <td><%=rs.getInt("m.ticket") %></td>
    </tr>
			<%
		}
    }catch(Exception e){
    	System.out.println("error"+e.toString());
    }
    %>
  </table>
</div>
</body>
</html>