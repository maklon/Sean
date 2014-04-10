<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Page Title="上传照片" Language="C#" MasterPageFile="~/Manage/MasterPage.master" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    int AlbumId, PhotoCount;
    string AlbumName, SQL;
    SqlDataReader Sr;

    protected void Page_Load(object Sender, EventArgs e) {
        if (Request.QueryString["id"] == null) {
            Response.Redirect("Error.aspx?err=" + Server.UrlEncode("缺少相册Id参数"), true);
        } else {
            AlbumId = Convert.ToInt32(Request.QueryString["id"]);
        }
        SQL = "SELECT AlbumName FROM Sean_AlbumList WHERE Id=" + AlbumId
            + ";SELECT COUNT(*) FROM Sean_PhotoList WHERE AlbumId=" + AlbumId;
        Sr = MZ.GetReader(SQL);
        if (Sr.Read()) {
            AlbumName = Sr.GetString(0);
        } else {
            Sr.Close();
            Response.Redirect("Error.aspx?err=" + Server.UrlEncode("未能获取到该Id的相册信息"), true);
        }
        Sr.NextResult();
        if (Sr.Read()) {
            PhotoCount = Sr.GetInt32(0);
        } else {
            PhotoCount = 0;
        }
        Sr.Close();
    }

    protected void Page_Unload(object Sender, EventArgs e) {
        MZ = null;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" runat="Server">
    <style type="text/css">
        #UploadFileArea {
            width: 100%;
            height: 400px;
            overflow-y: scroll;
        }
    </style>
    <script type="text/javascript" src="Scripts/jquery.uploadify.min.js"></script>
    <script type="text/javascript">
        var AlbumId = 1;

        function GetData(page) {
            $("#DataArea").html("<div class=\"progress progress-striped active\"><div class=\"progress-bar\"  role=\"progressbar\" aria-valuenow=\"10\" aria-valuemin=\"0\" aria-valuemax=\"10\" style=\"width: 100%\"></div></div>");
        }

        $(document).ready(function () {
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
                buttons: {
                    "取消": function () {
                        $(this).dialog("close");
                    },
                    "确定上传": function () {
                        $(this).dialog("close");
                        $("#Dialog_UploadWaitting_Text").html("正在上传照片，请稍候...");
                        $("#Dialog_UploadWaitting").dialog("open");
                        $("#UploadFiles_Browser").uploadify("settings", "formData", { aid: AlbumId });
                        $("#UploadFiles_Browser").uploadify("upload", "*");
                    }
                }
            });

            $("#Dialog_UploadWaitting").dialog({
                autoOpen: false,
                modal: true,
                width: 400,
                closeText: "hide"
            });

            $("#UploadFiles_Browser").uploadify({
                "swf": "Images/uploadify.swf",
                "uploader": "UploadPhotoFiles_Server.aspx",
                "buttonText": "浏览",
                "fileTypeDesc": "照片文件",
                "fileTypeExts": "*.jpg;*.png",
                "auto": false,
                "onUploadSuccess": function (file, data, response) {
                    if (data.indexOf('|') == -1) {
                        alert(data);
                        return;
                    }
                    var ValueList = new Array();
                    ValueList = data.split('|');
                    $("#namelist").val($("#namelist").val() + "|" + file.name);
                    $("#filelist").val($("#filelist").val() + "|" + ValueList[0]);
                    $("#widthlist").val($("#widthlist").val() + "|" + ValueList[1]);
                    $("#heightlist").val($("#heightlist").val() + "|" + ValueList[2]);
                    $("#sizelist").val($("#sizelist").val() + "|" + ValueList[3]);
                },
                "onUploadError": function (file, errorCode, errorMsg, errorString) {
                    alert("Error");
                },
                "onDialogClose": function () {
                    $("#btn_upload").show();
                    $("#btn_cancelupload").show();
                },
                "onQueueComplete": function () {
                    $("#Dialog_UploadWaitting_Text").html("照片上传成功，正在保存信息...");
                    $.post("Ajax/SavePhotoFiles.aspx", {
                        aid: AlbumId, filelist: $("#filelist").val(), namelist: $("#namelist").val(),
                        widthlist: $("#widthlist").val(), heightlist: $("#heightlist").val(),
                        sizelist: $("#sizelist").val()
                    }, function (data) {
                        if (data == "0") {
                            $("#Dialog_UploadWaitting_Text").html("信息保存成功，正在生成缩略图...");
                            $.get("Ajax/CreatePhotoThumbnail.aspx", function (data) {
                                if (data == "0") {
                                    $("#Dialog_UploadWaitting").dialog("close");
                                    $("#Dialog_Info").ShowDialog("全部照片上传并保存成功。");
                                } else {
                                    $("#Dialog_UploadWaitting").dialog("close");
                                    $("#Dialog_Info").ShowDialog(data);
                                }
                            });
                        } else {
                            $("#Dialog_UploadWaitting").dialog("close");
                            $("#Dialog_Info").ShowDialog(data);
                        }
                    });
                }
            });
        });

        function CancelUploadQueue() {
            $("#UploadFiles_Browser").uploadify("cancel", "*");
            $("#btn_upload").hide();
            $("#btn_cancelupload").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="container" id="DataArea">
        <div class="row">
            <div class="col-md-4">
                <h3>相册Id:<%=AlbumId %></h3>
                <h3>相册名称:<%=AlbumName %></h3>
                <h3>照片数量:<%=PhotoCount %></h3>
            </div>
            <div class="col-md-8">
                <div id="UploadFileArea">
                    <div id="UploadFiles_Browser"></div>
                </div>
                <div class="caption text-center">
                    <input id="btn_upload" type="button" value="开始上传" class="btn btn-primary" onclick="$('#Dialog_Confirm').dialog('open');" style="display: none;">&nbsp;<input id="btn_cancelupload" type="button" value="取消上传列队" class="btn btn-danger" onclick="CancelUploadQueue();" style="display: none;">
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" name="filelist" id="filelist" />
    <input type="hidden" name="namelist" id="namelist" />
    <input type="hidden" name="widthlist" id="widthlist" />
    <input type="hidden" name="heightlist" id="heightlist" />
    <input type="hidden" name="sizelist" id="sizelist" />

    <div id="Dialog_Info" title="信息"></div>
    <div id="Dialog_Confirm" title="操作确认">
        <p>你确定要上传这些照片吗？</p>
    </div>
    <div id="Dialog_UploadWaitting" title="上传照片...">
        <div class="caption text-center" id="Dialog_UploadWaitting_Text">照片上传中</div>
        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
        </div>
    </div>
</asp:Content>

