table 50108 "Delivery route"
{
    Caption = 'Delivery route';
    DataClassification = ToBeClassified;
    Permissions = tabledata "Sales Shipment Header" = M, tabledata "Sales Shipment Line" = M;
    fields
    {
        field(50000; "Round number"; Code[20])
        {
            Caption = 'Round number';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "Round number" = '' then begin
                    SalesSetup.GET;
                    SalesSetup.TestField("Round number");
                    NoSeriesMgt.InitSeries(SalesSetup."Round number", xRec."Round number", 0D, "Round number", "Series No.");
                end;
            end;


        }
        field(50001; "Delivery date"; Date)
        {
            Caption = 'Delivery date';
        }
        field(50002; "No driver"; code[20])
        {
            Caption = 'No driver';
        }
        field(50003; "Name driver"; Text[250])
        {
            Caption = 'Name driver';
            Editable = false;
        }
        field(50004; "Assigned Vehicle"; Code[20])
        {
            Caption = 'Assigned Vehicle';
        }
        field(50005; "Status"; enum "Status delivery card")
        {
            Caption = 'Status';

        }
        field(50006; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50007; "Series No."; Code[50])
        {
            TableRelation = "No. Series";
        }
        field(50008; "Number of deliveries"; integer)
        {
            caption = 'Number of deliveries';
            CalcFormula = count(DeliveryRouteList where("Round number" = field("Round number")));
            FieldClass = flowfield;
        }
        field(50009; "Total delivery quantity"; Decimal)
        {
            caption = 'Total delivery quantity';
            CalcFormula = sum("Sales Shipment Line".Quantity where("Round number" = field("Round number")));
            FieldClass = flowfield;
        }
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50110; IMEI; Text[30])
        {
            Caption = 'IMEI';
            DataClassification = ToBeClassified;
            NotBlank = true;
            trigger OnValidate()
            var
                LocationHelper: Codeunit "Vehicle Location Helper";
                Lat: Decimal;
                Lon: Decimal;
                Path: Text;
            begin
                if LocationHelper.GetVehicleLocation(IMEI,Lat,Lon,Path) then begin
                    Rec.Latitude := Lat;
                    Rec.Longitude := Lon;
                    Rec."GPS-Path" := Path;
                end else begin 
                    Message('Aucune localisation trouvée pour cet IMEI.');
                end;
            end;
        }
        
        field(60000; Latitude; Decimal)
        {
            Caption = 'Latitude';
            DecimalPlaces = 0:6;
        }
        field(60001; Longitude; Decimal)
        {
            Caption = 'Longitude';
            DecimalPlaces = 0:6;
        }
        field(60002; "GPS-Path"; Text[250])
        {
            Caption = 'GPS-Path';
            DataClassification = ToBeClassified;
        }
        field(60003; "GPS Path"; Text[2048])
        {
            Caption = 'Historique GPS';
            DataClassification = CustomerContent;
        }
       
    }
    keys
    {
        key(PK; "Round number")
        {
            Clustered = true;
        }
    }
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "Round number" = '' then begin
            SalesSetup.GET;
            SalesSetup.TestField("Round number");
            NoSeriesMgt.InitSeries(SalesSetup."Round number", xRec."Series No.", 0D, "Round number", "Series No.");
        end;

        Rec."Delivery date" := WorkDate();
        // Rec."No driver" := UserId;
    end;

    procedure SelectDeliveries()
    var
        SalesShipHeader: Record "Sales Shipment Header";
        SalesShipHeaderToSelect: Record "Sales Shipment Header";
        salesShipLignes: record "Sales Shipment Line";
        DeliveryRouteList: record DeliveryRouteList;
        DeliveryRouteVerif: record DeliveryRouteList;
        DeliveryList: page "Get shipement lignes";
        SalesShipmentLine: Record "Sales Shipment Line";
        lineNo: Integer;
    begin
        SalesShipHeaderToSelect.Reset();
        SalesShipHeaderToSelect.SetFilter("Round number", '%1 | %2', '', Rec."Round number");
        DeliveryList.SetTableView(SalesShipHeaderToSelect);
        DeliveryList.LookupMode(true);
        if DeliveryList.RunModal() = Action::LookupOK then begin
            lineNo := 10000;
            //Filtres
            DeliveryList.SetSelectionFilter(SalesShipHeader);
            // SalesShipHeader.Reset();
            // SalesShipHeader.SetRange("To be delivered", true);
            //Insert client
            if SalesShipHeader.FindSet() then
                repeat
                    DeliveryRouteVerif.Reset();
                    DeliveryRouteVerif.SetRange("Round number", Rec."Round number");
                    DeliveryRouteVerif.SetRange("Customer No", SalesShipHeader."Sell-to Customer No.");
                    if not DeliveryRouteVerif.FindFirst() then begin
                        DeliveryRouteList.Init();
                        DeliveryRouteList."Round number" := Rec."Round number";
                        DeliveryRouteList."Line No" := GetLastNo();
                        DeliveryRouteList.Insert(true);
                        DeliveryRouteList.Validate("Customer No", SalesShipHeader."Sell-to Customer No.");
                        DeliveryRouteList.Modify(true);
                    end;
                    SalesShipHeader."Round number" := Rec."Round number";
                    SalesShipHeader.Modify();

                    SalesShipmentLine.Reset();
                    SalesShipmentLine.SetRange("Document No.", SalesShipHeader."No.");
                    SalesShipmentLine.ModifyAll("Round number", Rec."Round number");

                until SalesShipHeader.Next() = 0;
            //lignes livraisons

        end;

        // DeliveryList.SetTableView(SalesShipHeader);
        // DeliveryList.RunModal();
    end;

    procedure ClearSelection(SalesShipHeader_P: Record "Sales Shipment Header")
    var
        DeliveryList: page "Get shipement lignes";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesShipHeaderVerif: Record "Sales Shipment Header";
        DeliveryRouteList: Record DeliveryRouteList;
    BEGIN

        //BLs de client et tournée //sauf sal
        SalesShipHeaderVerif.Reset();
        SalesShipHeaderVerif.SetFilter("No.", '<>%1', SalesShipHeader_P."No.");
        SalesShipHeaderVerif.SetRange("Round number", SalesShipHeader_P."Round number");
        SalesShipHeaderVerif.SetRange("Sell-to Customer No.", SalesShipHeader_P."Sell-to Customer No.");
        if not SalesShipHeaderVerif.FindFirst() then begin
            DeliveryRouteList.Reset();
            DeliveryRouteList.SetRange("Round number", SalesShipHeader_P."Round number");
            DeliveryRouteList.SetRange("Customer No", SalesShipHeader_P."Sell-to Customer No.");
            if DeliveryRouteList.FindFirst() then begin
                DeliveryRouteList.Delete();
            end;


        end;

        SalesShipHeader_P."Round number" := '';
        SalesShipHeader_P.Modify();

        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", SalesShipHeader_P."No.");
        SalesShipmentLine.ModifyAll("Round number", '');

    END;


    procedure GetLastNo(): Integer
    var
        DeliveryRoute: Record "DeliveryRouteList";
    begin
        DeliveryRoute.Reset();
        DeliveryRoute.SetRange("Round number", Rec."Round number");
        if DeliveryRoute.FindLast() then
            exit(DeliveryRoute."line No" + 10000)
        else
            exit(10000);
    end;
    




}
