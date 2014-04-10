<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Page Language="C#" ValidateRequest="false" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL, Id, Action;
    string Title, Tags, PublishData, Content;
    string JsonResult;

    protected void Page_Load(object sender, EventArgs e) {
        Action = Request.Form["action"];
        Id = Request.Form["Id"];

        ResultInfo rInfo = new ResultInfo();

        if (string.IsNullOrEmpty(Id) || !General.IsMatch(Id, "^\\d+$")) {
            rInfo.ResultCode = 1;
            rInfo.ResultMessage = "参数Id错误";
            JsonResult = JsonConvert.SerializeObject(rInfo, Formatting.Indented);
            Response.Write(JsonResult);
            Response.End();
        }

        if (Action == "DELETE") {
            SQL = "DELETE FROM Sean_BlogList WHERE Id=" + Id;
            try {
                MZ.ExecuteSQL(SQL);
            } catch (Exception ex) {
                rInfo.ResultCode = 1;
                rInfo.ResultMessage = ex.Message;
            }
        } else {
            Title = Request.Form["title"];
            Content = Request.Form["content"];
            if (string.IsNullOrEmpty(Title) || string.IsNullOrEmpty(Content)) {
                rInfo.ResultCode = 1;
                rInfo.ResultMessage = "博客标题或内容为空。";
                JsonResult = JsonConvert.SerializeObject(rInfo, Formatting.Indented);
                Response.Write(JsonResult);
                Response.End();
            }
            Tags = Request.Form["tags"];
            PublishData = Request.Form["date"];
            if (string.IsNullOrEmpty(PublishData)) PublishData = DateTime.Today.ToShortDateString();
            DB.SQLFiltrate(ref Title);
            DB.SQLFiltrate(ref Content);
            DB.SQLFiltrate(ref Tags);
            DB.SQLFiltrate(ref PublishData);
            SQL = "";
            if (Action == "ADDNEW") {
                SQL = "INSERT INTO Sean_BlogList (Title,Content,Tags,AddTime) VALUES('"
                    + Title + "','" + Content + "','" + Tags + "','" + PublishData + "')";

            } else if (Action == "UPDATE") {
                SQL = "UPDATE Sean_BlogList SET Title='" + Title + "',Content='" + Content
                    + "',Tags='" + Tags + "',AddTime='" + PublishData + "' WHERE Id=" + Id;
            }
            if (SQL == string.Empty) {
                rInfo.ResultCode = 1;
                rInfo.ResultMessage = "不能识别的命令。";
            } else {
                try {
                    MZ.ExecuteSQL(SQL);
                } catch (Exception ex) {
                    rInfo.ResultCode = 1;
                    rInfo.ResultMessage = ex.Message;
                }
            }
        }
        JsonResult = JsonConvert.SerializeObject(rInfo, Formatting.Indented);
        Response.Write(JsonResult);
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

    public class ResultInfo {
        public int ResultCode;
        public string ResultMessage;

        public ResultInfo() {
            ResultCode = 0;
            ResultMessage = "";
        }

        public ResultInfo(int resultCode, string resultMessage) {
            this.ResultCode = resultCode;
            this.ResultMessage = resultMessage;
        }
    }

</script>
