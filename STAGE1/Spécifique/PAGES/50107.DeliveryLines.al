namespace GLOBAL_WINE_PROJECT.GLOBAL_WINE_PROJECT;
using Microsoft.Sales.History;

page 50107 "Delivery Lines"
{
    ApplicationArea = All;
    Caption = 'Delivery Lines';
    PageType = ListPart;
    MultipleNewLines = true;
    SourceTable = "Sales Shipment Line";
    Editable = false;
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                    ApplicationArea = All;
                }
                //customer Name
                field("No."; Rec."No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Round number"; Rec."Round number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
