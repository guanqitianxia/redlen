<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList,java.io.IOException,
java.io.BufferedReader,java.io.BufferedWriter,java.io.File,java.io.FileInputStream,java.io.FileOutputStream,java.io.InputStreamReader,java.io.OutputStreamWriter" contentType="text/html; charset=utf-8"
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
<link href="CSS\admin_look.css" rel="stylesheet" type="text/css" media="all">
<title>作品信息查看</title>
</head>
<body>
<%
String aid_temp=request.getParameter("aid");int aid=Integer.parseInt(aid_temp);
String id_temp=request.getParameter("id");int id=Integer.parseInt(id_temp);
String type=request.getParameter("type");

String arealname="",apenname="",agrade="",aidentityID="",apositionC="",apositionX="",aphone="",amail="",aimagepath="";
int asex=0,aqq=0;
try{
	String sql="select * from novelauthorinfo where aid="+aid;
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
	arealname=rs.getString("arealname");apenname=rs.getString("apenname");agrade=rs.getString("agrade");
	aidentityID=rs.getString("aidentityID");apositionC=rs.getString("apositionC");apositionX=rs.getString("apositionX");
	aphone=rs.getString("aphone");amail=rs.getString("amail");aqq=rs.getInt("aqq");aimagepath=rs.getString("aimagepath");
	asex=rs.getInt("asex");
	}
	
	conn.close();
	
}catch(Exception e){
	System.out.println("error"+e.toString());
}
aimagepath=aimagepath.replace('\\','/');
%>
<a href="admin_main.jsp?id=<%=id%>&operate=d" style="color:blue;text-decoration:none;'">返回</a><span>&nbsp;//&nbsp;作者信息</span>

<div class="author">
  <div class="image">
    <img src="<%=aimagepath%>"/>
    <p><%=apenname%></p>
  </div>
  <div class="information">
    <ul>
       <li>笔名:<input type="text"  readonly="readonly" value="<%out.print(apenname); %>"></li>
       <li>真名:<input type="text"  readonly="readonly" value="<%out.print(arealname); %>"></li>
       <li>称号等级:<input type="text"  readonly="readonly" value="<%out.print(agrade); %>"></li>
       <li>作家ID:<input type="text"  readonly="readonly" value="<%out.print(aid); %>"></li>
       <li>证件号:<input type="text" readonly="readonly" style="ime-mode:disabled" value="<%out.print(aidentityID); %>"></li>
       <li>性别:
       <select id="asex" name="asex">
         <%if(asex==1)
        	{
        	 %>
        	 <option value="1" selected = "selected">男</option>
             <option value="0">女</option>
        	 <%
        	}else{
        	  %>
           	 <option value="1">男</option>
              <option value="0" selected = "selected">女</option>
           	 <%
        	}
          %>
       </select>
       </li>
       <li>常住地:<input type="text" maxlength="50" readonly="readonly" value="<%out.print(apositionC); %>"></li>
       <li>详细地址:<input type="text" maxlength="50" readonly="readonly" value="<%out.print(apositionX); %>"></li>
       <li>手机号码:<input type="number" maxlength="11" readonly="readonly" value="<%out.print(aphone); %>"></li>
       <li>电子邮箱:<input type="text" maxlength="20" style="ime-mode:disabled" readonly="readonly" value="<%out.print(amail); %>"></li>
       <li>QQ号:<input type="number" maxlength="11" readonly="readonly" value="<%out.print(aqq); %>"></li>
    </ul>
  </div>
</div>

</body>
</html>