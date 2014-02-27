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
    string SQL;
    int PageId, TotalDataCount, TotalPageCount, StartId, EndId, StartPageId, EndPageId;
    int PageSize = 8;
    int PageSpan = 4;

    protected void Page_Load(object sender, EventArgs e) {
        if (Request["page"]!=null){
            PageId=Convert.ToInt32(Request["page"]);
        }else{
            PageId=1;
        }

        SQL = "SELECT TOP " + (PageId * PageSize) + " * FROM Sean_AlbumList ORDER BY Id DESC";
        MZ.CreateDataTable(SQL, "PL");
        Dt = MZ.Tables["PL"];
        StartId = (PageId - 1) * PageSize;
        EndId = PageId * PageSize;
        SQL = "SELECT COUNT(*) FROM Sean_AlbumList";
        Sr = MZ.GetReader(SQL);
        if (Sr.Read()) {
            TotalDataCount = Sr.GetInt32(0);
            TotalPageCount = (TotalDataCount - 1) / PageSize + 1;
            Sr.Close();
            StartPageId = PageId - PageSpan;
            EndPageId = PageId + PageSpan;
            if (StartPageId < 1) StartPageId = 1;
            if (EndPageId > TotalPageCount) EndPageId = TotalPageCount;
        } else {
            Sr.Close();
            TotalDataCount = 0;
            TotalPageCount = 1;
            StartPageId = 1;
            EndPageId = 1;
        }
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
        Dt = null;
    }

</script>
<%for (int i=StartId;i<EndId && i<Dt.Rows.Count;i++){ %>
<div class="AlbumBoard">
    <a href="PhotoList.aspx?id=<%=Dt.Rows[i][0] %>"><img src="../AlbumLib/<%=Dt.Rows[i][0]+"/Thumbnail_"+Dt.Rows[i][2]+".jpg" %>" width="278" height="182"></a>
    <div class="row AlbumTitle">
        <div class="col-md-9"><%=Dt.Rows[i]["AlbumName"] %></div>
        <div class="col-md-3"><input type="button" value="编辑" class="btn btn-default" onClick="GetAlbumInfo(<%=Dt.Rows[i][0]%>);"></div>
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