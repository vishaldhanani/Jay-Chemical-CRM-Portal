using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using AppStarSQL;

namespace CRMPortal
{
    public partial class frmAgent : System.Web.UI.Page
    {
        AppTools objTool = new AppTools();
        AppSQL objSQL = new AppSQL();
        SSMSTool objSSMS = new SSMSTool();
        AppSession objSession = new AppSession();
        AppRouting objRout = new AppRouting();

        public void BindCustomer()
        {
            dpCustomer.Items.Clear();
            dpCustomer.Items.Add(new ListItem("Select Customer", string.Empty));
            dpCustomer.AppendDataBoundItems = true;
            string strExecutiveCode = objSession.getSession(HttpContext.Current, objTool.getAppValue("ExecutiveCode"));
            string strItemCategoryCode = objSession.getSession(HttpContext.Current, objTool.getAppValue("ItemCategoryCode"));
            DataTable dtAgentList = objSSMS.Fill_Datatable(objSQL.Con, "spAgentList", new string[] { "ReadClient", strExecutiveCode, strItemCategoryCode });
            if (dtAgentList.Rows.Count > 0)
            {
                dpCustomer.DataSource = dtAgentList;
                dpCustomer.DataTextField = "Customer Name";
                dpCustomer.DataValueField = "Customer No_";
                dpCustomer.DataBind();
            }
        }
        public StringBuilder BindFeedbackDetails(string strFeedbackFrmID)
        {
            DataTable dtFeedbackVal = objSSMS.Fill_Datatable(objSQL.Con, "spCustomerFeeback", new string[] { "ViewCustomerFeedbackVal", strFeedbackFrmID });
            StringBuilder sb = new StringBuilder();
            string strHeading = string.Empty;
            if (dtFeedbackVal.Rows.Count > 0)
            {
                sb.AppendLine(@"
                <div class='col-lg-12'>
                <details>
                <summary><h4><b>Feedback Details</b></h4></summary>
                <dl>
                ");
                for (int i = 0; i < dtFeedbackVal.Rows.Count; i++)
                {
                    string FeedbackTag = Convert.ToString(dtFeedbackVal.Rows[i]["FeedbackOpTag"]);
                    string FeedbackTest = Convert.ToString(dtFeedbackVal.Rows[i]["FeedbackOpText"]);
                    if (strHeading == Convert.ToString(dtFeedbackVal.Rows[i]["FeedbackMstTag"]))
                    {
                        sb.AppendLine("<dd>" + FeedbackTag + "</dd>");
                    }
                    else
                    {
                        strHeading = Convert.ToString(dtFeedbackVal.Rows[i]["FeedbackMstTag"]);
                        sb.AppendLine(@"                
                    <dt><h4><u>" + strHeading + @"</u></h4></dt>
                    <dd>" + FeedbackTag + ":" + (FeedbackTest == string.Empty ? "<span class='glyphicon glyphicon-ok'></span>" : FeedbackTest) + "</dd>");
                    }
                }
                sb.AppendLine(@"
                </dl>
                </details>
                </div>
                ");
            }
            else
            {
                sb.AppendLine(string.Empty);
            }
            return sb;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    dpCustomer.Items.Clear();
                    dpCustomer.Items.Add(new ListItem("Select Customer", string.Empty));
                    dpCustomer.AppendDataBoundItems = true;

                    dpSubCustomer.Items.Clear();
                    dpSubCustomer.Items.Add(new ListItem("Select Customer", string.Empty));
                    dpSubCustomer.AppendDataBoundItems = true;

                    BindCustomer();
                }
            }
            catch (Exception)
            {

            }
        }
        protected void dpCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (dpCustomer.SelectedIndex != 0)
                {
                    dpSubCustomer.Items.Clear();
                    dpSubCustomer.Items.Add(new ListItem("Select Sub Customer", string.Empty));
                    dpSubCustomer.AppendDataBoundItems = true;
                    string strExecutiveCode = objSession.getSession(HttpContext.Current, objTool.getAppValue("ExecutiveCode"));
                    string strItemCategoryCode = objSession.getSession(HttpContext.Current, objTool.getAppValue("ItemCategoryCode"));
                    DataTable dtAgentList = objSSMS.Fill_Datatable(objSQL.Con, "spAgentList", new string[] { "ReadSubClient", dpCustomer.SelectedValue });
                    if (dtAgentList.Rows.Count > 0)
                    {
                        dpSubCustomer.DataSource = dtAgentList;
                        dpSubCustomer.DataTextField = "CustomerName";
                        dpSubCustomer.DataValueField = "CustomerID";
                        dpSubCustomer.DataBind();
                    }
                }
                else
                {
                    dpSubCustomer.Items.Clear();
                    dpSubCustomer.Items.Add(new ListItem("Select Customer", string.Empty));
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void btnCustomerFeedback_Click(object sender, EventArgs e)
        {
            try
            {

                if (dpSubCustomer.SelectedIndex == 0)
                {
                    objTool.jsWarning(ltrNotificationArea, "Please Select Customer from List.");
                }
                else
                {
                    Response.Redirect(objRout.getRouteURL("CustomerFeedback") + "?CustNo=" + dpSubCustomer.SelectedValue);
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
    }
}