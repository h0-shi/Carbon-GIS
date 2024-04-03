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
    width: 70px;
    left: 0;
    top: 0;
    margin: 0;
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
            <span>▶</span>
            <span>▼</span>
        </div>

        <ul>
            <li><a href="./hover.do">탄소공간지도</a></li>
            <li><a href="./analysis.do">탄소통계</a></li>
        </ul>
    </div>
</body>
</html>