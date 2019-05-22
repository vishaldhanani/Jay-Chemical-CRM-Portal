<%@ Page Title="" Language="C#" MasterPageFile="~/mstNavClient.master" AutoEventWireup="true" CodeBehind="frmAgent.aspx.cs" Inherits="CRMPortal.frmAgent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="mstNavClientHead" runat="server">
    <style>
        .width-control {
            margin: 0 auto;
            width: 36%;
        }

        @media (max-width: 768px) {
            .width-control {
                margin: 0 auto;
                width: 99%;
            }

            .show-customer {
                display: none;
            }

            .vis-customer {
                width: 100%;
            }
        }
    </style>
    <link rel="stylesheet" href="assets/chosen.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mstNavClientBody" runat="server">
    <asp:UpdatePanel ID="upPanelMain" runat="server">
        <ContentTemplate>
            <div class=" col-lg-12 col-md-12 col-sm-12 col-xs-12 well main FormPage">
                <div class="col-sm-12 col-md-12 col-lg-12 col-xs-12">
                    <div class="clearfix"></div>
                    <br />
                    <br />
                    <br />
                    <asp:Literal ID="ltrNotificationArea" runat="server"></asp:Literal>
                </div>
                <div style="height: 25vh;">
                </div>
                <div class="width-control">
                    <div class="row placeholders">
                        <div class="form-group col-lg-12">
                            <div class="col-lg-2 col-md-3 col-xs-6 col-sm-6 vis-customer">
                                <label>Customer</label>
                            </div>
                            <div class="col-lg-8 col-md-3 col-xs-6 col-sm-6 vis-customer">
                                <asp:DropDownList ID="dpCustomer" runat="server" CssClass="form-control chosen-select" ValidationGroup="GRPA" AutoPostBack="true" OnSelectedIndexChanged="dpCustomer_SelectedIndexChanged"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqValdpCustomer" runat="server" ControlToValidate="dpCustomer" ErrorMessage="Select Customer" ValidationGroup="GRPA"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group col-lg-12">
                            <div class="col-lg-2 col-md-3 col-xs-6 col-sm-6 vis-customer">
                                Sub Customer 
                            </div>
                            <div class="col-lg-8 col-md-3 col-xs-6 col-sm-6 vis-customer">
                                <asp:DropDownList ID="dpSubCustomer" runat="server" CssClass="form-control chosen-select" ValidationGroup="GRPA" AutoPostBack="true"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqValdpSubCustomer" runat="server" ControlToValidate="dpSubCustomer" ErrorMessage="Select Sub Customer" ValidationGroup="GRPA"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-2 col-md-3 col-xs-6 col-sm-6 vis-customer">
                            </div>
                        </div>
                        <div class="form-group col-lg-12" style="text-align: center;">
                            <div class="col-lg-2 col-md-2 col-xs-6 col-sm-6" style="width: 100%; margin: 0 auto;">
                                <asp:LinkButton ID="btnCustomerFeedback" runat="server" CssClass="btn btn-primary" Text="Customer Feedback" OnClick="btnCustomerFeedback_Click"></asp:LinkButton>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                        <br />
                        <div class="table-responsive" style="visibility: hidden;">
                            <table class="table table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Item Category</th>
                                        <th>Customer Name</th>
                                        <th>Owner Name</th>
                                        <th>Owner Contact</th>
                                        <th>Owner Email</th>
                                        <th>Technical Name</th>
                                        <th>Technical Contact</th>
                                        <th>Technical Email</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptCustFeedback" runat="server" Visible="false">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblFeedbackDt" runat="server" Text='<% #Eval("FeedbackDt", "{0:dd-MMM-yyyy}")%>'></asp:Label>
                                                    <asp:HiddenField ID="hfFeedbackFrmID" runat="server" Value='<% #Eval("FeedbackFrmID")%>' />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblItemCat" runat="server" Text='<% #Eval("ItemCat")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCustomerName" runat="server" Text='<% #Eval("CustomerName")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblOwName" runat="server" Text='<% #Eval("OwName")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblOwContact" runat="server" Text='<% #Eval("OwContact")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblOwEmail" runat="server" Text='<% #Eval("OwEmail")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTechName" runat="server" Text='<% #Eval("TechName")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTechContact" runat="server" Text='<% #Eval("TechContact")%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTechEmail" runat="server" Text='<% #Eval("TechEmail")%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="9">
                                                    <asp:Literal ID="ltrFeedbackDetails" runat="server"></asp:Literal>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
            <script src="assets/chosen.jquery.js" type="text/javascript"></script>
            <script src="assets/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
            <script type="text/javascript">
                var config = {
                    '.chosen-select': {},
                    '.chosen-select-deselect': { allow_single_deselect: true },
                    '.chosen-select-no-single': { disable_search_threshold: 10 },
                    '.chosen-select-no-results': { no_results_text: 'Oops, Customer Not found!' },
                    '.chosen-select-width': { width: "95%" }
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
            </script>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="dpCustomer" />
            <asp:PostBackTrigger ControlID="dpSubCustomer" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
