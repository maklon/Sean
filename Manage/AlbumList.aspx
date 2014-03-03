<%@ Page Title="相册列表" Language="C#" MasterPageFile="~/Manage/MasterPage.master" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" Runat="Server">
    <script type="text/javascript">
        var PageId = 1;
        function GetData(page) {
            PageId = page;
            $("#DataArea").html("<div class=\"progress progress-striped active\"><div class=\"progress-bar\"  role=\"progressbar\" aria-valuenow=\"10\" aria-valuemin=\"0\" aria-valuemax=\"10\" style=\"width: 100%\"></div></div>");
            $.post("Ajax/GetAlbumList.aspx", { page: page }, function (data) {
                $("#DataArea").html(data);
            });
        }

        function ShowAddNewAlbum() {
            SetFormToDefault("AddNew");
            $("#Dialog_AlbumInfo").dialog("open");
        }

        function GetAlbumInfo(id) {
            SetFormToDefault("Update");
            $("#btn_update").addClass("disabled");
            $("#btn_delete").addClass("disabled");
            $("#Dialog_AlbumInfo").dialog("open");
            $.post("Ajax/AlbumOperate.aspx", { action: "GET", id: id }, function (data) {
                var jObject = $.parseJSON(data);
                if (jObject.ResultCode == 0) {
                    $("#id").val(id);
                    $("#Text_AlbumName").val(jObject.AlbumName);
                    $("#Text_AlbumOrderId").val(jObject.OrderId);
                    $("#Text_AlbumResume").val(jObject.AlbumResume);
                    $.each(jObject.PhotoList, function (i, obj) {
                        $("#Select_AlbumCoverId").AddOption(obj.FileName, obj.Id);
                    });
                    $("#Select_AlbumCoverId").val(jObject.AlbumPicId);
                    $("#Select_AlbumStatus").val(jObject.Status);
                    $("#btn_update").removeClass("disabled");
                    $("#btn_delete").removeClass("disabled");
                } else {
                    $("#Dialog_AlbumInfo").dialog("close");
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function AddnewAlbumInfo() {
            if ($("#Text_AlbumName").val() == "") {
                return;
            }
            $("#btn_addnew").addClass("disabled");
            $.post("Ajax/AlbumOperate.aspx", {
                action: "ADDNEW", id: 0, albumname: $("#Text_AlbumName").val(),
                albumresume: $("#Text_AlbumResume").val(), orderid: $("#Text_AlbumOrderId").val()
            }, function (data) {
                var jObject = $.parseJSON(data);
                $("#btn_addnew").removeClass("disabled");
                if (jObject.ResultCode == 0) {
                    $("#Dialog_Info").ShowDialog("相册添加成功。");
                } else {
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function UpdateAlbumInfo() {
            if ($("#Text_AlbumName").val() == "") {
                return;
            }
            $("#btn_update").addClass("disabled");
            $("#btn_delete").addClass("disabled");
            $.post("Ajax/AlbumOperate.aspx", {
                action: "UPDATE", id: $("#id").val(), albumname: $("#Text_AlbumName").val(),
                coverid: $("#Select_AlbumCoverId").val(), status: $("#Select_AlbumStatus").val(),
                albumresume: $("#Text_AlbumResume").val(), orderid: $("#Text_AlbumOrderId").val()
            }, function (data) {
                $("#btn_update").removeClass("disabled");
                $("#btn_delete").removeClass("disabled");
                var jObject = $.parseJSON(data);
                if (jObject.ResultCode == 0) {
                    $("#Dialog_AlbumInfo").dialog("close");
                    $("#Dialog_Info").ShowDialog("相册更新成功。");
                } else {
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function DeleteAlbum() {
            $("#btn_update").addClass("disabled");
            $("#btn_delete").addClass("disabled");
            $.post("Ajax/AlbumOperate.aspx", { action: "DELETE", id: $("#id").val() }, function (data) {
                $("#btn_update").removeClass("disabled");
                $("#btn_delete").removeClass("disabled");
                var jObject = $.parseJSON(data);
                if (jObject.ResultCode == 0) {
                    $("#Dialog_AlbumInfo").dialog("close");
                    $("#Dialog_Info").ShowDialog("相册已成功删除。");
                } else {
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function SetFormToDefault(who) {
            $("#Text_AlbumName").val("");
            $("#Text_AlbumOrderId").val("");
            $("#Text_AlbumResume").val("");
            $("#Select_AlbumCoverId").empty();
            $("#Select_AlbumCoverId").AddOption("默认封面", 0);
            $("#Select_AlbumCoverId").val(0);
            $("#Select_AlbumStatus").val(1);
            $("input[id^=btn_]").hide();
            if (who == "AddNew") {
                $("#btn_addnew").show();
            } else if (who == "Update") {
                $("#btn_update").show();
                $("#btn_delete").show();
            }
        }

        $(document).ready(function () {
            $("#Dialog_AlbumInfo").dialog({
                autoOpen: false,
                Modal: true,
                width: 500,
                height: 400
            });

            $("#Dialog_Info").dialog({
                autoOpen: false,
                buttons: {
                    "确定": function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#Dialog_Confirm").dialog({
                autoOpen: false,
                Buttons: {
                    "取消": function () {
                        $(this).dialog("close");
                    },
                    "确定删除": function () {
                        DeleteAlbum();
                    }
                }
            });

            GetData(1);
        });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" Runat="Server">
    <div class="MainContainer caption text-right" style="padding-right:30px;">
        <input type="button" value="刷新" class="btn btn-success" onClick="GetData(PageId);">&nbsp;
        <input name="" type="button" value="添加新相册" class="btn btn-primary" onClick="ShowAddNewAlbum();">
    </div>
<div class="MainContainer" id="DataArea"></div>
<div id="Dialog_AlbumInfo" style="width:500px;" title="相册信息">
	<form  class="form-horizontal" role="form" id="AlbumFormArea">
	<div class="form-group" id="form-albumname">
    	<label for="Text_AlbumName" class="col-md-3 control-label">*相册名称：</label>
        <div class="col-md-9"><input id="Text_AlbumName" type="text" class="form-control" placeholder="相册的名称(最多10个汉字)" maxlength="10" onBlur="$(this).CheckIsEmpty('form-albumname');" /></div>
    </div>
    <div class="form-group">
    	<label for="Select_AlbumCoverId" class="col-md-3 control-label">相册封面：</label>
        <div class="col-md-9">
            <select id="Select_AlbumCoverId" class="form-control">
            	<option value="1">默认封面</option>
            </select>
        </div>
    </div>
    <div class="form-group">
    	<label for="Text_AlbumResume" class="col-md-3 control-label">相册概要：</label>
        <div class="col-md-9">
            <textarea id="Text_AlbumResume" class="form-control" type="text" rows="3"></textarea>
        </div>
    </div>
    <div class="form-group">
    	<label for="Select_AlbumStatus" class="col-md-3 control-label">相册状态：</label>
        <div class="col-md-9">
        	<select id="Select_AlbumStatus" class="form-control">
            	<option value="1">显示</option>
                <option value="0">隐藏</option>
            </select>
        </div>
    </div>
    <div class="form-group">
    	<label for="Text_AlbumOrderId" class="col-md-3 control-label">排序因子：</label>
        <div class="col-md-9"><input id="Text_AlbumOrderId" type="text" class="form-control" placeholder="数字，最大，排序越靠前" maxlength="10" /></div>
    </div>
    <div class="form-group" style="text-align:center;">
    	<input id="btn_addnew" type="button" value="添加" class="btn btn-primary" onClick="AddnewAlbumInfo();">
        <input id="btn_update" type="button" value="编辑" class="btn btn-info" onClick="UpdateAlbumInfo();">
        <input id="btn_delete" type="button" value="删除" class="btn btn-danger">
        <input id="id" type="hidden" value="0">
    </div>
    </form>
</div>
<div id="Dialog_Info" title="信息"></div>
<div id="Dialog_Confirm" title="操作确认"></div>
</asp:Content>

