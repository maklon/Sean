<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Page Title="博客内容" Language="C#" MasterPageFile="~/Manage/MasterPage.master" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL, sId;
    int Id;
    string Title, Tags, PublishData, Content;

    protected void Page_Load(object sender, EventArgs e) {
        sId = Request.QueryString["id"];
        if (string.IsNullOrEmpty(sId) || !General.IsMatch(sId, "^\\d+$")) {
            Id = 0;
        } else {
            Id = int.Parse(sId);
        }
        if (Id == 0) {
            Title = "";
            Content = "";
            Tags = "";
            PublishData = DateTime.Today.ToShortDateString();
            return;
        }
        SQL = "SELECT * FROM Sean_BlogList WHERE Id=" + Id;
        Sr = MZ.GetReader(SQL);
        if (Sr.Read()) {
            Title = Sr.GetString(1);
            Content = Sr.GetString(2);
            Tags = Sr.GetString(3);
            PublishData = Sr.GetDateTime(5).ToShortDateString();
            Sr.Close();
        } else {
            Sr.Close();
            Id = 0;
        }
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" Runat="Server">
    <style type="text/css">
        #RichTextBox {
	        overflow: scroll;
	        min-height: 300px;
        }
    </style>
    <script type="text/javascript" src="ckeditor/ckeditor.js"></script>
<script type="text/javascript">
    var blogContent;
    var Id = <%=Id%>;
    var jObject;

    $(document).ready(function () {
        CKEDITOR.replace("Text_Content", {
            customConfig: "config_blog.js",
            height: 300
        });

        $("#Dialog_Info").dialog({
            autoOpen: false,
            buttons: {
                "确定": function () {
                    $(this).dialog("close");
                }
            }
        });

        $("#Dialog_OperateWaitting").dialog({
            autoOpen: false,
            modal: true,
            width: 400,
            closeText: "hide"
        });

        $("#Text_Date").datepicker({
            dateFormat: "yy-mm-dd"
        });
    });

    function AddnewBlog() {
        if ($("#Text_Title").val() == "") {
            $("#Dialog_Info").ShowDialog("博客的标题没有填写。");
            return;
        }
        blogContent = CKEDITOR.instances.Text_Content.getData();
        if (blogContent == "") {
            $("#Dialog_Info").ShowDialog("博客内容为空。");
            return;
        }
        if (confirm("你确定要添加这条博客内容吗？") == false) return;
        $("#Dialog_OperateWaitting").dialog("open");
        $.post("Ajax/BlogOperate.aspx", {
            action: "ADDNEW", id: 0, title: $("#Text_Title").val(), tags: $("#Text_Tags").val(),
            date: $("#Text_Date").val(), content: blogContent
        }, function (data) {
            $("#Dialog_OperateWaitting").dialog("close");
            jObject = $.parseJSON(data);
            if (jObject.ResultCode == 0) {
                $("#Dialog_Info").ShowDialog("博客内容添加成功。");
            } else {
                $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
            }
        });
    }

    function UpdateBlog() {
        if ($("#Text_Title").val() == "") {
            $("#Dialog_Info").ShowDialog("博客的标题没有填写。");
            return;
        }
        blogContent = CKEDITOR.instances.Text_Content.getData();
        if (blogContent == "") {
            $("#Dialog_Info").ShowDialog("博客内容为空。");
            return;
        }
        if (confirm("你确定要更新这条博客内容吗？") == false) return;
        $("#Dialog_OperateWaitting").dialog("open");
        $.post("Ajax/BlogOperate.aspx", {
            action: "UPDATE", id: Id, title: $("#Text_Title").val(), tags: $("#Text_Tags").val(),
            date: $("#Text_Date").val(), content: blogContent
        }, function (data) {
            $("#Dialog_OperateWaitting").dialog("close");
            jObject = $.parseJSON(data);
            if (jObject.ResultCode == 0) {
                $("#Dialog_Info").ShowDialog("博客内容更新成功。");
            } else {
                $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
            }
        });
    }

    function DeleteBlog() {
        if (confirm("你确定要删除这条博客吗？") == false) return;
        $("#btn_update").addClass("disabled");
        $("#btn_delete").addClass("disibled");
        $.post("Ajax/BlogOperate.aspx", { action: "DELETE", id: Id }, function (data) {
            jObject = $.parseJSON(data);
            if (jObject.ResultCode == 0) {
                $("#Dialog_Info").ShowDialog("博客内容删除成功。");
            } else {
                $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                $("#btn_update").removeClass("disabled");
                $("#btn_delete").removeClass("disibled");
            }
        });
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" Runat="Server">
    <div class="MainContainer caption text-right" style="padding-right:30px;"> <a href="javascript:void(0);" onClick="window.history.back();" class="btn btn-primary">返回</a> </div>
<div class="container" style="width:800px;">
    <div class="form-group" id="Gp_Title">
    	<label for="Text_Title">博客标题</label>
        <input id="Text_Title" type="text" class="form-control" onBlur="$(this).CheckIsEmpty('Gp_Title');" value="<%=Title %>">
    </div>
    <div class="row">
    	<div class="col-md-6">
        	<div class="form-group">
            	<label for="Text_Tags">标签</label>
                <input id="Text_Tags" type="text" class="form-control" value="<%=Tags %>">
            </div>
        </div>
        <div class="col-md-6">
        	<div class="form-group">
            	<label for="Text_Date">发布日期</label>
                <input id="Text_Date" type="text" class="form-control" value="<%=PublishData %>">
            </div>
        </div>
    </div>
    <div class="form-group">
        <label for="Text_Content">博客内容</label>
        <textarea id="Text_Content" rows="5" class="form-control"><%=Content %></textarea>
    </div>
    <div class="form-group text-center">
        <%if (Id==0){ %>
    	<input id="btn_addnew" type="button" value="添加" class="btn btn-primary" onClick="AddnewBlog();">
        <%}else{ %>
        <input id="btn_update" type="button" value="更新" class="btn btn-success" onClick="UpdateBlog();">
        <input id="btn_delete" type="button" value="删除" class="btn btn-danger" onClick="DeleteBlog();">
        <%} %>
    </div>
</div>
<div id="Dialog_Info" title="信息"></div>
<div id="Dialog_OperateWaitting" title="数据传递中...">
	<div class="caption text-center" id="Dialog_UploadWaitting_Text">正在传递数据</div>
	<div class="progress progress-striped active">
      <div class="progress-bar"  role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
    </div>
</div>
</asp:Content>

