table 50110 Vehicule
{
    Caption = 'Vehicule';
    DataClassification = ToBeClassified;
     DataCaptionFields = Registration,IMEI;
    LookupPageID = Vehicule;
    
    fields
    {
        field(5; "Last GPS Update"; DateTime)
        {
            Caption = 'Dernière mise à jour GPS';
            Editable = false;
        }
        field(6; "GPS Path"; Blob)
        {
            Caption = 'Historique trajet';
            SubType = Json;
        }
        field(1; "Registration"; code[20])
        {
            Caption = 'Registration';
        }
        field(2; "IMEI"; code[50])
        {
            Caption = 'IMEI';
        }
        field(3; "Latitude"; Decimal)
        {
            Caption = 'Latitude';
            DataClassification = ToBeClassified;
        }

        field(4; "Longitude"; Decimal)
        {
            Caption = 'Longitude';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Registration,IMEI)
        {
            Clustered = true;
        }
    }
}
