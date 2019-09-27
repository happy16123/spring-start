<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<div class="container-fluid">

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board Register</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-12">
			<div class="card">
				<div class="card-header">Board Register</div>
				<div class="card-body">
					<div class="form-group">
						<label>Bno</label> <input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Text area</label> <textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}"/></textarea>
					</div>
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>
					<button data-oper="modify" class="btn btn-primary">Modify</button>
					<button data-oper="list" class="btn btn-info">List</button>
					
					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
						<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
						<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
						<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>">
						<input type="hidden" name="type" value="<c:out value='${cri.type}'/>">
					</form>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-12">
			<div class="card">
				<div class="card-header">
					<i class="fa fa-comments fa-fw"></i>Reply
				</div>

				<div class="card-body">
					<ul class="chat">
						<li class="left clearfix" data-rno="12">
							<div>
								<div class="header">
									<strong class="primary-font">user00</strong>
									<small class="pull-right text-muted">2019-01-01 12:12</small>
								</div>
								<p>Good job!</p>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>


</div>
<!-- /.container-fluid -->
<%@include file="../includes/footer.jsp"%>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		const bnoValue = "<c:out value='${board.bno}'/>";
		const replyUL = $(".chat");

		showList(1);

		function showList(page){
			replyService().getList({bno : bnoValue, page : page || 1}, function(list){
				let str="";
				if(list == null || list.length == 0){
					replyUL.html("");
					return;
				}
				for(let i=0; i<list.length; i++){
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "<div><div class='header'><strong class='primary-font'" + list[i].replyer + "</strong>";
					str += "<small class='pull-right text-muted'>" + replyService().displayTime(list[i].replyDate) + "</small></div>";
					str += "<p>" + list[i].reply + "</p></div></li>";
				}
				replyUL.html(str);
			});
		}
	});

	// console.log("=============");
	// console.log("JS TEST");

	// const bnoValue = "<c:out value='${board.bno}'/>";

	// replyService().add(
	// 	{reply : "JS Test", replyer : "tester", bno : bnoValue},
	// 	function(result){
	// 		alert("RESULT : " + result);
	// 	}
	// );

	// replyService().getList({bno:bnoValue, page:1}, function(list){
	// 	console.log(list);
	// 	for(let i=0; i<list.length; i++){
	// 		console.log(list[i]);
	// 	}
	// });

</script>

<script type="text/javascript">
	$(document).ready(function(){
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e){
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e){
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
	});
	
</script>
