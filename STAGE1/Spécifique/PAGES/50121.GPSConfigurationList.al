page 50121 "GPS Configuration List "
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "GPS Configuration";
    Caption = 'GPS Configuration';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Primary Key"; Rec."Primary Key") { ApplicationArea = All; }
                field(Simulation; Rec.Simulation) { ApplicationArea = All; }
                field("Server URL"; Rec."Server URL") { ApplicationArea = All; }
                field("API Key"; Rec."API Key") { ApplicationArea = All; }
                field("Auth Token"; Rec."Auth Token") { ApplicationArea = All; }
            }
        }
    }
}
