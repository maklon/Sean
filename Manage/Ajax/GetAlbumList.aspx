<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Page Language="C#" %>
<script runat="server">
    DS MZ = new DS(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL;
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

        SQL = "SELECT TOP " + (PageId * PageSize) + " * FROM Sean_PhotoList WHERE AlbumId=" + AlbumId + " ORDER BY Id DESC";
        MZ.CreateDataTable(SQL, "PL");
        
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

</script>
