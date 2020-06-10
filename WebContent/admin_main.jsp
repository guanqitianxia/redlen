<%@ page language="java" import="java.util.Random,java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
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
<link href="CSS\\admin_main.css" rel="stylesheet" type="text/css" media="all">
<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
<title>管理员界面</title>
</head>
<body>
<%
String username=request.getParameter("id");
if(username==null||username.equals("0")){username="999999";}
int id=0;
if(username!=null){id=Integer.parseInt(username);}
%>
<div class="header">
  <a href="index.jsp?id=<%=id%>&usertype=2"><button><img src="PIC\home.jpg" alt=""/>视听首页</button></a>
  <a href="novel_index.jsp?id=<%=id%>&usertype=2"><button><img src="PIC\bookhome.jpg" alt=""/>小说首页</button></a>
  <a href="OutServlet?id=<%=id%>"><button style='float:right;font-size:15px;'>注销</button></a>
</div>
<%
String opera=request.getParameter("operate");
Connection conn;
String sql="";
int aid=0,nid=0,pass=0;String imgpath="",name="",author="";
%>
<div class="body_main">
  <div class="btn-group btn-group-justified">
    <%
    if(opera.equals("d")){
    	sql="select * from novelbase where pass=2";
    	%>
    	<a href="admin_main.jsp?id=<%=id%>&operate=d" class="btn btn-info active">待处理</a>
        <a href="admin_main.jsp?id=<%=id%>&operate=r" class="btn btn-info">已处理</a>
    	<%
    }else{
    	sql="select * from novelbase where pass!=2 and pass!=0";
    	%>
    	<a href="admin_main.jsp?id=<%=id%>&operate=d" class="btn btn-info">待处理</a>
        <a href="admin_main.jsp?id=<%=id%>&operate=r" class="btn btn-info active">已处理</a>
    	<%
    }
    %>
  </div>
  <table>
    <thead>
      <tr>
        <th>编号</th>
        <th>封面</th>
        <th>作品名称</th>
        <th>作者</th>
        <th>数据</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
<%
try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		nid=rs.getInt("nid");
		aid=rs.getInt("aid");
		pass=rs.getInt("pass");
		imgpath=rs.getString("imagepath");
		name=rs.getString("name");
		author=rs.getString("author");
%>  
      <tr>
        <td><%=nid %></td>
        <td><a href="novel_item_info.jsp?id=<%=id%>&usertype=2&nid=<%=nid%>" data-toggle="tooltip" data-placement="left" title="点击查看作品内容"><img src="<%=imgpath %>" alt=""/></a></td>
        <td><%=name %></td>
        <td><a href="admin_look.jsp?type=info&id=<%=id %>&aid=<%=aid %>" data-toggle="tooltip" data-placement="left" title="点击查看作者信息"><%=author %></a></td>
        <td><a href="admin_look.jsp?type=data&id=<%=id %>&aid=<%=aid %>"><button class="btn btn-info">查看</button></a></td>
        <td>
        <%
        if(opera.equals("d"))
        {
        	%>
        	 <button type="button" onclick="opra(1,<%=nid %>)" class="btn btn-success">允许发布</button>
            <button type="button" onclick="opra(3,<%=nid %>)" class="btn btn-danger">禁止发布</button>
        	<%
        }else{
            if(pass==1){
            	%>
            	<span>已允许发布</span>
            	<!--<button type="button" class="btn btn-danger">下架</button>  -->
            	<%
            }else{
            	%>
            	<span>已禁止发布</span>
            	<%
            }
            
        }
        %>
        </td>
      </tr>
<%}
}catch(Exception e){
	System.out.println("error"+e.toString());
}  
%>
    </tbody>
  </table>
</div>
<form action="AdminOperateServlet?id=<%=id %>" name="ad_opra" method="post">
<input type="hidden" id="con" name="con"/>
</form>
<script>
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();   
});

function opra(n,nid){
	if(n==1){
		document.getElementById("con").value=n+"&null&"+nid;
	}else{
		var res_con=prompt("不通过原因");
		if(res_con!=null){
			//alert(res_con);
			document.getElementById("con").value=n+"&"+res_con+"&"+nid;
		}else{
			return;
		}
	}
	document.ad_opra.submit();
}
</script>
</body>
</html>