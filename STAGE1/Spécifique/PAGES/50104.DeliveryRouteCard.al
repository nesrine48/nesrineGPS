namespace GLOBAL_WINE_PROJECT.GLOBAL_WINE_PROJECT;
using Microsoft.Sales.Document;
using Microsoft.Foundation.Shipping;

page 50104 "Delivery Route Card"
{
    ApplicationArea = All;
    Caption = 'Delivery Route Card';
    PageType = Card;
    SourceTable = "Delivery route";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Round number"; rec."Round number")
                {
                    ApplicationArea = all;
                    Editable = EditableRecord;
                }
                field("Delivery date"; rec."Delivery date")
                {
                    ApplicationArea = all;
                    Editable = EditableRecord;
                }
                field("No driver"; rec."No driver")
                {
                    ApplicationArea = all;
                    TableRelation = "Shipping Agent".Code;
                    Editable = EditableRecord;
                    trigger OnValidate()
                    var
                        ShippingAgent: Record "Shipping Agent";
                    begin
                        if ShippingAgent.Get(Rec."No driver") then
                            rec."Name driver" := ShippingAgent.Name;
                    end;
                }
                field("Name driver"; rec."Name driver")
                {
                    ApplicationArea = all;
                    Editable = EditableRecord;
                }
                field("Assigned Vehicle"; rec."Assigned Vehicle")
                {
                    ApplicationArea = all;
                    TableRelation = Vehicule.Registration;
                    Editable = EditableRecord;
                }
                field("Status"; rec."Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Number of deliveries"; rec."Number of deliveries")
                {
                    ApplicationArea = all;
                    Editable = EditableRecord;
                }
                field("Total delivery quantity"; rec."Total delivery quantity")
                {
                    ApplicationArea = all;
                    Editable = EditableRecord;
                    DecimalPlaces = 0 : 5;
                }
            }
            
            part("Delivery list"; "Delivery Route Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Round number" = field("Round number");
                Editable = EditableRecord;
            }
            part("Delivery lines"; "Delivery Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Round number" = field("Round number");
                Editable = EditableRecord;
            }
        }
        area(FactBoxes)
        {
            part("Delivery Route FactBox"; "DeliveryRoute FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Round number" = field("Round number");
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select deliveries")
            {
                ApplicationArea = all;
                Caption = 'Select deliveries';
                Image = Delivery;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::"0");
                    rec.SelectDeliveries();
                    CurrPage.Update();
                end;
            }
            action("Validate")
            {
                ApplicationArea = all;
                Caption = 'Validate';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    MissingFields: Text;
                begin
                    MissingFields := '';

                    if rec.Status <> rec.Status::"0" then
                        MissingFields += '- Status must be "0"';
                    if rec."Assigned Vehicle" = '' then
                        MissingFields += '- Assigned Vehicle is required';
                    if rec."No driver" = '' then
                        MissingFields += '- No driver is required';
                    if (rec."Number of deliveries" = 0) then
                        MissingFields += '- Number of deliveries is required';
                    if (rec."Total delivery quantity" = 0) then
                        MissingFields += '- Total delivery quantity is required';

                    if MissingFields = '' then begin
                        rec.Validate(Status, rec.Status::"1");
                        rec.Modify();
                        CurrPage.Update();
                    end else
                        Message('Validation failed:' + MissingFields);
                end;
            }
            action("Cancel")
            {
                ApplicationArea = all;
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = ShowCancelButton;
                trigger OnAction()
                begin
                    if (rec.Status = rec.Status::"1") then begin
                        rec.Validate(Status, rec.Status::"2");
                        rec.Modify();
                        CurrPage.Update();
                    end;
                end;
            }
            action("Reopen")
            {
                ApplicationArea = all;
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = ShowReopenButton;
                trigger OnAction()
                begin
                    if (rec.Status = rec.Status::"1") then begin
                        rec.Validate(Status, rec.Status::"0");
                        rec.Modify();
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }

    var
        EditableRecord: Boolean;
        ShowReopenButton: Boolean;
        ShowCancelButton: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        EditableRecord := (Rec.Status = Rec.Status::"0");
        ShowReopenButton := (Rec.Status = Rec.Status::"1");
        ShowCancelButton := (Rec.Status = Rec.Status::"1");
    end;
}