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
<link href="CSS\author_bookdata.css" rel="stylesheet" type="text/css" media="all">
<script src="https://cdn.staticfile.org/twitter-bootstrap/4.3.1/js/bootstrap.min.js"></script>
<title>作者专区--实体书数据</title>
</head>
<body>
<%
String username=request.getParameter("aid");
if(username==null||username.equals("0")){username="999999";}
int aid=0;
if(username!=null){aid=Integer.parseInt(username);}

String operate=request.getParameter("operate");
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
<%
Connection conn=null;
Statement stmt=null;
if(operate.equals("all")){
	%>
	  <table>
	  <caption>实体书销售汇总</caption>
	  <tr>
	    <th>编号</th>
	    <th>名称</th>
	    <th>单价</th>
	    <th>已销售（本）</th>
	    <th>销售总额（元）</th>
	    <th>操作</th>
	  </tr>
	<%
	String sql="select * from novelauthorentity where aid="+aid;
	int bid=0,bmoney=0,selnum=0,totalmoney=0;
	String bname="";
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
		stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(sql);
		while(rs.next()){
			bid=rs.getInt("bid");
			bname=rs.getString("bname");
			bmoney=rs.getInt("bmoney");
			selnum=rs.getInt("selnum");
			totalmoney=rs.getInt("totalmoney");
			%>
			  <tr>
			    <td><%=bid %></td>
			    <td><%=bname %></td>
			    <td><%=bmoney %></td>
			    <td><%=selnum %></td>
			    <td><%=totalmoney %></td>
			    <td><a href="author_bookdata.jsp?operate=item&aid=<%=aid%>&bid=<%=bid%>"><button>明细</button></a></td>
			  </tr>
	  <%
		}
	}catch(Exception e)
	{
		System.out.println("error"+e.toString());
	}
	  %>
	  </table>
	<%	
}else{//明细
	String bid_temp=request.getParameter("bid");int bid=Integer.parseInt(bid_temp);
	%>
	<table>
	  <caption><%=bid %>号书销售明细</caption>
	  <tr>
	    <th>序号</th>
	    <th>书名</th>
	    <th>单价</th>
	    <th>数量</th>
	    <th>交易时间</th>
	  </tr>
	<%
	String sql="select * from authoritemdata where nbid="+bid+" and btype=1";
	int sid=0,bmoney=0,bnumber=0;String bname="",btime="";
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
		stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(sql);
		while(rs.next())
		{
			%>
			<tr>
			 <td><%=rs.getInt("sid") %></td>
			 <td><%=rs.getString("bname") %></td>
			 <td><%=rs.getInt("bmoney") %></td>
			 <td><%=rs.getInt("bnumber") %></td>
			 <td><%=rs.getString("btime") %></td>
			</tr>
			<%
		}
	}catch(Exception e)
	{
		System.out.println("error"+e.toString());
	}
	%>
	</table>
	<%
}
%>
</div>
</body>
</html>