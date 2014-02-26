<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="gb2312" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["Android_DBConn"].ConnectionString);
    string FileStr, WidthStr, HeightStr, SizeStr, AlbumId;
    string[] FileList;
    string[] WidthList;
    string[] HeightList;
    string[] SizeList;
    StringBuilder SB;
    string SQL;
    SqlDataReader Sr;
    string FilePath, FileExt;
    
    protected void Page_Load(object sender, EventArgs e) {
        AlbumId = Request.Form["aid"];
        if (string.IsNullOrEmpty(AlbumId) || !General.IsMatch(AlbumId, "^\\d+$")) {
            Response.Write("未获取到相册Id。");
            Response.End();
        }
        FileStr = Request.Form["filelist"];
        if (string.IsNullOrEmpty(FileStr)) {
            Response.Write("未获取到成功上传的文件名信息。");
            Response.End();
        }
        WidthStr = Request.Form["widthlist"];
        if (string.IsNullOrEmpty(WidthStr)) {
            Response.Write("未获取到成功上传的文件尺寸信息。");
            Response.End();
        }
        HeightStr = Request.Form["heightlist"];
        if (string.IsNullOrEmpty(HeightStr)) {
            Response.Write("未获取到成功上传的文件尺寸信息。");
            Response.End();
        }
        SizeStr = Request.Form["sizelist"];
        if (string.IsNullOrEmpty(SizeStr)) {
            Response.Write("未获取到成功上传的文件大小信息。");
            Response.End();
        }
        FileStr = FileStr.Substring(1);
        WidthStr = WidthStr.Substring(1);
        HeightStr = HeightStr.Substring(1);
        SizeStr = SizeStr.Substring(1);

        FileList = FileStr.Split('|');
        WidthList = WidthStr.Split('|');
        HeightList = HeightStr.Split('|');
        SizeList = SizeStr.Split('|');
        
        try {
            SB = new StringBuilder();
            for (int i = 0; i < FileList.Length; i++) {
                SB.Append("INSERT INTO Sean_PhotoList (AlbumId,FileName,PhotoName,PhotoWidth,PhotoHeight,PhotoSize) VALUES("
                    + AlbumId + ",'" + FileList[i] + "','" + FileList[i] + "'," + WidthList[i] + "," + HeightList[i] + "," + SizeList[i] + ");");
            }
            SQL = SB.ToString();
            MZ.ExecuteSQL(SQL);

            //简化文件名
            SQL = "SELECT Id,AlbumId,FileName FROM Sean_PhotoList WHERE Status=0";
            Sr = MZ.GetReader(SQL);
            SB.Remove(0, SB.Length);
            while (Sr.Read()) {
                FilePath = Server.MapPath("../../") + "AlbumLib\\" + Sr.GetInt32(1) + "\\";
                FileExt = Sr.GetString(2).Substring(Sr.GetString(2).LastIndexOf("."));
                try {
                    System.IO.File.Move(FilePath + "\\" + Sr.GetString(2), FilePath + "\\" + Sr.GetInt32(0) + FileExt);
                    SB.Append("UPDATE Sean_PhotoList SET FileName='" + Sr.GetInt32(0) + FileExt
                        + "',Status=5 WHERE Id=" + Sr.GetInt32(0) + ";");
                } catch {
                    ;
                }
            }
            Sr.Close();
            MZ.ExecuteSQL(SB.ToString());
            Response.Write(0);
        } catch (Exception ex) {
            string ExMsg = ex.Message;
            DB.SQLFiltrate(ref ExMsg);
            DB.SQLFiltrate(ref SQL);
            Response.Write("照片信息保存失败。");
        }
    }

    protected void Page_UnLoad(object sender, EventArgs e) {
        MZ = null;
    }
</script>
