
    controladdin VehicleMapControl
{
    RequestedHeight = 400;
    RequestedWidth = 200;
    HorizontalStretch = true;
    VerticalStretch = true;
    StartupScript = 'VehicleMapControl/vehicleMap.js';
    Scripts = 
        'VehicleMapControl/vehicleMap.js',
        'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    StyleSheets = 
        'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
    Images = 'VehicleMapControl/car-red-96x96.png';

    procedure SetCoordinates(Latitude: Decimal; Longitude: Decimal);
    procedure SetPath(Path: Text); // Pour envoyer le trajet (liste de points GPS)
    procedure SetZoom(Level: Integer);
    procedure SetPinLabel(LabelText: Text);


    event OnSetLatitude(Latitude: Decimal);
    event OnSetLongitude(Longitude: Decimal);
}
    

