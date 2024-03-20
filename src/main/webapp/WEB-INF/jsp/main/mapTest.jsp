<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <title>Select Features</title>
    <link rel="stylesheet" href="node_modules/ol/ol.css">
    <style>
      .map {
        width: 100%;
        height: 400px;
      }
    </style>
  </head>
  <body>
    <div id="map" class="map"></div>
    <form>
      <label for="type">Action type &nbsp;</label>
      <select id="type">
        <option value="click" selected>Click</option>
        <option value="singleclick">Single-click</option>
        <option value="pointermove">Hover</option>
        <option value="altclick">Alt+Click</option>
        <option value="none">None</option>
      </select>
      <span id="status">&nbsp;0 selected features</span>
    </form>
	
    <script type="module" src="<c:url value='/resouces/js/main.js'/>"></script>
  </body>
</html>