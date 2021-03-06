﻿<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Page Language="C#" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    SqlDataReader Sr;
    string UserName, Password, SQL;

    protected void Page_Load(object sender, EventArgs e) {
        UserName = Request["uname"];
        Password = Request["pwd"];
        if (string.IsNullOrEmpty(UserName) || string.IsNullOrEmpty(Password)) {
            Response.Write("用户名或密码没有填写。");
            return;
        }
        DB.SQLFiltrate(ref UserName);
        DB.SQLFiltrate(ref Password);
        SQL = "SELECT * FROM Sean_ManagerList WHERE ManagerName='" + UserName + "' AND Password='" + Password + "'";
        Sr = MZ.GetReader(SQL);
        if (Sr.Read()) {
            Session["ManagerId"] = Sr.GetInt32(0);
            Session["ManagerName"] = Sr.GetString(1);
            Sr.Close();
            Response.Write("0");
        }
        else {
            Sr.Close();
            Response.Write("用户名或密码错误。");
        }
    }

    protected void Page_Unload(object sender, EventArgs e) {
        MZ = null;
    }

</script>
