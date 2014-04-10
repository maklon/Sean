<%@ Page Title="博客列表" Language="C#" MasterPageFile="~/Manage/MasterPage.master" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" runat="Server">
    <script type="text/javascript">
        function GetData(page) {
            $("#Dialog_OperateWaitting").dialog("open");
            $.get("Ajax/GetBlogList.aspx", { page: page }, function (data) {
                $("#Dialog_OperateWaitting").dialog("close");
                $("#DataArea").html(data);
            });
        }

        $(document).ready(function () {
            $("#Dialog_OperateWaitting").dialog({
                autoOpen: false,
                modal: true,
                width: 400,
                closeText: "hide"
            });

            GetData(1);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="MainContainer caption text-right" style="padding-right: 30px;"><a href="AddnewBlog.aspx" class="btn btn-primary">添加新博客</a> </div>
    <div class="container" id="DataArea"></div>
    <div id="Dialog_OperateWaitting" title="数据传递中...">
        <div class="caption text-center" id="Dialog_UploadWaitting_Text">正在传递数据</div>
        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
        </div>
    </div>
</asp:Content>

