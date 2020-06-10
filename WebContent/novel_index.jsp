<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList,javax.servlet.http.*,java.util.List,java.util.regex.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
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
<link href="CSS\novel_index.css" rel="stylesheet" type="text/css" media="all">
<title>视听网站-小说</title>
</head>
<body>
<%
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

String bol_type="xuanhuan",bol_label="Lrefuse";//获取用户喜好--推荐
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
		
		String sql1="select * from novelreaderbookshelf s,novelbase b where s.rid="+id0+" and s.nid=b.nid";
		String sql2="select * from readtime t,novelbase b where t.rtimes>"+1000+" and t.nid=b.nid and t.rid="+id0;
		ResultSet rs1=stmt0.executeQuery(sql1);
		List<String> type_list=new ArrayList<String>();
		List<String> label_list=new ArrayList<String>();
		while(rs1.next()){//获取用户书架书籍主要类型---需要修改！！！
			type_list.add(rs1.getString("b.type0"));
		    label_list.add(rs1.getString("b.Llabel"));
			//bol_type=rs1.getString("b.type0");
			//bol_label=rs1.getString("b.Llabel");
			//System.out.println(bol_label);
		}
		rs1=stmt0.executeQuery(sql2);
		while(rs1.next()){
			type_list.add(rs1.getString("b.type0"));
		    label_list.add(rs1.getString("b.Llabel"));
		}
		//获取最值
		String regex;
		Pattern p;
		Matcher m;
		String tmp="";
		String type_str=type_list.toString();
		int max_cnt=0;
		String max_typestr = "";
		for(String str:type_list){
			if(tmp.equals(str)) continue;
			tmp=str;
			regex=str;
			p=Pattern.compile(regex);
			m=p.matcher(type_str);
			int cnt=0;
			while(m.find()){
				cnt++;
			}
			if(cnt>max_cnt){
				max_cnt=cnt;
				max_typestr=str;
			}
		}
		String label_str=label_list.toString();
		String max_labelstr="";
		max_cnt=0;
		tmp="";
		for(String str:label_list){
			if(tmp.equals(str)) continue;
			tmp=str;
			regex=str;
			p=Pattern.compile(regex);
			m=p.matcher(label_str);
			int cnt=0;
			while(m.find()){
				cnt++;
			}
			if(cnt>max_cnt){
				max_cnt=cnt;
				max_labelstr=str;
			}
		}
		bol_type=max_typestr;
		bol_label=max_labelstr;
		//System.out.println("max:"+max_typestr+"la"+max_labelstr);
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
    
    <a href="OutServlet?id=<%=id0%>"><button>注销</button></a>
    <%
    if(!usertype.equals("2")){
    	%>
    	<a href="reader_info.jsp?operate=wallet&rid=<%=id0%>&usertype=<%=usertype%>"><button><%out.println(name0); %>（id:<%out.println(id0); %>）</button></a>
        <%
    }
    %>
    
    <a href="index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>首页</button></a>
</div>

<div class="header1">
  <div class="header1_logo">视听小说</div>
  <%
  if(usertype.equals("1"))
  {
	  %>
	  <a href="author_info.jsp?operate=read&aid=<%=id0%>"><button>作者专区</button></a>  
	  <%
  }else if(usertype.equals("0")){
	  %>  
	  <a href="reader_info.jsp?rid=<%=id0%>&usertype=<%=usertype%>&operate=bookshell"><button>书架</button></a>
	  <%
  }else{
	  %>
	  <a href="admin_main.jsp?id=<%=id0%>&operate=d"><button>管理员专区</button></a>  
	  <%
  }
  %>
</div>

<div class="search-container">
    <form action="novelNet_search.jsp?id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
    </form>
</div>

<div class="main_container">
  <!-- 最顶部的分类 -->
  <div class="main_container_header">
  <ul>
    <li><a class="active" href="novel_index.jsp?type=all&id=<%=id0%>&usertype=<%=usertype%>">全部作品</a></li>
    <li><a class="active" href="novel_index.jsp?type=finsh&id=<%=id0%>&usertype=<%=usertype%>">完本</a></li>
    <li><a class="active" href="novel_index.jsp?type=recommend&id=<%=id0%>&usertype=<%=usertype%>">推荐</a></li>
    <li><a class="active" href="entitybook.jsp?operate=city&id=<%=id0%>&usertype=<%=usertype%>">实体书专窗</a></li>
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
  </ul>
  </div>
  <!-- 左边的分类 -->
  <div class="main_container_home">
    <div class="catalog"><!--目录-->
      <ul>
        <li><p>状态</p>
             <select id="state">
               <option value="Sall">全部</option>
               <option value="Srunning">连载</option>
               <option value="Sfinish">完本</option>
             </select>
        </li>
	    <li><p>属性</p>
	         <select id="attribute">
               <option value="Aall">全部</option>
               <option value="Amianfei">免费</option>
               <option value="Afufei">付费</option>
             </select>      
	    </li>
	    <li><p>字数</p>
	        <select id="number">
               <option value="Nall">全部</option>
               <option value="N100down">100万以下</option>
               <option value="N100to200">100万到200万</option>
               <option value="N200up">200万以上</option>
             </select>	             	
	    </li>
	    <li><p>标签</p>
	      <select id="label">
               <option value="Lall">全部</option>
               <option value="Lsoldier">特种兵</option>
               <option value="Linvincible">无敌文</option>
               <option value="Lreborn">重生</option>
               <option value="Lrefuse">废材流</option>
               <option value="Lsystem">系统流</option>
               <option value="Lteacher">老师</option>
          </select>	
	    </li>
     </ul>
     <button onClick="Export()" type="submit">提交</button>
     
     <form name="thisform" method="post">
     <input type="hidden" id="allLabel" name="allLabel"/><!-- 隐形控件 -->
     </form>
    </div> 
    <script>
 function Export(){
	 var state=document.getElementById("state");
	 var Sindex=state.selectedIndex;
	 var Svalue=state.options[Sindex].value;
	 
	 var attribute=document.getElementById("attribute");
	 var Aindex=attribute.selectedIndex;
	 var Avalue=attribute.options[Aindex].value;
	 
	 var number=document.getElementById("number");
	 var Nindex=number.selectedIndex;
	 var Nvalue=number.options[Nindex].value;
	 
	 var label=document.getElementById("label");
	 var Lindex=label.selectedIndex;
	 var Lvalue=label.options[Lindex].value;
	 
	 var allLabel=Svalue+","+Avalue+","+Nvalue+","+Lvalue;
	 document.getElementById("allLabel").value=allLabel;
	 document.thisform.submit();
	
 }
 </script>
 <%
 String allLabel=request.getParameter("allLabel");
 
 String temp[]=null;
 if(allLabel!=null)
 {
 	temp= allLabel.split(",");
 }
 String type=request.getParameter("type");
//System.out.print(allLabel);
 String Ssql="",Asql="",Nsql="",Lsql="";
 if(allLabel==null||temp[0].equals("Sall")){Ssql="";}else{Ssql=" and novelmessage.Slabel='"+temp[0]+"'";}
 if(allLabel==null||temp[1].equals("Aall")){Asql="";}else{Asql=" and novelmessage.Alabel='"+temp[1]+"'";}
 if(allLabel==null||temp[2].equals("Nall")){Nsql="";}else{Nsql=" and novelmessage.Nlabel='"+temp[2]+"'";}
 if(allLabel==null||temp[3].equals("Lall")){Lsql="";}else{Lsql=" and novelmessage.Llabel='"+temp[3]+"'";}
 String sql="";
 if(type==null||type.equals("all")){
	 //sql="select * from novelbase";
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid "+Ssql+Asql+Nsql+Lsql; 
 }else if(type.equals("finsh")){
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid and novelbase.finish=1 "+Ssql+Asql+Nsql+Lsql;
 }else if(type.equals("recommend")){
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid and (novelbase.type0='"+bol_type+"' or novelbase.Llabel='"+bol_label+"') "+Ssql+Asql+Nsql+Lsql;
 }else{
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid and novelbase.type0='"+type+"'";
 }
 Connection conn=null;
 Statement stmt=null;
 
 int nid=0;
 String name="";
 String author="";
 String type0="";
 int finish=1;
 String imagepath="";
 String txtpath="";
 String intro="";
 int worknumber=0;
 int collection=0;
 int ticket=0;
 int pass=0;
 %>
	<!-- 内容展示 -->
 <div class="content_show_left"><p style="font-size:13px;">你选择的标签有：<%if(allLabel!=null){out.print(temp[0]+" "+temp[1]+" "+temp[2]+" "+temp[3]);}%></p>
<%
 try
 {
	 Class.forName("com.mysql.cj.jdbc.Driver");
	 conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
	 stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	
	while(rs.next()){
		pass=rs.getInt("pass");
		if(pass==1){
		nid=rs.getInt("novelbase.nid");
		name=rs.getString("name");
		author=rs.getString("author");
		type0=rs.getString("type0");
		//finish=rs.getInt("finish");
		imagepath=rs.getString("imagepath");
		txtpath=rs.getString("txtpath");
		intro=rs.getString("intro");
		
		worknumber=rs.getInt("novelmessage.worknumber");
		%>
		<a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><div class="content_show_item">
        <img src="<%out.print(imagepath);%>" alt=""/>
        <p><b><%out.print(name);%></b><br>
                      作者:<%out.print(author);%><br>
                      类型:<%switch(type0)
                      {
                      case "xuanhuan":out.print("玄幻");break; case "wuxia":out.print("武侠");break; case "xianxia":out.print("仙侠");break;
                      case "dushi":out.print("都市");break; case "junshi":out.print("军事");break; case "lishi":out.print("历史");break;
                      case "xuanyi":out.print("游戏");break; case "kehuan":out.print("科幻");break; case "youxi":out.print("游戏");break;
                      default:
                    	  out.print("无");
                    	  break;
                      }%><br>
                      字数:<%out.print(worknumber);%><br>
        </p>
        <div>
          <span>剧情介绍:<br><%out.print(intro);%></span>
        </div>
        </div></a>
        <%
		}
	}
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
 
%>         
 </div>
 
 <%
 try{
	 String sql_rank1="select * from novelmessage m,novelbase b where m.nid=b.nid order by ticket desc limit 0,3";
	 String sql_rank2="select * from novelmessage m,novelbase b where m.nid=b.nid order by ticket desc limit 0,3";
	 ResultSet rs1=stmt.executeQuery(sql_rank1);
	 %>
	 <div class="content_show_right">
         <p>收藏榜</p>
         <ol>
	 <%
	 while(rs1.next())
	 {
		 nid=rs1.getInt("b.nid");
		 name=rs1.getString("b.name");
		 collection=rs1.getInt("m.collection");
		 %>
		 <li><a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><%out.print(name); %></a><span><%out.print(collection); %></span></li>
		 <%
	 }
	 %>
	     </ol>
     </div>
     <div class="content_show_right">
         <p>月票榜</p>
         <ol>
	 <%
	 ResultSet rs2=stmt.executeQuery(sql_rank2);
	 while(rs2.next())
	 {
		 nid=rs2.getInt("b.nid");
		 name=rs2.getString("b.name");
		 ticket=rs2.getInt("m.ticket");
		 %>
		 <li><a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><%out.print(name); %></a><span><%out.print(ticket); %></span></li>
		 <%
	 }
 }catch(Exception e){
		System.out.println("error"+e.toString());
 }
 conn.close();
 %>
         </ol>
    </div>
  </div>
  
</div>
</body>
</html>