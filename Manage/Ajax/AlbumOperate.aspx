﻿<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>

<%@ Page Language="C#" %>

<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL, Id, AlbumName, AlbumCoverId, Status, OrderId, Action, AlbumResume;
    string JsonResult;

    protected void Page_Load(object sender, EventArgs e) {
        Action = Request.Form["action"];
        Id = Request.Form["Id"];

        AlbumInfo aInfo = new AlbumInfo();
        aInfo.ResultCode = 0;
        aInfo.ResultMessage = "";

        if (string.IsNullOrEmpty(Id) || !General.IsMatch(Id, "^\\d+$")) {
            aInfo.ResultCode = 1;
            aInfo.ResultMessage = "参数Id错误";
            JsonResult = JsonConvert.SerializeObject(aInfo, Formatting.Indented);
            Response.Write(JsonResult);
            Response.End();
        }

        if (Action == "GET") {
            SQL = "SELECT * FROM Sean_AlbumList WHERE Id=" + Id
                + ";SELECT Id,PhotoName FROM Sean_PhotoList WHERE AlbumId=" + Id;
            Sr = MZ.GetReader(SQL);
            if (Sr.Read()) {
                aInfo.Id = Sr.GetInt32(0);
                aInfo.AlbumName = Sr.GetString(1);
                aInfo.AlbumPicId = Sr.GetInt32(2);
                aInfo.AlbumResume = Sr.GetString(3);
                aInfo.Status = Sr.GetInt32(4);
                aInfo.OrderId = Sr.GetInt32(5);
                Sr.NextResult();
                while (Sr.Read()) {
                    aInfo.PhotoList.Add(new SimplePhoto(Sr.GetInt32(0), Sr.GetString(1)));
                }
                Sr.Close();
            } else {
                Sr.Close();
                aInfo.ResultCode = 1;
                aInfo.ResultMessage = "没有满足条件的数据";
            }
        } else if (Action == "DELETE") {
            SQL = "DELETE FROM Sean_AlbumList WHERE Id=" + Id
                + ";DELETE FROM Sean_PhotoList WHERE AlbumId=" + Id;
            try {
                MZ.ExecuteSQL(SQL);
            } catch (Exception ex) {
                aInfo.ResultCode = 1;
                aInfo.ResultMessage = ex.Message;
            }
        } else {
            AlbumName = Request.Form["albumname"];
            AlbumCoverId = Request.Form["coverid"];
            AlbumResume = Request.Form["albumresume"];
            Status = Request.Form["status"];
            OrderId = Request.Form["orderid"];
            if (string.IsNullOrEmpty(AlbumName)) {
                aInfo.ResultCode = 1;
                aInfo.ResultMessage = "相册";
                JsonResult = JsonConvert.SerializeObject(aInfo, Formatting.Indented);
                Response.Write(JsonResult);
                Response.End();
            }
            DB.SQLFiltrate(ref AlbumName);
            DB.SQLFiltrate(ref AlbumResume);
            if (string.IsNullOrEmpty(AlbumCoverId) || !General.IsMatch(AlbumCoverId, "^\\d+$")) AlbumCoverId = "0";
            if (string.IsNullOrEmpty(Status) || !General.IsMatch(Status, "^[0-1]$")) Status = "0";
            if (string.IsNullOrEmpty(OrderId) || !General.IsMatch(OrderId, "^\\d+$")) OrderId = "0";
            SQL = "";
            if (Action == "ADDNEW") {
                SQL = "INSERT INTO Sean_AlbumList (AlbumName,AlbumResume,OrderId) VALUES('"
                    + AlbumName + "','" + AlbumResume + "'," + OrderId + ")";

            } else if (Action == "UPDATE") {
                SQL = "UPDATE Sean_AlbumList SET AlbumName='" + AlbumName + "',AlbumCoverId=" + AlbumCoverId
                    + ",AlbumResume='" + AlbumResume + "',Status=" + Status + ",OrderId=" + OrderId + " WHERE Id=" + Id;
            }
            if (SQL == string.Empty) {
                aInfo.ResultCode = 1;
                aInfo.ResultMessage = "不能识别的命令。";
            } else {
                try {
                    MZ.ExecuteSQL(SQL);
                } catch (Exception ex) {
                    aInfo.ResultCode = 1;
                    aInfo.ResultMessage = ex.Message;
                }
            }
        }
        JsonResult = JsonConvert.SerializeObject(aInfo, Formatting.Indented);
        Response.Write(JsonResult);
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

    public class AlbumInfo {
        public int Id;
        public string AlbumName;
        public int AlbumPicId;
        public string AlbumResume;
        public int Status;
        public int OrderId;
        public List<SimplePhoto> PhotoList;
        public int ResultCode;
        public string ResultMessage;

        public AlbumInfo() {
            PhotoList = new List<SimplePhoto>();
        }
    }

    public class SimplePhoto {
        public int Id;
        public string FileName;

        public SimplePhoto(int id, string fileName) {
            this.Id = id;
            this.FileName = fileName;
        }

    }

</script>
