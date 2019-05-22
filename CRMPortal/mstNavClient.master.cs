using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppStarSQL;

namespace CRMPortal
{
    public partial class mstNavClient : System.Web.UI.MasterPage
    {
        AppRouting objRoute = new AppRouting();
        AppSession objSession = new AppSession();
        AppTools objTool = new AppTools();
        SSMSTool objSSMS = new SSMSTool();
        AppSQL objSQL = new AppSQL();

        public void setAuth()
        {
            if (objSession.IsSession(HttpContext.Current, objTool.getAppValue("UsrID")) == true && objSession.IsSession(HttpContext.Current, objTool.getAppValue("UsrPwd")) == true && objSession.IsSession(HttpContext.Current, objTool.getAppValue("UsrRoleID")) && objSession.IsSession(HttpContext.Current, objTool.getAppValue("UsrRoleName")) && objSession.IsSession(HttpContext.Current, objTool.getAppValue("ExecutiveCode")) && objSession.IsSession(HttpContext.Current, objTool.getAppValue("ExecutiveName")) && objSession.IsSession(HttpContext.Current, objTool.getAppValue("ItemCategoryCode")))
            {
                DataTable dtUsrRoll = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "getUsrRoll", string.Empty, string.Empty, objSession.getSession(HttpContext.Current, objTool.getAppValue("UsrRoleID")) });
                if (dtUsrRoll.Rows.Count == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "", "alert('You don't have authentication for Access.'); window", true);
                    Response.Redirect(objRoute.getRouteURL("Authentication"), false);
                }
                else
                {
                    string IsFeedback = Convert.ToString(dtUsrRoll.Rows[0]["IsFeedbackForm"]);
                    if (IsFeedback == "True")
                    {
                        hlFeedbackForm.Visible = true;
                        hlFeedbackForm.NavigateUrl = objRoute.getRouteURL("AgentList");
                    }
                    else
                    {
                        hlFeedbackForm.Visible = false;
                    }
                    int strIsRollID = Convert.ToInt32(objSession.getSession(HttpContext.Current, objTool.getAppValue("UsrRoleID")));
                    if (strIsRollID == 2)
                    {

                        hlConfigureation.Visible = false; 
                    }
                    else
                    {
                        string strIsConfig = Convert.ToString(dtUsrRoll.Rows[0]["IsConfigAuth"]);
                        if (strIsConfig == "True")
                        {
                            hlConfigureation.Visible = true;
                            hlConfigureation.NavigateUrl = objRoute.getRouteURL("AppConfig");
                        }
                        else
                        {
                            hlConfigureation.Visible = false;
                        }
                    }
                }
            }
            else
            {
                Response.Redirect(objRoute.getRouteURL("Authentication"), false);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    setAuth();
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkSignout_Click(object sender, EventArgs e)
        {
            try
            {
                objSession.unsetSession(HttpContext.Current);
                Response.Redirect(objRoute.getRouteURL("Authentication"), false);
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
    }
}