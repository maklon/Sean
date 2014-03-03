<%@ Page Title="照片列表" Language="C#" MasterPageFile="~/Manage/MasterPage.master" %>
<script runat="server">
    int AlbumId;
    
    protected void Page_Load(object Sender, EventArgs e) {
        if (Request.QueryString["id"] == null) {
            Response.Redirect("Error.aspx?err=" + Server.UrlEncode("缺少相册Id参数"), true);
        } else {
            AlbumId = Convert.ToInt32(Request.QueryString["id"]);
        }
        
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" runat="Server">
    <script type="text/javascript">
        var AlbumId = <%=AlbumId%>;
        var PhotoId = 0;

        function GetData(page) {
            $("#DataArea").html("<div class=\"progress progress-striped active\"><div class=\"progress-bar\"  role=\"progressbar\" aria-valuenow=\"10\" aria-valuemin=\"0\" aria-valuemax=\"10\" style=\"width: 100%\"></div></div>");
            $.post("Ajax/GetPhotoList.aspx", { page: page, aid: AlbumId }, function (data) {
                $("#DataArea").html(data);
            });
        }

        function ShowPhotoInfo(id) {
            PhotoId = id;
            $("#Text_PhotoName").val($("#Text_PhotoName_" + id).val());
            $("#Text_PhotoResume").val($("#Text_PhotoResume_" + id).val());
            $("#Select_PhotoStatus").val($("#Text_Status_" + id).val());
            $("#Dialog_PhotoInfo").dialog("open");
        }

        function UpdatePhotoInfo() {
            $("#btn_update").addClass("disabled");
            $.post("Ajax/PhotoOperate.aspx", {
                action: "UPDATE", id: PhotoId, name: $("#Text_PhotoName").val(),
                resume: $("#Text_PhotoResume").val(), status: $("#Select_PhotoStatus").val()
            }, function (data) {
                $("#btn_update").removeClass("disabled");
                var jObject = $.parseJSON(data);
                if (jObject.ResultCode == 0) {
                    $("#Dialog_PhotoInfo").dialog("close");
                    $("#Dialog_Info").ShowDialog("更新成功");
                } else {
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function DeletePhoto() {
            $("#btn_delete").addClass("disabled");
            $.post("Ajax/PhotoOperate.aspx", { action: "DELETE", id: PhotoId, }, function (data) {
                $("#btn_delete").removeClass("disabled");
                var jObject=$.parseJSON(data);
                if (jObject.ResultCode==0) {
                    $("#Dialog_PhotoInfo").dialog("close");
                    $("#Dialog_Info").ShowDialog("删除成功");
                } else {
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        function UpdateAlbumCover(){
            $("#btn_setcover").addClass("disabled");
            $.post("Ajax/PhotoOperate.aspx",{action:"COVER",aid:AlbumId,id:PhotoId},function(data){
                $("#btn_setcover").removeClass("disabled");
                var jObject=$.parseJSON(data);
                if (jObject.ResultCode==0){
                    $("#Dialog_Info").ShowDialog("相册封面设置成功。");
                }else{
                    $("#Dialog_Info").ShowDialog(jObject.ResultMessage);
                }
            });
        }

        $(document).ready(function () {
            $("#Dialog_PhotoInfo").dialog({
                autoOpen: false,
                Modal: true,
                width: 500,
                height: 350
            });

            $("#Dialog_Info").dialog({
                autoOpen: false,
                buttons: {
                    "确定": function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#Dialog_DeleteConfirm").dialog({
                autoOpen: false,
                Buttons: {
                    "取消": function () {
                        $(this).dialog("close");
                    },
                    "确定删除": function () {
                        DeletePhoto();
                    }
                }
            });

            GetData(1);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="MainContainer caption text-right" style="padding-right: 30px;">
        <a href="javascript:window.history.back();" class="btn btn-primary">返回</a>&nbsp;
    <a href="UploadPhotoFiles.aspx?id=<%=AlbumId %>" class="btn btn-primary">上传照片</a>
    </div>
    <div class="MainContainer" id="DataArea">
        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="10" aria-valuemin="0" aria-valuemax="10" style="width: 100%">
                <span class="sr-only">100% Complete</span>
            </div>
        </div>
    </div>
    <div id="Dialog_PhotoInfo" style="width: 500px;" title="相册信息">
        <form class="form-horizontal" role="form" id="AlbumFormArea">
            <div class="form-group" id="form-photoname">
                <label for="Text_PhotoName" class="col-md-3 control-label">*照片名称：</label>
                <div class="col-md-9">
                    <input id="Text_PhotoName" type="text" class="form-control" placeholder="照片的名称(最多30个汉字)" maxlength="30" onblur="$(this).CheckIsEmpty('form-photoname');" />
                </div>
            </div>
            <div class="form-group">
                <label for="Text_PhotoResume" class="col-md-3 control-label">照片描述：</label>
                <div class="col-md-9">
                    <textarea id="Text_PhotoResume" class="form-control" type="text" rows="5"></textarea></div>
            </div>
            <div class="form-group">
                <label for="Text_PhotoStatus" class="col-md-3 control-label">照片状态：</label>
                <div class="col-md-9">
                    <select id="Select_PhotoStatus" class="form-control">
                        <option value="10">显示</option>
                        <option value="9">隐藏</option>
                        <option value="0">尚未完成文件名简化</option>
                        <option value="5">尚未生成缩略图</option>
                    </select>
                </div>
            </div>
            <div class="form-group" style="text-align: center;">
                <input id="btn_update" type="button" value="更新" class="btn btn-info" onclick="UpdatePhotoInfo();">
                <input id="btn_setcover" type="button" value="设为封面" class="btn btn-success" onclick="UpdateAlbumCover();">
                <input id="btn_delete" type="button" value="删除" class="btn btn-danger" onclick="$('#Dialog_DeleteConfirm').dialog('open');">
                <input name="id" type="hidden" value="0">
            </div>
        </form>
        <div class="progress progress-striped active" id="WaittingArea" style="display: none;">
            <div id="ProgressValue" class="progress-bar" role="progressbar" aria-value="0" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
    </div>
    <div id="Dialog_Info" title="信息"></div>
    <div id="Dialog_DeleteConfirm" title="删除确认"></div>
</asp:Content>
