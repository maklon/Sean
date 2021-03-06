﻿<%@ Import Namespace="MaklonZjing.MSSQL" %>
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
    int PageId, AlbumId, TotalDataCount, TotalPageCount, StartId, EndId, StartPageId, EndPageId;
    int PageSize = 12;
    int PageSpan = 4;

    protected void Page_Load(object sender, EventArgs e) {
        if (Request["page"] != null) {
            PageId = Convert.ToInt32(Request["page"]);
        }
        else {
            PageId = 1;
        }
        if (Request["aid"] != null) {
            AlbumId = Convert.ToInt32(Request["aid"]);
        }
        else {
            AlbumId = 0;
        }

        SQL = "SELECT TOP " + (PageId * PageSize) + " * FROM Sean_PhotoList WHERE AlbumId=" + AlbumId + " ORDER BY Id DESC";
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
            StartPageId = PageId - PageSpan;
            EndPageId = PageId + PageSpan;
            if (StartPageId < 1) StartPageId = 1;
            if (EndPageId > TotalPageCount) EndPageId = TotalPageCount;
        }
        else {
            Sr.Close();
            TotalDataCount = 0;
            TotalPageCount = 1;
            StartPageId = 1;
            EndPageId = 1;
        }
        PhotoPath = "../AlbumLib/" + AlbumId + "/";
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
        Dt = null;
    }

</script>
<%for (int i = StartId; i < EndId && i < Dt.Rows.Count; i++) { %>
<div class="PhotoBoard thumbnail">
    <a href="#">
        <img src="../AlbumLib/<%=AlbumId+"/Thumbnail_"+Dt.Rows[i]["FileName"] %>"></a>
    <div class="caption">
        <label class="text-info"><%=Dt.Rows[i]["PhotoName"] %></label>
        <input id="Text_PhotoResume_<%=Dt.Rows[i][0]%>" type="hidden" value="<%=Dt.Rows[i]["PhotoResume"] %>"><input id="Text_PhotoName_<%=Dt.Rows[i][0]%>" type="hidden" value="<%=Dt.Rows[i]["PhotoName"] %>">
        <input id="Text_Status_<%=Dt.Rows[i][0]%>" type="hidden" value="<%=Dt.Rows[i]["Status"] %>">
        <input type="button" value="编辑" class="btn btn-default" style="float: right;" onclick="ShowPhotoInfo(<%=Dt.Rows[i][0]%>);">
    </div>
</div>
<%} %>
<div class="MainContainer" style="text-align:center;">
	<ul class="pagination">
    	<li<%if (PageId == 1) { Response.Write(" class=\"disabled\""); } %>><a href="javascript:void(0);" onclick="GetData(1);">&laquo;</a></li>
        <%for (int i=StartPageId;i<=EndPageId;i++){ %>
        <li<%if (i == PageId) { Response.Write(" class=\"active\""); } %>><a href="javascript:void(0);" onclick="GetData(<%=i %>);"><%=i %></a></li>
        <%} %>
        <li<%if (PageId == TotalPageCount) { Response.Write(" class=\"disabled\""); } %>><a href="javascript:void(0);" onclick="GetData(<%=TotalPageCount %>);">&raquo;</a></li>
    </ul>
</div>