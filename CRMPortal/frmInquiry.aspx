<%@ Page Title="" Language="C#" MasterPageFile="~/mstNavClient.master" AutoEventWireup="true" CodeBehind="frmInquiry.aspx.cs" Inherits="CRMPortal.frmInquiry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="mstNavClientHead" runat="server">
    <style>
        label {
            font-size: 13px;
        }

        h4 {
            font-size: 14px;
            color: steelblue;
            text-transform: uppercase;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .form-control {
                margin-bottom: 5px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mstNavClientBody" runat="server">
    <script type="text/javascript">
        function validateQty2(event) {
            var key = window.event ? event.keyCode : event.which;

            if (event.keyCode < 48 || event.keyCode > 57) {
                return false;
            }
            else return true;
        };
    </script>
    <script type="text/javascript">
        function validate() {
            var OwnerEmail = document.getElementById('<%=txtOEmailID.ClientID %>').value;
            var txtTEmailID = document.getElementById('<%=txtTEmailID.ClientID %>').value;
            var emailPat = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (txtOEmailID.value != "") {
                if (!emailPat.test(OwnerEmail)) {
                    alert("Please enter correct e-mail Id of Owner E-mail.");
                    document.getElementById("<%=txtOEmailID.ClientID %>").focus();
                    return false;
                }
            }
            if (txtTEmailID.value != "") {
                if (!emailPat.test(txtTEmailID)) {
                    alert("Please enter correct e-mail Id of Technical Person E-mail.");
                    document.getElementById("<%=txtTEmailID.ClientID %>").focus();
                    return false;
                }
            }
        }
    </script>
    <div class=" col-lg-12 col-md-12 col-sm-12 col-xs-12 well main FormPage">
        <div class="col-sm-12 col-md-12 col-lg-12 col-xs-12">
            <%-- <div class="clearfix"></div>
            
            <br />
            <br />--%>

            <asp:Literal ID="ltrNotificationArea" runat="server"></asp:Literal>
        </div>

        <div class="row placeholders">
            <div class="container">
                <div class="form-group col-lg-12" style="margin-bottom: 5px; margin-top: 5px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Date:</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" ValidationGroup="GRPA"></asp:TextBox>
                        <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate" PopupButtonID="txtDate" />
                        <asp:HiddenField ID="hfItemCategoryCode" runat="server"></asp:HiddenField>
                        <asp:RequiredFieldValidator ID="ReqValtxtDate" runat="server" ControlToValidate="txtDate" Display="Dynamic" ErrorMessage="Enter Post Date." ValidationGroup="GRPA"></asp:RequiredFieldValidator>
                    </div>

                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>JCIL Executive:</label>
                    </div>

                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtJCILExec" runat="server" CssClass="form-control" ValidationGroup="GRPA" ReadOnly="true"></asp:TextBox>
                        <asp:HiddenField ID="hfExecutiveCode" runat="server"></asp:HiddenField>
                        <asp:RequiredFieldValidator ID="ReqValtxtJCILExec" runat="server" ControlToValidate="txtJCILExec" Display="Dynamic" ErrorMessage="Enter JCIL Executive." ValidationGroup="GRPA"></asp:RequiredFieldValidator>
                    </div>

                </div>
                <div class="clearfix"></div>
                <%--<hr style ="margin:6px 0;" />--%>
                <div class="form-group col-lg-12" style="margin-bottom: 4px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Customer Name</label>
                    </div>
                    <div class="col-lg-3 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" MaxLength="100" ValidationGroup="GRPZ" ReadOnly="true"></asp:TextBox>
                        <asp:HiddenField ID="hfCustomerID" runat="server" />
                    </div>

                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Phone No</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtPhoneNo" runat="server" CssClass="form-control" ValidationGroup="GRPZ" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group col-lg-12" style="margin-bottom: 3px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Address</label>
                    </div>
                    <div class="col-lg-8 col-md-10 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" MaxLength="100" ValidationGroup="GRPZ" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>



                <h4 style="margin-bottom: 2px;">Owner
                </h4>
                <%--<hr  style ="margin:13px 0 6px;" />--%>
                <div class="form-group col-lg-12" style="margin-bottom: 4px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Name</label>
                    </div>
                    <div class="col-lg-3 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtOName" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Designation</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtODesignation" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group col-lg-12" style="margin-bottom: 7px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Contact No.</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtOContactNo" runat="server" CssClass="form-control" onkeypress="return validateQty2(event);" ValidationGroup="GRPA" MaxLength="11"></asp:TextBox>
                    </div>

                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Email ID</label>
                    </div>
                    <div class="col-lg-3 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtOEmailID" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>
                </div>

                <h4 style="margin-bottom: 6px;">Technical Person  (Key Decision Maker)
                </h4>
                <%--<hr  style ="margin:14px 0 5px;" />--%>
                <div class="form-group col-lg-12" style="margin-bottom: 4px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Name</label>
                    </div>
                    <div class="col-lg-3 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtTName" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>

                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Designation</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtTDesignation" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group col-lg-12" style="margin-bottom: -15px;">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Contact No.</label>
                    </div>
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtTContactNo" runat="server" onkeypress="return validateQty2(event);" CssClass="form-control" ValidationGroup="GRPA" MaxLength="11"></asp:TextBox>
                    </div>

                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Email ID</label>
                    </div>
                    <div class="col-lg-3 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtTEmailID" runat="server" CssClass="form-control" ValidationGroup="GRPA" MaxLength="255"></asp:TextBox>
                    </div>
                </div>
                <div class="clearfix"></div>

                <asp:Repeater ID="rptFeedbackHeading" runat="server">
                    <ItemTemplate>
                        <h4 style="margin: 18px 0 8px 0; padding-top: 4px;">
                            <asp:Literal ID="ltrHeading" runat="server" Text='<% #Eval("FeedbackMstTag")%>'></asp:Literal>
                            <asp:HiddenField ID="hfFeedbackMstID" runat="server" Value='<% #Eval("FeedbackMstID")%>' />
                            <asp:HiddenField ID="hfIsMultiple" runat="server" Value='<% #Eval("IsMultiple")%>' />
                            <asp:HiddenField ID="hfIsRequired" runat="server" Value='<% #Eval("IsRequired")%>' />
                        </h4>
                        <%--<hr  style ="margin:4px 0 4px;"/>--%>
                        <div class="form-group col-lg-12" style="margin-bottom: -18px;">
                            <asp:Repeater ID="rptFeedbackOption" runat="server">
                                <ItemTemplate>
                                    <div class="col-lg-3 col-md-3 col-xs-12 col-sm-12">
                                        <asp:CheckBox ID="chkFeedbackOption" runat="server" Text='<% #Eval("FeedbackOpTag")%>' AutoPostBack="true" OnCheckedChanged="chkFeedbackOption_CheckedChanged" Visible="false" />
                                        <asp:RadioButton ID="rdFeedbackOption" runat="server" Text='<% #Eval("FeedbackOpTag")%>' AutoPostBack="true" OnCheckedChanged="rdFeedbackOption_CheckedChanged" Visible="false" />
                                        <asp:HiddenField ID="hfIsTextbox" runat="server" Value='<% #Eval("FeedbackOthOpText")%>' />
                                        <asp:HiddenField ID="FeedbackOpID" runat="server" Value='<% #Eval("FeedbackOpID")%>' />
                                    </div>
                                    <asp:Panel ID="pnlOtherText" runat="server" CssClass="col-lg-2 col-md-2 col-xs-12 col-sm-12" Visible="false">
                                        <asp:TextBox ID="txtOtherText" runat="server" CssClass="form-control" Visible="false" ValidationGroup="GRPA"></asp:TextBox>                                        
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="clearfix"></div>

                    </ItemTemplate>
                </asp:Repeater>
                <div class="form-group col-lg-12" style="margin: 22px 0 6px 0;">
                    <asp:Button ID="btnSend" runat="server" CssClass="btn btn-primary" OnClientClick="return validate();" Text="Submit Details" OnClick="btnSend_Click" ValidationGroup="GRPA" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
