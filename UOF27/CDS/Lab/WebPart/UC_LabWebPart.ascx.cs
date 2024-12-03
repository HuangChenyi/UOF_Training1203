using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.SystemInfo;
using Ede.Uof.Utility.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Lab_WebPart_LabWebPart : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblWebPartText.Text = string.Format("Hello WebPart!現在時間為:{0}", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
   
        if(!IsPostBack)
        {
            Setting setting = new Setting();
            UserSet userSet = new UserSet();
            userSet.SetXML(setting["LabWebPartAuth"]);
         
            if(!userSet.Contains(Current.UserGUID))
            {
                lblWebPartText.Text = "你沒有權限觀看!";
            }
        }
    }
}