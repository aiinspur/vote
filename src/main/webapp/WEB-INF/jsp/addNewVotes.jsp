<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加投票模块</title>
<script type="text/javascript" src="js/jquery-1.x.js"></script>
<style type="text/css">
.choice2, .modify {
	color: #99CCFF;
}

p {
	font-size: 8px;
}

a {
	text-decoration: none;
	color: #3399FF;
}

a:hover {
	text-decoration: underline;
}
</style>
</head>
<body>
	<!-- 	<form action="AddVoteServlet?flag=addvote" method="post"> -->
	<!-- 		<p>投票标题：<input type="text" name="vote_title" /></p> -->
	<!-- 		<p>投票类型：<input type="text" name="vote_type" /></p> -->
	<!-- 		<p>投票：<input type="text" name="vote_type" /></p> -->
	<!-- 		<p>投票类型：<input type="text" name="vote_type" /></p> -->
	<!-- 		<p>投票类型：<input type="text" name="vote_type" /></p> -->

	<!-- 		<input type="submit" value="提交" > -->
	<!-- 	</form> -->

	<!-- 添加投票模块 -->
	<div style="margin-top: 70px; display:" id="addinfo_div">
		<center>
			<p style="font-size: 20px;">添加新投票</p>
			<form action="VoteServlet?flag=addinfo" method="post" onsubmit="return checkAdd();">
<!-- 				这里用一个隐藏的表单来存储增加的选项数量 -->
				<input name="rowCount" type="hidden" value="2" id="rowc" />
				<table style="font-size: 15px; width: 560px; height: 300px">
					<tbody id="addinfo_tbody">
						<tr>
							<td>标题&nbsp;:&nbsp;<input type="text" name="vote_title" style="width: 200px" /></td>
						</tr>
						<tr>
							<td>
								<lable>类型</lable>
								<input type="radio" name="vote_type" value="0" checked />单选&nbsp;&nbsp; 
								<input type="radio" name="vote_type" value="1" />多选
							</td>
						</tr>
						<tr id="option1">
							<td>选项1&nbsp;:&nbsp;<input type="text" name="option1" style="width: 200px" /></td>
						</tr>
						<tr id="option2">
							<td>选项2&nbsp;:&nbsp;<input type="text" name="option2" style="width: 200px" /></td>
						</tr>
					</tbody>
					<tr>
						<td><input type="submit" value="确定" />
						<a href="javascript:addRow()" style="margin-left: 30px">增加选项</a> 
						<a href="admin.jsp" style="margin-left: 30px">取消操作</a></td>
					</tr>
				</table>
			</form>
		</center>
	</div>
	
	<script type="text/javascript">
		/****全局变量*****/
		PageTo = 0;
		maxPage = 1;
		url = "/Vote_Online/VoteServlet";
		$(document).ready(function() {
			nextPage();
		});

		function checkAdd() {
			flag = true;
			$("#addinfo_div input").each(function() {
				if ($(this).val().replace(/\ +/g, "") == "") { //replace(/\ +/g,"")去除空格
					/*  addInfo();  */
					flag = false;
				}
			});
			if (flag == false) {
				alert("提交失败，存在空的选项");
			}
			return flag;
		}

		function nextPage() {
			if (PageTo >= maxPage) {
				return;
			}
			//下一页,页码加一
			PageTo += 1;
			getPageData();
		}
		function prePage() {
			if (PageTo <= 1) {
				return;
			}
			//上一页,页码减一
			PageTo -= 1;
			getPageData();
		}

		/*根据pageto请求服务器分页内容*/
		function getPageData() {

			$
					.ajax({
						type : "post", //请求方式,get,post等
						dataType : 'json',//response返回数据的格式
						async : true, //同步请求  
						url : url, //需要访问的servlet地址
						data : 'flag=showlist&PageTo=' + PageTo, //传递到后台servlet的参数,使用getParamater接受
						success : function(data) { //能够正常访问并且正常返回servlet时回调的函数，data为response传递过来的参数
							//PageTo = data['PageTo'];
							maxPage = data['page'];
							var yy = "";
							for (var i = 0; i < data["list"].length; i++) {
								var info = data["list"][i];
								var isvote = false;
								for (var j = 0; j < data["IsVote"].length; j++) {
									if (info["vote_id"] == data["IsVote"][j]) {
										isvote = true;
									}
								}
								if (isvote) {
									yy += " <tr><td><img src='images/vote_icon.gif'/><a  style='color:grey' title='已投票' class='choice1' href='VoteServlet?flag=showVote&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "> ";
								} else {
									yy += " <tr><td><img src='images/vote_icon.gif'/><a class='choice1' href='VoteServlet?flag=showVote&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "> ";
								}
								yy += info["vote_title"];
								yy += "</a><lable style='padding-left:15px;font-size:10px;color:blue'>发起人:"
										+ info["user_name"] + "</lable>";
								yy += "<br/><p style='font-size:12px'>共有  ";
								yy += info["choose_sum"];
								yy += " 个选项，已有 ";
								yy += info["vote_sum"];
								if (isvote) {
									yy += " 个网友参与了投票<a class='choice2' title='已投票' style='float:right;color:grey'><img src='images/join_over.gif'/>&nbsp;已&nbsp;参&nbsp;与&nbsp;</a>";
								} else {
									yy += " 个网友参与了投票<a  href='VoteServlet?flag=voteInterface&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "class='choice2' style='float:right;'><img src='images/join.gif'/>&nbsp;我要参与</a>";
								}
								yy += "<a  href='VoteServlet?flag=tomodify&vote_id=";
								yy += info["vote_id"] + "'";
								yy += "class='modify' style='float:right;display:none'><img src='images/edit.gif'/>维护</a></p></td></tr>";
								$("#list_table").html(yy);
								/* alert(i); */
								info = "";
							}
							// $("#forpage").html("<a href='VoteServlet?flag=showlist&PageTo="+(data["PageTo"]+1)+"'>我是A标签</a>");  
						}
// 					,
// 				error : function() { //无法正常访问servlet时回调的函数
// 							alert("请先登入！");
// 							window.location.href = "login.jsp";
// 						}
					});

		}
		var rowCount = 2;
		$(function(e) {
			$("#list_div table tr:even").css("background-color", "#FFFFCC");

		});

		function addInfo() {
			$("#addinfo_div").css('display', 'inline');
			$("#list_div").css('display', 'none');
		}
		function addRow() {
			rowCount++;
			var newRow = '<tr id="option'+rowCount+'"><td>选项'
					+ rowCount
					+ '&nbsp;:&nbsp;<input type="text" name="option'+rowCount+'" style="width:200px" /><a href="#" onclick=delRow('
					+ rowCount + ')>&nbsp;删除</a></td></tr>';
			$("#addinfo_tbody").append(newRow);
			$("#rowc").val(rowCount);
		}
		function delRow(rowIndex) {
			$("#option" + rowIndex).remove();
			rowCount--;
			$("#rowc").val(rowCount);
		}
		function search() {
			$("#list_div").css('display', 'none');
			var url = "/Vote_Online/VoteServlet?flag=search";
			var data = {
				data : $("#search").val()
			};
			$
					.ajax({
						type : "post", //请求方式,get,post等
						dataType : 'json',//response返回数据的格式
						async : true, //同步请求  
						url : url, //需要访问的servlet地址
						data : data, //传递到后台servlet的参数,使用getParamater接受
						success : function(data) { //能够正常访问并且正常返回servlet时回调的函数，data为response传递过来的参数
							var yy = "";
							for (var i = 0; i < data["list"].length; i++) {
								var info = data["list"][i];
								var isvote = false;
								for (var j = 0; j < data["IsVote"].length; j++) {
									if (info["vote_id"] == data["IsVote"][j]) {
										isvote = true;
									}
								}
								if (isvote) {
									yy += " <tr><td><img src='images/vote_icon.gif'/><a  style='color:grey' title='已投票' class='choice1' href='VoteServlet?flag=showVote&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "> ";
								} else {
									yy += " <tr><td><img src='images/vote_icon.gif'/><a class='choice1' href='VoteServlet?flag=showVote&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "> ";
								}
								yy += info["vote_title"];
								/* yy+="<p>QST-ITshixun'"+info["user_id"]+"'</p>"; */
								yy += " </a><br/><p style='font-size:12px'>共有  ";
								yy += info["choose_sum"];
								yy += " 个选项，已有 ";
								yy += info["vote_sum"];
								if (isvote) {
									yy += " 个网友参与了投票<a class='choice2' title='已投票' style='float:right;color:grey'><img src='images/join_over.gif'/>&nbsp;已&nbsp;参&nbsp;与&nbsp;</a>";
								} else {
									yy += " 个网友参与了投票<a  href='VoteServlet?flag=voteInterface&vote_id=";
									yy += info["vote_id"] + "'";
									yy += "class='choice2' style='float:right;'><img src='images/join.gif'/>&nbsp;我要参与</a>";
								}
								yy += "<a  href='VoteServlet?flag=tomodify&vote_id=";
								yy += info["vote_id"] + "'";
								yy += "class='modify' style='float:right;display:none'><img src='images/edit.gif'/>维护</a></p></td></tr>";
								$("#search_list").html(yy);
								info = "";
							}
							//$("#mainContent").html(dates);//要刷新的div  
						},
						error : function() { //无法正常访问servlet时回调的函数
							alert("失败，请稍后再试！");
						}
					});
		}
		function modify() {
			$(".modify").css('display', 'inline');
			$(".choice2").css('display', 'none');
			$(".choice1").removeAttr('href');
			$(".choice1").attr({
				'title' : '维修状态',
				'style' : 'color:grey',

			});

		}
	</script>
</body>

</html>