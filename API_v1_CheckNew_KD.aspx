<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Page Language="C#" %>
<script runat="server">
    string JsonResult;
    int VersionCode;
    int NewVersionCode = 10;
    string NewVersion = "1.3.3";
    string NewUrl = "http://180.96.63.68/KindomDefend_v1.3.3.apk";
    string NewResume = "";
    
    protected void Page_Load(object Sender, EventArgs e) {
        if (Request.QueryString["ver"] != null) {
            VersionCode = Convert.ToInt32(Request.QueryString["ver"]);
        } else {
            VersionCode = 0;
        }
        VersionInfo versionInfo = new VersionInfo();
        if (VersionCode < NewVersionCode) {
            versionInfo.HasNewVersion = true;
            versionInfo.NewVersionDownloadUrl = NewUrl;
            versionInfo.NewVersionResume = NewResume;
        } else {
            versionInfo.HasNewVersion = false;
            versionInfo.NewVersionDownloadUrl = "";
            versionInfo.NewVersionResume = "";
        }
        JsonResult = JsonConvert.SerializeObject(versionInfo, Formatting.Indented);
        Response.Write(JsonResult);
    }

    protected void Page_Unload(object Sender, EventArgs e) {
        
    }

    public class VersionInfo {
        public bool HasNewVersion;
        public string NewVersionDownloadUrl;
        public string NewVersionResume;
    }

</script>
