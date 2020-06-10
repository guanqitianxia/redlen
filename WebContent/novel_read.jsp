<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.Date,java.io.IOException,java.util.ArrayList,
java.io.BufferedReader,java.io.BufferedWriter,java.io.File,java.io.FileInputStream,java.io.FileOutputStream,java.io.InputStreamReader,java.io.OutputStreamWriter" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/4.3.1/css/bootstrap.min.css">
<link href="CSS\novel_read.css" rel="stylesheet">
<script src="https://cdn.staticfile.org/jquery/3.2.1/jquery.min.js"></script>
<script src="https://cdn.staticfile.org/popper.js/1.15.0/umd/popper.min.js"></script>
<script src="https://cdn.staticfile.org/twitter-bootstrap/4.3.1/js/bootstrap.min.js"></script>

<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<title>小说阅读</title>
</head>

<body onbeforeunload="return out()">

<script>
var s=new Date(); 

function out(){
	var e=new Date();
	var t=(e.getTime()-s.getTime());
	
	var Hour_Param = 1000*60*60;//一小时等于毫秒数
	var Min_Param = 1000*60;//一分钟等于毫秒数
	
	var S=Math.floor(t/1000);//直接保存秒数
	
	document.getElementById("time").value=S;
    document.timeTosql.submit();
}
</script>
<%
String user_sess=(String)session.getAttribute("user");
if (user_sess == null) {
	// 没有登录成功，跳转到登录页面
	response.sendRedirect(request.getContextPath() + "/login.html");
	return;
}


String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
String sql0="";String getname="";
if(usertype.equals("1")){
	sql0="select * from novelauthorinfo where aid="+id0;getname="apenname";
}else{
	sql0="select * from novelreaderinfo where rid="+id0;getname="rname";
}
Connection conn0=null;
Statement stmt0=null;

String name0="";
if(username0!=null)
{
	try
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn0=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
		stmt0=conn0.createStatement();
		ResultSet rs=stmt0.executeQuery(sql0);
		rs.next();
		name0=rs.getString(getname);
	}
	catch(SQLException e)
	{
		System.out.println("Mysql操作错误");
		e.printStackTrace();
	}
	catch (Exception e) 
	{
	    e.printStackTrace();
	 } 
	finally 
	{
	    conn0.close();
	 }
}
%>

<div class="header">
  <ul>
    <li class="header_title">视听小说</li>
    <li class="header1"><a href="novel_index.jsp?type=all&id=<%=id0%>&usertype=<%=usertype%>">全部作品</a></li>
    <li class="classify">
      <a href="" class="classify_btn">分类</a>
        <div class="classify_content">
          <a href="novel_index.jsp?type=xuanhuan&id=<%=id0%>&usertype=<%=usertype%>">玄幻</a>
          <a href="novel_index.jsp?type=wuxia&id=<%=id0%>&usertype=<%=usertype%>">武侠</a>
          <a href="novel_index.jsp?type=xianxia&id=<%=id0%>&usertype=<%=usertype%>">仙侠</a>
          <a href="novel_index.jsp?type=dushi&id=<%=id0%>&usertype=<%=usertype%>" >都市</a>
          <a href="novel_index.jsp?type=junshi&id=<%=id0%>&usertype=<%=usertype%>">军事</a>
          <a href="novel_index.jsp?type=lishi&id=<%=id0%>&usertype=<%=usertype%>">历史</a>
          <a href="novel_index.jsp?type=xuanyi&id=<%=id0%>&usertype=<%=usertype%>">悬疑</a>
          <a href="novel_index.jsp?type=kehuan&id=<%=id0%>&usertype=<%=usertype%>">科幻</a>
          <a href="novel_index.jsp?type=youxi&id=<%=id0%>&usertype=<%=usertype%>">游戏</a>
        </div>
    </li>
    <li class="header2">
      <form action="novelNet_search.jsp?id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
      </form>
    </li>
    <li class="header3">
    <%
    if(!usertype.equals("2")){
    	%>
    	<a href="reader_info.jsp?operate=wallet&rid=<%=id0%>&usertype=<%=usertype%>"><button><%out.println(name0); %>（id:<%out.println(id0); %>）</button></a>
        <%
    }
    %>
  <a href="index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>首页</button></a>
    </li>
  </ul>

</div>
<%
String nid=request.getParameter("nid");
String cid=request.getParameter("chapter");//获取章节数
Connection conn=null;
Statement stmt=null;
int id=Integer.parseInt(nid);
int chapter=Integer.parseInt(cid);
//上下一章
int temp;
temp=chapter-1;
String chapterSub=temp+"";
temp=chapter+1;
String chapterAdd=temp+"";

String sql="select * from novelbase where nid="+id;

String name="",author="",type0="",finish="",imagepath="",txtpath="";
String intro="";
try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	rs.next();
	name=rs.getString("name");
	author=rs.getString("author");
	type0=rs.getString("type0");
	finish=rs.getString("finish");
	imagepath=rs.getString("imagepath");
	txtpath=rs.getString("txtpath");
	
}
catch(SQLException e)
{
	System.out.println("Mysql操作错误");
	e.printStackTrace();
}
catch (Exception e) 
{
        e.printStackTrace();
 } 
finally 
{
        conn.close();
 }
//读取txt文件
ArrayList<String> arraylist=new ArrayList<>();
try{
	String pathTemp=txtpath;
	File file=new File(pathTemp);
	//File file=new File("novel/xuanhuan/10001.txt");
	InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
	BufferedReader br=new BufferedReader(inputReader);
	
	String line;
	while((line=br.readLine())!=null){
		if(line.equals(""))//空白行
		{
			continue;
		}
		arraylist.add(line);
	}
	br.close();
	inputReader.close();
}catch(IOException e){
	e.printStackTrace();
}
int length=arraylist.size();
ArrayList<String> arraytitle=new ArrayList<>();//保存章节
int num=0;//某章节对应的
int t=0;//用于去掉正文的章节名
String content_show="";
for(int i=0;i<length;i++){
	String s=arraylist.get(i);
	if(!s.equals(""))
	{
		
		String text0="";
		text0=s.substring(0,1);
		boolean judge=s.contains("章");
		int len=s.length();
		if(text0.equals("第")&&judge&&len<30){//找到有第*章的行
			num++;
			arraytitle.add(s);
			//System.out.println(s);
		}
		if(num==chapter)
		{
			if(t>0)//不是章节名
			{
				content_show=content_show+s;//拼接属于该章节的行
			}
			t++;
		}
		
	}
}
System.out.println(num);
if(chapter<=0||chapter>num){//章节数不存在
	request.getRequestDispatcher("novel_item_info.jsp").forward(request, response);
}
%>
<!-- 阅读时间写入sql -->
<form action="ReadTimeServlet?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=num%>" name="timeTosql" method="post">
<input type="hidden" id="time" name="time"/>
</form>
<!-- 主要内容显示 -->
<div class="main_container">
  <div class="main_container_catalog">
    <ul>
      <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><li>目录</li></a>
	  <a href ="" data-toggle="modal" data-target="#myModal"><li>设置</li></a>
	  <a href="reader_info.jsp?rid=<%=id0%>&operate=bookshell&usertype=<%=usertype%>"><li>书架</li></a>
    </ul>
  </div>
  
  <div id="cs" class="main_container_show">
     <div class="main_container_show_title"><%out.print(arraytitle.get(chapter-1)); %></div>
     <div class="main_container_show_operate">
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterSub%>"><button>上一章</button></a>
       <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><button>目录</button></a>
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterAdd%>"><button>下一章</button></a>
     </div>
     <div class="main_container_show_show"><%out.print(content_show); %></div>
     <div class="main_container_show_operate">
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterSub%>"><button>上一章</button></a>
       <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><button>目录</button></a>
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterAdd%>"><button>下一章</button></a>
     </div>
  </div>
</div>

<script>
function bgcfs(){
	var bgc=$("input[name='bgcolor']:checked").val();
	var fs=$("input[name='fontsize']:checked").val();
	
	var csc=document.getElementById('cs');
	csc.style.backgroundColor=bgc;
	csc.style.fontSize=fs;
	
	document.cookie="bgcc="+escape(bgc);
	document.cookie="fsc="+escape(fs);
}
if(document.cookie.length>0){
	var csc=document.getElementById('cs');
	
	var str_c=document.cookie;
	var arr_c=str_c.split(";");
	for(var i=0;i<arr_c.length;i++){
		var arr=arr_c[i].split("=");
		if(arr[0]=="bgcc"){
			csc.style.backgroundColor=arr[1];
		}
		if(arr[0]=="fsc"){
			csc.style.fontSize=arr[1];
		}
	}
}
</script>
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">背景颜色和字体大小</h4>
			</div>
			<div class="modal-body">
			<!-- 主要书写 -->
			  <label style="background-color:PaleGreen;width:90px;height:30px;"><input name="bgcolor" value="PaleGreen" type="radio" />PaleGreen</label>
			  <label style="background-color:pink;width:90px;height:30px;"><input name="bgcolor" value="pink" type="radio" />pink</label>
			  <label style="background-color:PeachPuff;width:90px;height:30px;"><input name="bgcolor" value="PeachPuff" type="radio" />PeachPuff</label>
			  <label style="background-color:gray;width:90px;height:30px;"><input name="bgcolor" value="gray" type="radio" />gray</label>
			  
		      <br><br>
		      <label style="background-color:#FAEBD7;width:80px;height:30px;"><input name="fontsize" value="10px" type="radio" />小号</label>
		      <label style="background-color:#FAEBD7;width:80px;height:30px;"><input name="fontsize" value="13px" type="radio" />较小</label>
		      <label style="background-color:#FAEBD7;width:80px;height:30px;"><input name="fontsize" value="15px" type="radio" />中号</label>
		      <label style="background-color:#FAEBD7;width:80px;height:30px;"><input name="fontsize" value="18px" type="radio" />较大</label>
		      <label style="background-color:#FAEBD7;width:80px;height:30px;"><input name="fontsize" value="20px" type="radio" />大号</label>
		      
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" 
						data-dismiss="modal">关闭
				</button>
				<button type="button" class="btn btn-primary" onclick="bgcfs()">
					提交更改
				</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</body>
</html>