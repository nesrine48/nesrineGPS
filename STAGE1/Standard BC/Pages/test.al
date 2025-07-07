pageextension 50110 "Sales & Receivables Setup" extends "Sales & Receivables Setup"//459
{
    layout
    {
        addafter("Posted Shipment Nos.")
        {
            field("Round number"; Rec."Round number")
            {
                ApplicationArea = All;
               // ToolTip = 'Specifies the value of the Round number field.', Comment = '%';
            }
        }
    }
}