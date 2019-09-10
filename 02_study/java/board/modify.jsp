<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {

		// form 태그 객체 가져오기
		var formObj = $("form");

		$("button").on("click", function(e) {

			// 원래 버튼이 해야 할 일을 멈춤
			// 여기서는 submit 이벤트를 발생하는 것을 중단함.
			e.preventDefault();

			//HTML5 부터 활용할 수 있는 data-xxx
			// 임의의 속성을 부여해 개발자가 사용할 수 있도록 해줌

			// 여기서의 this는 사용자가 클릭한 버튼 객체
			var operation = $(this).data("oper");

			//			alert(operation);

			if (operation === 'remove') {
				// form 태그의 action 속성을
				// "/board/remove"로 변경하기
				formObj.attr("action", "/board/remove");
			} else if (operation === 'list') {
				//현재 브라우저의 주소를 /board/list로 옮김
				//self.location = "/board/list";
				//return; //그대로 함수 종료

				formObj.attr("action", "/board/list").attr("method", "get");
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();

				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);

			}

			// form태그의 submit을 강제로 실행함
			formObj.submit();

		});

	});
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Modify Page</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>
			<div class="panel-body">
				<form action="/board/modify" role="form" method="post">

					<input type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum }"/>'> <input
						type="hidden" name="amount"
						value='<c:out value="${cri.amount }"/>'>

					<div class="form-group">
						<label>Bno</label> <input class="form-control" name="bno"
							value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title"
							value='<c:out value="${board.title }"/>'>
					</div>

					<div class="form-group">
						<label>Text area</label>
						<textarea rows="3" class="form-control" name="content"><c:out
								value="${board.content }" /></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer"
							value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>RegDate</label> <input class="form-control" name="regdate"
							value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.regdate }" />'
							readonly="readonly">
					</div>

					<div class="form-group">
						<label>UpdateDate</label> <input class="form-control"
							name="updateDate"
							value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.updateDate }" />'
							readonly="readonly">
					</div>




					<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
					<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
					<button type="submit" data-oper='list' class="btn btn-info">List</button>
				</form>
			</div>
		</div>
	</div>
</div>

<%@include file="../includes/footer.jsp"%>