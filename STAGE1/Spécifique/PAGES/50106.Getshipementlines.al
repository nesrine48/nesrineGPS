namespace GLOBAL_WINE_PROJECT.GLOBAL_WINE_PROJECT;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;

page 50106 "Get shipement lignes"
{
    ApplicationArea = All;
    Caption = 'Get shipement lignes';
    PageType = List;
    SourceTable = "Sales Shipment Header";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = true;
    SourceTableView = sorting("Sell-to Customer No.");


    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("No."; rec."No.")
                {
                    Caption = 'Delivery No.';
                    ApplicationArea = all;
                }

                field("Customer No"; rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = all;
                }
                field("Customer Name"; rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ApplicationArea = all;
                }
                field("Round number"; rec."Round number")
                {
                    ApplicationArea = all;
                }


            }
        }
    }


    actions
    {
        area(processing)
        {
            action("ClearSelection")
            {
                ApplicationArea = all;
                Caption = 'Clear Selection';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    DeliverRoute: Record "Delivery route";
                    SalesShipHeader: Record "Sales Shipment Header";
                begin
                    SalesShipHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesShipHeader);
                    DeliverRoute.TestField(Status, DeliverRoute.Status::"0");
                    if SalesShipHeader.FindSet() then
                        repeat
                            DeliverRoute.ClearSelection(SalesShipHeader);
                        until SalesShipHeader.Next() = 0;

                    CurrPage.Update();
                end;
            }


        }

    }



    var
        DocumentNoHideValue: Boolean;
        OrderNo: Code[20];
        YourReference: Text[35];
        ExternalDocumentNo: Text[35];
        // SalesGetShpt: Codeunit "Sales-Get Shipment";
        SalesHeader: Record "Sales Header";
        salesShipLine: record "Sales Shipment Line";
}
