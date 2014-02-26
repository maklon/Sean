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
                Response.Write("��������ͼʧ�ܡ�(" + ex.Message + ")");
            }          
        }
        Sr.Close();
        if (SSQL.Length > 0) {
            try {
                MZ.ExecuteSQL(SSQL.ToString());
                Response.Write(0);
            } catch (Exception ex) {
                Response.Write("��������ͼʧ��:"+ex.Message);
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
            case "HW"://ָ���߿����ţ����ܱ��Σ�                
                break;
            case "W"://ָ�����߰�����                    
                toheight = originalImage.Height * width / originalImage.Width;
                break;
            case "H"://ָ���ߣ�������
                towidth = originalImage.Width * height / originalImage.Height;
                break;
            case "Cut"://ָ���߿�ü��������Σ�                
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

        //�½�һ��bmpͼƬ
        System.Drawing.Image bitmap = new System.Drawing.Bitmap(towidth, toheight);

        //�½�һ������
        Graphics g = System.Drawing.Graphics.FromImage(bitmap);

        //���ø�������ֵ��
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;

        //���ø�����,���ٶȳ���ƽ���̶�
        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

        //��ջ�������͸������ɫ���
        g.Clear(Color.Transparent);

        //��ָ��λ�ò��Ұ�ָ����С����ԭͼƬ��ָ������
        g.DrawImage(originalImage, new Rectangle(0, 0, towidth, toheight),
            new Rectangle(x, y, ow, oh),
            GraphicsUnit.Pixel);

        try {
            //��jpg��ʽ��������ͼ
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
