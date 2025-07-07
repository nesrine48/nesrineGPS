page 50111 "DeliveryRoute FactBox"
{
    PageType = CardPart;
    SourceTable = "Delivery route";
    Caption = 'Delivery Summary';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Résumé Livraison")
            {
                field("Number of deliveries"; Rec."Number of deliveries")
                {
                    ApplicationArea = All;
                }

                field("Total delivery quantity"; Rec."Total delivery quantity")
                {
                    ApplicationArea = All;
                }
            }

            group("Carte de livraison")
            {
                usercontrol(Map; VehicleMapControl)
                {
                    ApplicationArea = All;
                }
            }

            group("Dernière position")
            {
                Visible = false; // 👈 ça masque complètement le groupe, peu importe les valeurs
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }
    }

    actions
    {
        area(processing)
        {
            action(LocateVehicle)
            {
                Caption = '🚗 Localiser Chauffeur';
                Image = Map;
                ApplicationArea = All;

                trigger OnAction()
                var
                    GPSConfig: Record "GPS Configuration";
                    LocHelper: Codeunit "Vehicle Location Helper";
                    Lat, Lon: Decimal;
                    Path: Text;
                begin
                    if not GPSConfig.Get('CFG') then
                        Error('Configuration GPS manquante.');

                    if Rec.IMEI = '' then
                        Error('IMEI manquant. Impossible de localiser le chauffeur.');

                    if GPSConfig.Simulation then begin
                        Lat := 36.8065;
                        Lon := 10.1815;
                        Path := '[ [36.8065,10.1815], [36.807,10.182], [36.808,10.183] ]';
                    end else begin
                        if not LocHelper.GetVehicleLocation(Rec.IMEI, Lat, Lon, Path) then
                             Error('❌ Traccar n’a rien renvoyé pour IMEI %1', Rec.IMEI);

                        Message('🛰️ Coordonnées Traccar : %1 / %2', Lat, Lon);
                        Path := '';
                        if (Lat = 0) and (Lon = 0) then
                            Error('⚠️ Coordonnées invalides : 0 / 0');

                    end;

                    Rec.Latitude := Lat;
                    Rec.Longitude := Lon;
                    Rec."GPS Path" := Path;
                    if not Rec.Modify(false) then
                        Error('Échec de la mise à jour du record.');

                    // 🔄 Affiche les valeurs enregistrées
                    Message('🔄 Valeurs stockées : %1 / %2', Rec.Latitude, Rec.Longitude);

                    CurrPage.Map.SetCoordinates(Lat, Lon);
                    CurrPage.Map.SetZoom(45);
                    CurrPage.Map.SetPinLabel('🚗'); // Ou '🚗 ' + Rec."Driver Name" si tu veux un nom

                    if Path <> '' then
                        CurrPage.Map.SetPath(Path);

                    Message('📍 Position envoyée à la carte : %1 / %2', Lat, Lon);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateMap();
    end;

    local procedure UpdateMap()
    var
        GPSConfig: Record "GPS Configuration";
    begin
        if Rec.Latitude <> 0 then begin
            CurrPage.Map.SetCoordinates(Rec.Latitude, Rec.Longitude);
            CurrPage.Map.SetZoom(18);
            CurrPage.Map.SetPinLabel('🚗');
        end;

        if GPSConfig.Get('CFG') and GPSConfig.Simulation then
            CurrPage.Map.SetPath(Rec."GPS Path")
        else
            CurrPage.Map.SetPath('');
    end;
}
