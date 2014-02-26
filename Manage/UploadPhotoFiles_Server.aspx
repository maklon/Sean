<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="utf-8" %>
<script runat="server">
    string RndName, UploadName, UploadDir, WebDir;
    int AlbumId;
    string FileExt, FileExtAllow;
    int FileSize;

    protected void Page_Load(object sender, EventArgs e) {
        if (Request.Form["aid"] == null) {
            Response.Write("Please select a album to upload.");
            return;
        } else {
            AlbumId = Convert.ToInt32(Request.Form["aid"]);
        }
        
        try {
            HttpPostedFile UpFile;
            UpFile = Request.Files[0];
            if (UpFile.ContentLength > 0) {
                FileSize = UpFile.ContentLength / 1024;
                FileExt = UpFile.FileName.Substring(UpFile.FileName.LastIndexOf('.') + 1);
                string FileExtAllow = "jpg,bmp,gif,png";
                if (FileExtAllow.IndexOf(FileExt.ToLower()) == -1) {
                    Response.Write("file extension is forbid,"+FileExt);
                    return;
                }
                UploadDir = Server.MapPath("../") + "\\AlbumLib\\" + AlbumId;
                System.IO.DirectoryInfo NewDir = new System.IO.DirectoryInfo(UploadDir);
                NewDir.Create();
                
                UploadName = DateTime.Now.ToString("MMddHHmmssffffff") + "." + FileExt;
                UpFile.SaveAs(UploadDir + "\\" + UploadName);
                System.Drawing.Image Img = System.Drawing.Image.FromFile(UploadDir + "\\" + UploadName);
                Response.Write(UploadName + "|" + Img.Width + "|" + Img.Height + "|" + FileSize.ToString());
                Img.Dispose();
            } else {
                return;
            }
        } catch (Exception ex) {
            Response.Write(ex.Message);
            return;
        }
    }

    protected void Page_UnLoad(object sender, EventArgs e) {

    }
</script>

