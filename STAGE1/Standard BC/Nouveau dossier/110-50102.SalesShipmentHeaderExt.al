namespace STAGE.STAGE;

using Microsoft.Sales.History;

tableextension 50102 "Sales Shipment HeaderExt" extends "Sales Shipment Header"
{
    fields
    {
         field(50100; "Round number"; code[20])
        {
            Caption = 'Round number';
            DataClassification = ToBeClassified;
            TableRelation="Delivery route"."Round number";
        }
    }
}
