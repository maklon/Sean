<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Page Language="C#" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string SQL, Id, AlbumName, AlbumPicId, Status, OrderId, Action;

    protected void Page_Load(object sender, EventArgs e) {
        Action = Request.Form["action"];
        Id = Request.Form["Id"];

        AlbumInfo aInfo = new AlbumInfo();
        aInfo.Id = 1;
        aInfo.OrderId = 0;
        aInfo.AlbumPicId = 2;
        aInfo.AlbumName = "相册名称";
        aInfo.PhotoList.Add(new SimplePhoto(1, "1.jpg"));
        aInfo.PhotoList.Add(new SimplePhoto(2, "2.jpg"));
        aInfo.PhotoList.Add(new SimplePhoto(3, "3.jpg"));
        aInfo.ResultMessage = "测试";
        string json = JsonConvert.SerializeObject(aInfo, Formatting.Indented);
        Response.Write(json);
        Response.End();
        
        
        if (string.IsNullOrEmpty(Id) || !General.IsMatch(Id, "^\\d+$")) {
            
        }
        
        if (Action == "AddNew") {

        }
        else if (Action == "Update") {

        }
        else if (Action == "Delete") {
            
        }
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

    public class AlbumInfo
    {
        public int Id { get; set; }
        public string AlbumName { get; set; }
        public int AlbumPicId{ get; set; }
        public int Status{ get; set; }
        public int OrderId { get; set; }
        public List<SimplePhoto> PhotoList { get; set; }
        public int ResultCode { get; set; }
        public string ResultMessage { get; set; }

        public AlbumInfo() {
            PhotoList = new List<SimplePhoto>();
        }
    }

    public class SimplePhoto
    {
        public int Id;
        public string FileName;

        public SimplePhoto(int id, string fileName) {
            this.Id = id;
            this.FileName = fileName;
        }
        
    }

</script>
