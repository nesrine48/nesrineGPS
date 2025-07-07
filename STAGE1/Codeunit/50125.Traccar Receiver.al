codeunit 50125 "Traccar Receiver"
{
    [ServiceEnabled]
    procedure ReceiveLocation(RequestBody: Text): Text
    var
        Position: Record "Traccar Position Log";
        Json: JsonObject;
        DeviceIdToken, LatToken, LonToken, TimeToken, IMEIToken: JsonToken;
    begin
        if not Json.ReadFrom(RequestBody) then
            Error('❌ JSON invalide');

        Json.Get('deviceId', DeviceIdToken);
        Json.Get('latitude', LatToken);
        Json.Get('longitude', LonToken);
        Json.Get('deviceTime', TimeToken);
        Json.Get('uniqueId', IMEIToken); // facultatif selon config Traccar

        Position.Init();
        Position."Device ID" := DeviceIdToken.AsValue().AsInteger();
        Position.Latitude := LatToken.AsValue().AsDecimal();
        Position.Longitude := LonToken.AsValue().AsDecimal();
        Position."Device Time" := EvaluateDateTime(TimeToken.AsValue().AsText());
        Position.IMEI := IMEIToken.AsValue().AsText();
        Position."Received At" := CurrentDateTime();
        Position.Insert();

        exit('📍 Position enregistrée avec succès.');
    end;

    local procedure EvaluateDateTime(TextVal: Text): DateTime
    var
        Result: DateTime;
    begin
        if not Evaluate(Result, TextVal) then
            exit(0DT);
        exit(Result);
    end;
}
