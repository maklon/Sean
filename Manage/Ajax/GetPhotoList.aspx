<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Page Language="C#" %>
<script runat="server">
    DS MZ = new DS(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    DataTable Dt;
    string SQL, PhotoPath;
    int PageId,AlbumId, TotalDataCount, TotalPageCount, StartId, EndId;
    int PageSize = 8;

    protected void Page_Load(object sender, EventArgs e) {
        if (Request["page"]!=null){
            PageId=Convert.ToInt32(Request["page"]);
        }else{
            PageId=1;
        }
        if (Request["aid"]!=null){
            AlbumId=Convert.ToInt32(Request["aid"]);
        }else{
            AlbumId=0;
        }

        SQL = "SELECT TOP " + (PageId * PageSize) + " Sean_AlbumList.*,Sean_PhotoList.ThumbnailName FROM Sean_AlbumList INNER JOIN Sean_PhotoList "
            +" ON Sean_AlbumList.AlubmCoverId=Sean_PhotoList.Id WHERE Sean_AlbumList.Id=" + AlbumId + " ORDER BY Id DESC";
        MZ.CreateDataTable(SQL, "PL");
        Dt = MZ.Tables["PL"];
        StartId = (PageId - 1) * PageSize;
        EndId = PageId * PageSize;
        SQL = "SELECT COUNT(*) FROM Sean_PhotoList WHERE AlbumId=" + AlbumId;
        Sr = MZ.GetReader(SQL);
        if (Sr.Read()) {
            TotalDataCount = Sr.GetInt32(0);
            TotalPageCount = (TotalDataCount - 1) / PageSize + 1;
            Sr.Close();
        } else {
            Sr.Close();
            TotalDataCount = 0;
            TotalPageCount = 1;
        }
        PhotoPath = "../AlbumLib/" + AlbumId + "/";
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
        Dt = null;
    }

</script>
<%for (int i=StartId;i<EndId && i<Dt.Rows.Count;i++){ %>
<div class="PhotoBoard thumbnail">
    <a href="<%=PhotoPath+Dt.Rows[i]["FileName"] %>"><img src="<%=PhotoPath+Dt.Rows[i]["ThumbnailName"] %>" width="202" height="138"></a>
    <div class="caption text-right">
        <input id="Text_PhotoResume_<%=Dt.Rows[i][0] %>" type="hidden" value="<%=Dt.Rows[i]["PhotoResume"] %>">
        <input id="Text_PhotoName_<%=Dt.Rows[i][0] %>" type="hidden" value="<%=Dt.Rows[i]["PhotoName"] %>">
        <input type="button" value="编辑" class="btn btn-default" onClick="ShowPhotoInfo(<%=Dt.Rows[i][0]%>);">
    </div>
</div>
<%} %>