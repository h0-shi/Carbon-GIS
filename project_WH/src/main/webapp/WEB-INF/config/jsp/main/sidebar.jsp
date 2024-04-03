<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
body, html{
	height: 100%;
	width: 100%;
	margin: 0;
}
.left-side-bar {
    background-color: #dfdfdf;
    height: 100%;
    width: 200px;
    left: 0;
    top: 0;
    margin: 0;
}
.category{
	height: 100%;
	width: 50%;
	float: left;
	background-color: white;
}
.detailMenu{
	height: 100%;
	width: 50%;
	float: left;
	background-color: black;
}

.left-side-bar > ul li {
    position: relative;
}
.left-side-bar ul {
    font-weight: bold;
    text-align: center;
    padding: 0;
}

.left-side-bar ul > li > a {
    display: block;
    padding: 10px;
    white-space: nowrap;
    font-size: x-small;
}
</style>
</head>
<body>
  <div class="left-side-bar">
        <div class="status-ico">
        	탄소 지도 뭐시기
        </div>
		<div class="category">
	        <ul>
	            <li><a href="./hover.do">탄소공간지도</a></li>
	            <li><a href="./analysis.do">탄소통계</a></li>
	        </ul>
		</div>
		<div class="detailMenu">
			<select>
				<option>가
				<option>나
			</select>
			<select>
				<option>가
				<option>나
			</select>
			<select>
				<option>가
				<option>나
			</select>
		</div>
    </div>
</body>
</html>