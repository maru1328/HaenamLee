<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp"%>

<script type="text/javascript">
	$(document).ready(function(){
		var result = '<c:out value="${result}"/>';
		
		checkModal(result);
		
		// history stack을 초기화 시킴
		//  사용할 데이터를 아무것도 없게 만들어 준다.
		history.replaceState({}, null, null);
		
		// 모달창을 띄워야 하는지를 검사하고, 띄워야 할 때 모달창을 띄움
		function checkModal(result){
			//1) result에 아무것도 없으면 모달창 안띄움
			if(result === '' || history.state){
				return;
			}
			//2) result가 0보다 클때만 모달창 띄움
			if(parseInt(result) > 0){
				$(".modal-body").html("게시글 "+ parseInt(result) + " 번이 등록되었습니다.");
				
				$("#myModal").modal("show");
			}
		}
		
		$("#regBtn").on("click", function(){
			self.location = "/board/register";
		});
		
		var actionForm = $("#actionForm");
		
		//paginate_button 클래스가 적용된 a 태그들을 선택함
		$(".paginate_button a").on("click", function(e){
			e.preventDefault();
			//actionForm안에 있는 pageNum의 값을 변경시켜줌
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		$('.move').on("click", function(e){
			e.preventDefault();

// 제목을 누를 때마다 actionForm에 bno가 들어있는 input 태그를 추가시켜준다.
actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");

// actionForm의 이동할 url을 /board/list에서 /board/get으로 바꿔준다.
actionForm.attr("action", "/board/get");
actionForm.submit();
		});
		
		var searchForm = $("#searchForm");
		
		$("#searchForm button").on("click", function(e){
			
			//검색 종류 선택을 하지 않았을 경우
			if(!searchForm.find("option:selected").val()){
				alert("검색종류를 선택하세요");
				return false;
			}
			
			//검색어를 입력하지 않았을 때
			if(!searchForm.find("input[name='keyword']").val()){
				alert('키워드를 입력하세요');
				return false;
			}
			
			// 몇 페이지에서 검색하던 기본 페이지가 1이 될 수 있게끔 설정
			searchForm.find("input[name='pageNum']").val("1");
			
			// 방어코드
			e.preventDefault();
			searchForm.submit();
			
			
		});
		
		
	});
	
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
			<span>Board List Page 총 ${ pageMaker.total }개의 글이 있습니다.</span>
			<button id='regBtn' type='button' class='btn btn-xs pull-right'>Register New Board</button>
			</div>
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="board">
							<tr>
								<td><c:out value="${board.bno}" /></td>
								<td><a class='move' href="<c:out value='${board.bno }'/>"><c:out value="${board.title}" /></a></td>
								<td><c:out value="${board.writer}" /></td>
								<td><fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd"/></td>
								<td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

<div class='row'>
	<div class='col-lg-12'>
		<form action="/board/list" id="searchForm">
		
		<select name="type">
<option value="" <c:out value="${ pageMaker.cri.type==null ? 'selected' : '' }"/>>--</option>
<option value="T" <c:out value="${ pageMaker.cri.type eq 'T' ? 'selected' : '' }"/>>제목</option>
<option value="C" <c:out value="${ pageMaker.cri.type eq 'C' ? 'selected' : '' }"/>>내용</option>
<option value="W" <c:out value="${ pageMaker.cri.type eq 'W' ? 'selected' : '' }"/>>작성자</option>
<option value="TC" <c:out value="${ pageMaker.cri.type eq 'TC' ? 'selected' : '' }"/>>제목 또는 내용</option>
<option value="TW" <c:out value="${ pageMaker.cri.type eq 'TW' ? 'selected' : '' }"/>>제목 또는 작성자</option>
<option value="TCW" <c:out value="${ pageMaker.cri.type eq 'TCW' ? 'selected' : '' }"/>>제목 또는 내용 또는 작성자</option>
		</select>
<input type="text" name="keyword" value="<c:out value='${ pageMaker.cri.keyword }'/>">

<input type="hidden" name="pageNum"
					value="${pageMaker.cri.pageNum }">
<input type="hidden" name=amount
					value="${ pageMaker.cri.amount}">
<button class="btn btn-default">Search</button>
		
		</form>
	</div>
</div>				
				
				
				
<!-- 페이지 번호 부여 -->
<div class='pull-right'>
	<ul class='pagination'>
		<c:if test="${pageMaker.prev }">
			<li class="paginate_button previous">
				<a href="${pageMaker.startPage-1}">Previous</a>
			</li>
		</c:if>
		
		<c:forEach var="num"
				   begin="${pageMaker.startPage}"
				   end="${pageMaker.endPage }">
		
<!-- 현재 페이지 번호와 넘버링된 페이지 번호가 일치한다면 -->
<li class="paginate_button ${pageMaker.cri.pageNum == num ? "active" : ""}">
<a href="${num}">${num}</a>
</li>
		</c:forEach>
		
		<c:if test="${pageMaker.next }">
			<li class="paginate_button next">
				<a href="${ pageMaker.endPage + 1 }">Next</a>
			</li>
		</c:if>
	</ul>
	
	<!-- 위의 페이지 앵커 태그들을 눌렀을 때
					list url로 각 파라미터를 전달하기 위함 -->
	<form id="actionForm" action="/board/list">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name='type' value='<c:out value="${ pageMaker.cri.type }" />'/>
		<input type="hidden" name='keyword' value='<c:out value="${ pageMaker.cri.keyword }" />'/>
	</form>
	
</div>


				<!-- 처리 완료 모달 -->
<div class="modal fade" id="myModal"
	 tabindex="-1" role="dialog"
	 aria-labelledby='myModalLabel' aria-hidden='true'>
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button"
						class="close"
						data-dismiss="modal"
						aria-hidden="true">
				&times;
				</button>
				<h4 class="modal-title"
				    id="myModalLabel">글 등록 성공</h4>
			</div>
			<div class="modal-body">처리가 완료되었습니다.</div>
			<div class="modal-footer">
				<button type="button"
						class="btn btn-default"
						data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">
					Save Changes
				</button>
			</div>
		</div>
	</div>
	
</div>								
				
				
			</div>
		</div>
	</div>
</div>
<!-- /.row -->
<%@include file="../includes/footer.jsp" %>