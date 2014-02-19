<!doctype html>
<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="utf-8" %>
<html>
<head>
<meta charset="utf-8">
<title></title>
<link href="../Bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../Bootstrap/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
<link href="Css/cms.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../Scripts/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../Bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse-1"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
      <a class="navbar-brand" href="#">Sean 内容管理后台</a> </div>
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="#">首页管理</a></li>
        <li><a href="#">相册管理</a></li>
        <li><a href="#">博客管理</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right" style="margin-right:10px;">
        <li><a href="#"><%=Session["ManagerName"]%>&nbsp;退出</a></li>
      </ul>
    </div>
</nav>
</body>
</html>
