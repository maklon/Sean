﻿<%@ Import Namespace="MaklonZjing.MSSQL" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Page Language="C#" %>
<script runat="server">
    DB MZ = new DB(ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString);
    string SQL, IMEI, IMSI, PhoneNumber, Version, GameData;
    string Action, GameStatus, Money, Wave, Life,PayMoneyCount, PayFireStormCount;
    string[] GameDataArr;
    
    protected void Page_Load(object Sender, EventArgs e) {
        IMEI = Request.QueryString["imei"];
        IMSI = Request.QueryString["imsi"];
        PhoneNumber = Request.QueryString["num"];
        Version = Request.QueryString["ver"];
        GameData = Request.QueryString["data"];
        DB.SQLFiltrate(ref IMEI);
        DB.SQLFiltrate(ref IMSI);
        DB.SQLFiltrate(ref PhoneNumber);
        DB.SQLFiltrate(ref Version);
        DB.SQLFiltrate(ref GameData);
        GameDataArr = GameData.Split('|');
        if (GameDataArr.Length == 5) {
            Action = GameDataArr[0];
            GameStatus = GameDataArr[1];
            Money = GameDataArr[2];
            Wave = GameDataArr[3];
            Life = GameDataArr[4];
            PayMoneyCount = "0";
            PayFireStormCount = "0";
            Version = "1.2.0";//针对v2版API调用v1版API的手工
        }else if (GameDataArr.Length==7){
            Action = GameDataArr[0];
            GameStatus = GameDataArr[1];
            Money = GameDataArr[2];
            Wave = GameDataArr[3];
            Life = GameDataArr[4];
            PayMoneyCount = GameDataArr[5];
            PayFireStormCount = GameDataArr[6];
        } else {
            Action = "DATA_ERROR";
            GameStatus = "";
            Money = "0";
            Wave = "0";
            Life = "0";
            PayMoneyCount = "0";
            PayFireStormCount = "0";
        }
        SQL = "INSERT INTO KDInfo (IMEI,IMSI,PhoneNumber,Action,Version,GameStatus,Gold,Wave,Life,BuyMoneyCount,BuyFireStormCount) VALUES('"
            + IMEI + "','" + IMSI + "','" + PhoneNumber + "','" + Action + "','" + Version + "','" + GameStatus + "',"
            + Money + "," + Wave + "," + Life + "," + PayMoneyCount + "," + PayFireStormCount + ")";
        try {
            MZ.ExecuteSQL(SQL);
            Response.Write("0");
        } catch (Exception ex) {
            Response.Write(ex.Message);
        }
    }

    protected void Page_Unload(object Sender, EventArgs e) {
        MZ = null;
    }

</script>
