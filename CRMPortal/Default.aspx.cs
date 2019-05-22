using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppStarSQL;
using DataSecurity;

namespace CRMPortal
{
    public partial class Default : System.Web.UI.Page
    {
        AppRouting objRoute = new AppRouting();
        AppSession objSession = new AppSession();
        AppTools objTool = new AppTools();
        AppSQL objSQL = new AppSQL();
        SSMSTool objSSMS = new SSMSTool();
        SecurityAlgorithm objSecurity = new SecurityAlgorithm();
        public void ValidUser(string strUserID, string strUsrPwd)
        {
            string strEPwd = objSecurity.EncryptWithKey(strUsrPwd, objTool.getAppValue("SecurityKey"));
            DataTable dtUserAuth = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "UserList", strUserID, strEPwd });
            if (dtUserAuth.Rows.Count > 0)
            {
                string strRollID = Convert.ToString(dtUserAuth.Rows[0]["UsrRollID"]);
                string strRollName = Convert.ToString(dtUserAuth.Rows[0]["UsrRollName"]);
                string strExecutiveCode = Convert.ToString(dtUserAuth.Rows[0]["ExecuteID"]);
                string strExecutiveName = Convert.ToString(dtUserAuth.Rows[0]["Name"]);
                string strItemCode = Convert.ToString(dtUserAuth.Rows[0]["Item Category Code"]);

                objSession.setSession(HttpContext.Current, objTool.getAppValue("UsrID"), strUserID);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("UsrPwd"), strEPwd);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("UsrRoleID"), strRollID);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("UsrRoleName"), strRollName);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("ExecutiveCode"), strExecutiveCode);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("ExecutiveName"), strExecutiveName);
                objSession.setSession(HttpContext.Current, objTool.getAppValue("ItemCategoryCode"), strItemCode);//
                if (strRollID == "2")
                {
                    Response.Redirect(objRoute.getRouteURL("AppConfig"), false);
                }
                else
                {
                    Response.Redirect(objRoute.getRouteURL("AgentList"), false);
                }
            }
            else
            {
                objTool.jsWarning(ltrNotificationArea, "Please check your User ID or Password again.");
            }
        }
        public void tryPasword(string strUsrPwd)
        {
            try
            {
                objSecurity.EncryptWithKey(strUsrPwd, objTool.getAppValue("SecurityKey"));
            }
            catch (Exception)
            {
                objTool.jsError(ltrNotificationArea, "Sorry Password is not Corrent!");                
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                tryPasword(txtPassword.Text);
                ValidUser(txtUsrID.Text, txtPassword.Text);
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
    }
}