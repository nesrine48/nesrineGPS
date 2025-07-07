tableextension 50113 "GPS-Server Sales Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
    
    
        field(50101; "GPS-Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "GPS-Server Url"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "GPS-Server User Key"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Speed Limit"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "GPS-Server Auto Refresh Rate"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "GPS-Server Proxy"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}