<%@page import="java.util.ArrayList"%>
<%@page import="com.multi.FM.manager.ReportVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% ArrayList<ReportVO> vo = (ArrayList<ReportVO>) request.getAttribute("report_list"); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모든 축제의 부스를 담다 - 부스락</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user_list.css" type="text/css">
    <script src="${pageContext.request.contextPath}/resources/js/user_list.js" defer type="text/javascript"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
	        var urlParams = new URLSearchParams(window.location.search);
	        var type = urlParams.get("type");
	        var keyword = urlParams.get("keyword");
	
	        if (type && keyword) {
	            $("#type").val(type);
	            $("#keyword").val(keyword);
	            search(1);
	        }
		});
		
	    $(function(){
		    var pages = <%= request.getAttribute("pages") %>;
		    $(document).on('click', '.pages', function(){
	        	var page = $(this).text();
	        	
	            $.ajax({
	                type: "POST",
	                url: "report_list",
	                data: {
	                    page: page
	                },
	                success: function(data){
	                    var tbody = $(data).find("tbody").html();
	                    $('#result').html(tbody);
			        	list_pagination(pages, page);
	                }
	            });
	            
	            function list_pagination(pages, page) {
			        $("#pagination").empty();
			        var current_page = parseInt(page);
			        
			        if (current_page == 1) {
			       		var prev = '<button><i class="fa-solid fa-chevron-left"></i></button>';
			        	$("#pagination").append(prev);
			        } else {
			       		var prev = '<button style="font-size: 0;" class="pages">' + (current_page - 1) + '<i class="fa-solid fa-chevron-left"></i></button>';
			        	$("#pagination").append(prev);
			        }
			        if (pages > 5) {
			        	if (current_page > 3) {
					        for (var i = (current_page - 2); i <= (current_page + 2); i++) {
					            var page = '<button class="pages">' + i + '</button>';
					            $("#pagination").append(page);
					        }
			        	}
			        } else {
				        for (var i = 1; i <= pages; i++) {
				            var page = '<button class="pages">' + i + '</button>';
				            $("#pagination").append(page);
				        }
			        }
			        
			        if (current_page == pages) {
			       		var next = '<button><i class="fa-solid fa-chevron-right"></i></button>';
			        	$("#pagination").append(next);
			        } else {
			       		var next = '<button style="font-size: 0;" class="pages">' + (current_page + 1) + '<i class="fa-solid fa-chevron-right"></i></button>';
			        	$("#pagination").append(next);
			        }
			    }
	        });
	    });
	
	    function search(page) {
	        var type = $("#type").val();
	        var keyword = $("#keyword").val();
			
	        $.ajax({
	            type: "POST",
	            url: "report_search",
	            data: {
	                page: page,
	                type: type,
	                keyword: keyword,
	            },
	            success: function(data) {
	                $("tbody").empty();
	                $.each(data.report_search, function(index, report) {
	                	var row = "<tr>" +
	                	"<td>" + booth.booth_no + "</td>" +
	                    "<td><a href='user_detail?user_id=booth_seller_id'>" + booth.seller_id + "</a></td>" +
	                    "<td><a href='../booth/booth_detail?booth_no=" + booth.booth_no + "'>" + booth.booth_name + "</a></td>" +
	                    "<td><a href='../fstv/fstv_detail?fstv_no=" + booth.fstv_no + "'>" + booth.fstv_title + "</a></td>" +
						"<td>" + booth.report_count + "회 </td>" +
	                    "<td><button class='update_booth'>등록</button></td>" + 
	                    "<td><button class='delete'>삭제</button></td>";
	
	                    $("tbody").append(row);
	                });
	                search_pagination(data.search_pages, page);
	            }
	        });
	        
	        function search_pagination(pages, page) {
	            $("#pagination").empty();
	            var current_page = page || 1;
	            
	            if (current_page == 1) {
		       		var prev = '<button><i class="fa-solid fa-chevron-left"></i></button>';
		        	$("#pagination").append(prev);
		        } else {
		       		var prev = '<button style="font-size: 0;" onclick="search(' + (current_page - 1) + ')"><i class="fa-solid fa-chevron-left"></i></button>';
		        	$("#pagination").append(prev);
		        }
	            
	            for (var i = 1; i <= pages; i++) {
	                var page = '<button onclick="search(' + i + ')">' + i + '</button>';
	                $("#pagination").append(page);
	            }
	            
		        if (current_page == pages) {
		       		var next = '<button><i class="fa-solid fa-chevron-right"></i></button>';
		        	$("#pagination").append(next);
		        } else {
		       		var next = '<button style="font-size: 0;" onclick="search(' + (current_page + 1) + ')"><i class="fa-solid fa-chevron-right"></i></button>';
		        	$("#pagination").append(next);
		        }
	        }
		    function update_booth(action, message) {
		    	var tr = $(this).closest('tr');
		    	var booth_no = tr.find('.booth-no').text();
		    	var booth_ban = tr.find('.booth-ban').text();
		    	
	            $.ajax({
	                type: "POST",
	                url: action,
	                data: { booth_no: booth_no },
	                success: function(data) {
	                    alert(message);
	                    if (parseInt(booth_ban) == 1) {
	                        window.location.href = 'ban_booth_list';
	                    } else {
	                        window.location.href = 'booth_list';
	                    }
	                }
	            });
	        }

	        $(".update_booth").on("click", function() {
	        	update_booth("update_booth", "허위 부스 변경이 완료되었습니다.");
	        });
	    }
	</script>
</head>
<body>
    <%@ include file="../../../manager/admin_header.jsp" %>
    
    <div class="bodywrap">
    	<div class="report-list-form"> <!-- 페이징 필요 -->
	    	<h1>Report List</h1>
	    	<div class="select-search-form">
		    	<select name="type" id="type">
		    		<option>Option</option>
				    <option value="title">Title</option>
				    <option value="email">Email</option>
				    <option value="booth">Booth</option>
				    <option value="created">Created</option>
		    	</select>
		    	<input name="keyword" type="text" id="keyword">
		    	<input type="button" id="submit" value="검색" onclick="search()">
	    	</div>
	    	<table>
				<thead>
    				<tr>
      					<th>No</th>
					    <th>Title</th>
					    <th>Email</th>
					    <th>Booth</th>
					    <th>Created</th>
					    <th>Resolved</th>
    				</tr>
				</thead>
				<tbody id="result">
					<c:forEach items="${report_list}" var="vo">
	    				<tr>
					      	<td>${vo.report_no}</td>
					      	<td><a href="report_detail?report_no=${vo.report_no}">${vo.report_title}</a></td>
					      	<td><a href="user_detail?user_id=${vo.user_id}">${vo.user_id}</a></td>
					      	<td><a href="booth_detail?booth_no=${vo.booth_no}">${vo.booth_name}</a></td>
					      	<td>${vo.report_date}</td>
					      	<td></td>
					    </tr>
					</c:forEach>
				</tbody>
			</table>
			<div id="pagination">
				<c:forEach var="i" begin="1" end="${pages}"><button class="pages">${i}</button></c:forEach>
			</div>
		</div>
    </div>
    
    <%@ include file="../../../footer.jsp" %>
    
</body>
</html>
