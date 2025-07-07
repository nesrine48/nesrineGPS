namespace GLOBAL_WINE_PROJECT.GLOBAL_WINE_PROJECT;

page 50103 DeliveryRouteList
{
    ApplicationArea = All;
    Caption = 'Delivery Route List';
    CardPageID = "Delivery Route Card";
    DataCaptionFields = "Round number";
    Editable = false;
    PageType = List;
    QueryCategory = 'Delivery Route list';
    RefreshOnActivate = true;
    SourceTable = "Delivery route";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Round number"; rec."Round number")
                {
                    ApplicationArea = all;
                }
                field("Delivery date"; rec."Delivery date")
                {
                    ApplicationArea = all;
                }
                field("Name driver"; rec."Name driver")
                {
                    ApplicationArea = all;
                }
                field("Assigned Vehicle"; rec."Assigned Vehicle")
                {
                    ApplicationArea = all;
                }
                field("Status"; rec."Status")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
