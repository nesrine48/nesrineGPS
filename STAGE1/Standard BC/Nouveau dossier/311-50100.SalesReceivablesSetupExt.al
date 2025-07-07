namespace STAGE.STAGE;

using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50100 "Sales & Receivables SetupExt" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Round number"; code[20])
        {
            Caption = 'Round number';
            DataClassification = ToBeClassified;
            TableRelation="No. Series";
        }
    }
}
