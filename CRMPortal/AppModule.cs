using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Routing;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRMPortal
{
    public class AppTools
    {
        public void jsError(Literal ltrControl, string strMsg)
        {
            ltrControl.Text = @"<div class='alert alert-danger alert-dismissible' role='alert'>
                        <button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                        <strong>Error!</strong> " + @strMsg + @"
                    </div>";
        }
        public void jsWarning(Literal ltrControl, string strMsg)
        {
            ltrControl.Text = @"<div class='alert alert-warning alert-dismissible' role='alert'>
                        <button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                        <strong>Warning!</strong> " + @strMsg + @"
                    </div>";

        }
        public void jsInformation(Literal ltrControl, string strMsg)
        {
            ltrControl.Text = @"<div class='alert alert-info alert-dismissible' role='alert'>
                        <button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                        <strong>Information!</strong> " + @strMsg + @"
                    </div>";
        }
        public void jsSuccess(Literal ltrControl, string strMsg)
        {
            ltrControl.Text = @"<div class='alert alert-success alert-dismissible' role='alert'>
                        <button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                        <strong>Success!</strong> " + @strMsg + @"
                    </div>";
        }
        public string getAppValue(string strKey)
        {
            return Convert.ToString(ConfigurationManager.AppSettings[strKey]);
        }
    }
    public class AppSession
    {
        public void setSession(HttpContext Hc, string strSessionTag, string strSessionValue)
        {
            Hc.Session.Add(strSessionTag, strSessionValue);
        }
        public string getSession(HttpContext Hc, string strSessionTag)
        {
            return Convert.ToString(Hc.Session[strSessionTag]);
        }
        public bool IsSession(HttpContext Hc, string strSessionTag)
        {
            return Convert.ToString(Hc.Session[strSessionTag]) == string.Empty ? false : true;
        }
        public void unsetSession(HttpContext Hc, string strSessionTag)
        {
            Hc.Session[strSessionTag] = string.Empty;
        }
        public void unsetSession(HttpContext Hc)
        {
            Hc.Session.Abandon();
        }
    }
    public class AppSQL
    {
        public SqlConnection Con = new SqlConnection(ConfigurationManager.AppSettings["SQLConnect"]);
    }
    public class AppException
    {
    }
    public class AppRouting
    {
        public clsRoutingData[] getRouting()
        {
            List<clsRoutingData> RoutingList = new List<clsRoutingData>();
            RoutingList.Add(new clsRoutingData() { PageLocation = "~/Default.aspx", PageURL = "~/Authentication", PageControl = "Authentication" });
            RoutingList.Add(new clsRoutingData() { PageLocation = "~/frmAgent.aspx", PageURL = "~/AgentList", PageControl = "AgentList" });
            RoutingList.Add(new clsRoutingData() { PageLocation = "~/frmAppConfig.aspx", PageURL = "~/AppConfig", PageControl = "AppConfig" });
            RoutingList.Add(new clsRoutingData() { PageLocation = "~/frmInquiry.aspx", PageURL = "~/CustomerFeedback", PageControl = "CustomerFeedback" });
            return RoutingList.ToArray();
        }
        public string getRouteURL(string PageControl)
        {
            clsRoutingData[] PageURL = ((clsRoutingData[])getRouting().Where(x => x.PageControl == PageControl).ToArray());
            if (PageURL.Length > 0 && string.IsNullOrEmpty(PageURL[0].PageURL))
            {
                return string.Empty;
            }
            else
            {
                return PageURL[0].PageURL;
            }
        }
        public void setRouting(RouteCollection routeTable)
        {
            clsRoutingData[] RoutingList = getRouting();
            for (int i = 0; i < RoutingList.Length; i++)
            {
                routeTable.MapPageRoute(RoutingList[i].PageURL, RoutingList[i].PageControl, RoutingList[i].PageLocation);
            }
        }
    }
    [Serializable()]
    public class clsRoutingData
    {
        public string PageLocation { get; set; }
        public string PageURL { get; set; }
        public string PageControl { get; set; }
    }
}