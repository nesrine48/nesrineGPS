namespace GLOBAL_WINE_PROJECT.GLOBAL_WINE_PROJECT;

page 50105 "Delivery Route Subform"
{
    ApplicationArea = All;
    Caption = 'Delivery Route Subform';
    PageType = ListPart;
    MultipleNewLines = true;
    SourceTable = DeliveryRouteList;
    SourceTableView = sorting("Round number", "line No");
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Round number"; rec."Round number")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Line No."; Rec."Line No")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
                field("Customer No"; rec."Customer No")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Delivery address"; rec."Delivery address")
                {
                    ApplicationArea = all;
                }
                // field("Amount"; rec."Amount")
                // {
                //     ApplicationArea = all;
                // }

                field("GPS Coordinates"; rec."GPS Coordinates")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        URL: Text;
                    begin
                        // Vérifie que les valeurs sont valides
                        if (rec."Latitude" <> 0) and (rec."Longitude" <> 0) then begin
                            URL := 'https://www.google.com/maps?q=' + Format(rec."Latitude") + ',' + Format(rec."Longitude");
                            Hyperlink(URL);
                        end else
                            Message(CordinatesGPS);
                    end;
                }
                field("Status delivery"; rec."Status delivery")
                {
                    ApplicationArea = all;
                }
                field("Comments"; rec."Comments")
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


        }
    }
      var  CordinatesGPS: Label 'GPS coordinates not available.';
}