table 50124 "Traccar Position Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "IMEI"; Text[30]) { }
        field(3; "Device ID"; Integer) { }
        field(4; Latitude; Decimal) { }
        field(5; Longitude; Decimal) { }
        field(6; "Device Time"; DateTime) { }
        field(7; "Received At"; DateTime) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
