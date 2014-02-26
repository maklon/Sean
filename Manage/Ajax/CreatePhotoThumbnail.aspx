<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="gb2312" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["Android_DBConn"].ConnectionString);
    string SQL;
    SqlDataReader Sr;
    StringBuilder SSQL;
    int PhotoWidth, PhotoHeight;
    string FilePath;

    protected void Page_Load(object sender, EventArgs e) {

        SQL = "SELECT Id,AlbumId,FileName,PhotoWidth,PhotoWidth FROM Sean_PhotoList WHERE Status=5";
        Sr = MZ.GetReader(SQL);
        SSQL = new StringBuilder();
        
        while (Sr.Read()) {
            PhotoWidth = (int)(Sr.GetInt32(3)*.6);
            PhotoHeight = (int)(Sr.GetInt32(4)*.6);
            FilePath = Server.MapPath("../../") + "AlbumLib\\" + Sr.GetInt32(1) + "\\";
            try {
                MakeThumbnail(FilePath + Sr.GetString(2), FilePath + "Thumbnail_" + Sr.GetString(2), PhotoWidth, PhotoHeight, "HW");
                SSQL.Append("UPDATE Sean_PhotoList SET Status=10 WHERE Id=" + Sr.GetInt32(0) + ";");
            } catch (Exception ex) {
                Response.Write("生成缩略图失败。(" + ex.Message + ")");
            }          
        }
        Sr.Close();
        if (SSQL.Length > 0) {
            try {
                MZ.ExecuteSQL(SSQL.ToString());
                Response.Write(0);
            } catch (Exception ex) {
                Response.Write("生成缩略图失败:"+ex.Message);
            }
        }
    }

    protected void Page_UnLoad(object sender, EventArgs e) {
        MZ = null;
    }


    public static void MakeThumbnail(string originalImagePath, string thumbnailPath, int width, int height, string mode) {
        System.Drawing.Image originalImage = System.Drawing.Image.FromFile(originalImagePath);

        int towidth = width;
        int toheight = height;

        int x = 0;
        int y = 0;
        int ow = originalImage.Width;
        int oh = originalImage.Height;

        switch (mode) {
            case "HW"://指定高宽缩放（可能变形）                
                break;
            case "W"://指定宽，高按比例                    
                toheight = originalImage.Height * width / originalImage.Width;
                break;
            case "H"://指定高，宽按比例
                towidth = originalImage.Width * height / originalImage.Height;
                break;
            case "Cut"://指定高宽裁减（不变形）                
                if ((double)originalImage.Width / (double)originalImage.Height > (double)towidth / (double)toheight) {
                    oh = originalImage.Height;
                    ow = originalImage.Height * towidth / toheight;
                    y = 0;
                    x = (originalImage.Width - ow) / 2;
                } else {
                    ow = originalImage.Width;
                    oh = originalImage.Width * height / towidth;
                    x = 0;
                    y = (originalImage.Height - oh) / 2;
                }
                break;
            default:
                break;
        }

        //新建一个bmp图片
        System.Drawing.Image bitmap = new System.Drawing.Bitmap(towidth, toheight);

        //新建一个画板
        Graphics g = System.Drawing.Graphics.FromImage(bitmap);

        //设置高质量插值法
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;

        //设置高质量,低速度呈现平滑程度
        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

        //清空画布并以透明背景色填充
        g.Clear(Color.Transparent);

        //在指定位置并且按指定大小绘制原图片的指定部分
        g.DrawImage(originalImage, new Rectangle(0, 0, towidth, toheight),
            new Rectangle(x, y, ow, oh),
            GraphicsUnit.Pixel);

        try {
            //以jpg格式保存缩略图
            bitmap.Save(thumbnailPath, System.Drawing.Imaging.ImageFormat.Jpeg);
        } catch (System.Exception e) {
            throw e;
        } finally {
            originalImage.Dispose();
            bitmap.Dispose();
            g.Dispose();
        }
    }
</script>
