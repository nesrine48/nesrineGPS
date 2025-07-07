table 50109 DeliveryRouteList
{
    Caption = 'Delivery Route List';
    DataClassification = ToBeClassified;

    fields
    {
        field(50000; "Round number"; code[20])
        {
            TableRelation = "Delivery route"."Round number";
        }
        field(50001; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(50002; "Customer No"; code[20])
        {
            Caption = 'Customer No';
            TableRelation = Customer."No.";
        }
        field(50003; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No")));
        }
        field(50004; "Delivery address"; Text[250])
        {
            Caption = 'Delivery address';

        }
        field(50005; "Amount"; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Shipment Line"."VAT Base Amount" where("Round number" = field("Round number")));
        }
        field(50006; "GPS Coordinates"; Text[100])
        {
            Caption = 'GPS Coordinates';
            Editable = false;
            trigger OnLookup()
            begin
                Message('GPS coordinates: %1', Format("Latitude") + ',' + Format("Longitude"));
            end;

        }
        field(50007; "Latitude"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Latitude';
        }

        field(50008; "Longitude"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Longitude';
        }
        field(50009; "Status delivery"; Enum "Status delivery")
        {
            Caption = 'Status delivery';
        }
        field(50011; "Comments"; Text[500])
        {
            Caption = 'Comments';
        }

    }

    keys
    {
        key(PK; "Round number", "line No")
        {
            Clustered = true;
        }
    }

}
