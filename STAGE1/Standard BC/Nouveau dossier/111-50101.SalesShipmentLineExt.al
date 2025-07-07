namespace STAGE.STAGE;

using Microsoft.Sales.History;
using Microsoft.Sales.Customer;

tableextension 50101 "Sales Shipment LineExt" extends "Sales Shipment Line"
{
    fields
    {
         field(50100; "Round number"; code[20])
        {
            Caption = 'Round number';
            DataClassification = ToBeClassified;
            TableRelation="Delivery route"."Round number";
        }
         field(50101; "Customer name"; text[250])
        {
            Caption = 'Round number';
           Editable=false;
           FieldClass=FlowField;
           CalcFormula=lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }
    }
}
