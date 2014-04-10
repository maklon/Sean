<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Page Language="C#" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    string SQL;
    SqlDataReader Sr;
    string JsonResult;
    int VersionCode;
    List<PushInfo> PushInfoList = new List<PushInfo>();

    protected void Page_Load(object Sender, EventArgs e) {
        if (Request.QueryString["ver"] != null) {
            VersionCode = Convert.ToInt32(Request.QueryString["ver"]);
        } else {
            VersionCode = 0;
        }
        if (Request.QueryString["imsi"] == null) {
            Response.End();
        }
        SQL="SELECT "
        PushInfoList.Add(new PushInfo("标题1", "内容1"));
        PushInfoList.Add(new PushInfo("标题2", "内容2"));
        JsonResult = JsonConvert.SerializeObject(PushInfoList, Formatting.Indented);
        Response.Write(JsonResult);
    }

    protected void Page_Unload(object Sender, EventArgs e) {

    }

    public class PushInfo {
        public string Title;
        public string Content;

        public PushInfo(string title, string content) {
            this.Title = title;
            this.Content = content;
        }
    }

</script>
