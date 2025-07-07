table 50120 "GPS Configuration"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "API Key"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
        field(3; Simulation; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Server URL"; Text[250])
        {
            Caption = 'Traccar Server URL';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Auth Token"; Text[200])
        {
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}