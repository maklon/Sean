<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="utf-8" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>后台管理登录</title>
<link href="../Bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../Bootstrap/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
<link href="Css/cms.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../Scripts/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	function Logining(){
		if ($("#uname").val()=="" || $("#pwd").val()==""){
			
		}
	}
</script>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	<div class="navbar-header"><a class="navbar-brand" href="#">Sean 内容管理后台</a></div>
</nav>
<div class="container">
	<form runat="server" style="width:500px; margin:0px auto;">
    	<h2>Sean内容后台管理登录</h2>
        <div class="input-group">
        	<span class="input-group-addon">登录账号：</span>
            <input type="text" class="form-control" placeholder="登录用户名" id="uname" />
        </div>
        <div class="input-group" style="margin-top:10px; margin-bottom:10px;">
        	<span class="input-group-addon">登录密码：</span>
            <input type="text" class="form-control" placeholder="登录密码" id="pwd" />
        </div>
        <div style="text-align:center;" id="area_btn">
        	<button class="btn btn-primary" type="button">登录</button>
        </div>
        <div class="progress progress-striped active" style="display:none;">
        	<div class="progress-bar" role="progressbar" aria-value="50" aria-valuemin="0" aria-valuemax="100"></div>    
        </div>
    </form>
</div>
</body>
</html>
