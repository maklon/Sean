<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Page Language="C#" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL, Id, PhotoName, PhotoResume, Action, Status, AlbumId;
    string JsonResult;

    protected void Page_Load(object sender, EventArgs e) {
        Action = Request.Form["action"];
        Id = Request.Form["id"];

        PhotoInfo pInfo = new PhotoInfo();
        pInfo.ResultCode = 0;
        pInfo.ResultMessage = "";

        if (string.IsNullOrEmpty(Id) || !General.IsMatch(Id, "^\\d+$")) {
            pInfo.ResultCode = 1;
            pInfo.ResultMessage = "参数Id错误";
            JsonResult = JsonConvert.SerializeObject(pInfo, Formatting.Indented);
            Response.Write(JsonResult);
            Response.End();
        }

        if (Action == "DELETE") {
            SQL = "DELETE FROM Sean_PhotoList WHERE Id=" + Id;
            try {
                MZ.ExecuteSQL(SQL);
            } catch (Exception ex) {
                pInfo.ResultCode = 1;
                pInfo.ResultMessage = ex.Message;
            }
        }else if (Action=="COVER"){
            AlbumId = Request.Form["aid"];
            if (string.IsNullOrEmpty(AlbumId) || !General.IsMatch(AlbumId, "^\\d+$")) {
                pInfo.ResultCode = 1;
                pInfo.ResultMessage = "未能获取到相册Id。";
            } else {
                SQL = "UPDATE Sean_AlbumList SET AlbumCoverId=" + Id + " WHERE Id=" + AlbumId;
                try {
                    MZ.ExecuteSQL(SQL);
                } catch (Exception ex) {
                    pInfo.ResultCode = 1;
                    pInfo.ResultMessage = ex.Message;
                }
            }
        } else if (Action=="UPDATE"){
            PhotoName = Request.Form["name"];
            PhotoResume = Request.Form["resume"];
            Status = Request.Form["status"];
            DB.SQLFiltrate(ref PhotoName);
            DB.SQLFiltrate(ref PhotoResume);
            if (string.IsNullOrEmpty(Status) || !General.IsMatch(Status, "^\\d{1,2}$")) Status = "0";
            SQL = "UPDATE Sean_PhotoList SET PhotoName='" + PhotoName + "',PhotoResume='" + PhotoResume + "',Status=" + Status
                + " WHERE Id=" + Id;
            try {
                MZ.ExecuteSQL(SQL);
            }
            catch (Exception ex) {
                pInfo.ResultCode = 1;
                pInfo.ResultMessage = ex.Message;
            }
        } 
        JsonResult = JsonConvert.SerializeObject(pInfo, Formatting.Indented);
        Response.Write(JsonResult);
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

    public class PhotoInfo
    {
        public int Id;
        public int Status;
        public string PhotoName;
        public string PhotoResume;
        public int ResultCode;
        public string ResultMessage;
    }

</script>
