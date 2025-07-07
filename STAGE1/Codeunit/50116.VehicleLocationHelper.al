codeunit 50116 "Vehicle Location Helper"
{
    procedure GetVehicleLocation(IMEI: Text[30]; var Latitude: Decimal; var Longitude: Decimal; var GpsPath: Text): Boolean
    var
        GPSConfig: Record "GPS Configuration";
    begin
        if not GPSConfig.Get() then
            exit(false);

        if GPSConfig.Simulation then
            exit(GetSimulatedLocation(IMEI, Latitude, Longitude, GpsPath))
        else
            exit(GetRealLocation(IMEI, Latitude, Longitude, GpsPath));
    end;

    local procedure GetRealLocation(IMEI: Text[30]; var Latitude: Decimal; var Longitude: Decimal; var GpsPath: Text): Boolean
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseText: Text;
        DeviceId: Integer;
        BestTime: DateTime;
        TempTimeToken, TempLatToken, TempLonToken: JsonToken;
        TempLat, TempLon: Decimal;
        TempDateTime: DateTime;
        Found: Boolean;
    begin
        if not GetDeviceIdFromIMEI(IMEI, DeviceId) then
            exit(false);

        if not SendAuthenticatedGetRequest(StrSubstNo('%1/api/positions?deviceId=%2', GetServerURL(), DeviceId), ResponseText) then
            exit(false);

        if not JsonArray.ReadFrom(ResponseText) or (JsonArray.Count = 0) then
            exit(false);

        BestTime := 0DT;
        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();
            if JsonObject.Get('deviceTime', TempTimeToken) and
               JsonObject.Get('latitude', TempLatToken) and
               JsonObject.Get('longitude', TempLonToken)
            then begin
                if TryConvertToDateTime(TempTimeToken.AsValue().AsText(), TempDateTime) and (TempDateTime > BestTime) then begin
                    BestTime := TempDateTime;
                    TempLat := TempLatToken.AsValue().AsDecimal();
                    TempLon := TempLonToken.AsValue().AsDecimal();
                    Found := true;
                end;
            end;
        end;

        if not Found then
            exit(false);

        Latitude := TempLat;
        Longitude := TempLon;
        GpsPath := GetPositionHistory(DeviceId);
        exit(true);
    end;

    local procedure GetSimulatedLocation(IMEI: Text[30]; var Latitude: Decimal; var Longitude: Decimal; var GpsPath: Text): Boolean
    begin
        Latitude := 36.8 + (Random(200) - 100) / 1000;
        Longitude := 10.1 + (Random(200) - 100) / 1000;
        GpsPath := GenerateSimulatedPath(Latitude, Longitude);
        exit(true);
    end;

    local procedure GenerateSimulatedPath(CenterLat: Decimal; CenterLon: Decimal): Text
    var
        PathBuilder: TextBuilder;
        i: Integer;
    begin
        PathBuilder.Append('[');
        for i := 0 to 9 do begin
            if i > 0 then
                PathBuilder.Append(',');
            PathBuilder.Append(StrSubstNo(
                '[%1,%2]',
                Format(CenterLat + (Random(100) - 50) / 10000, 0, 6),
                Format(CenterLon + (Random(100) - 50) / 10000, 0, 6)
            ));
        end;
        PathBuilder.Append(']');
        exit(PathBuilder.ToText());
    end;

    local procedure GetDeviceIdFromIMEI(IMEI: Text[30]; var DeviceId: Integer): Boolean
    var
        DevicesJson: Text;
        DevicesArray: JsonArray;
        Token: JsonToken;
        Obj: JsonObject;
        UniqueIdToken, IdToken: JsonToken;
    begin
        DeviceId := 0;

        if not SendAuthenticatedGetRequest(StrSubstNo('%1/api/devices', GetServerURL()), DevicesJson) then
            exit(false);

        if not DevicesArray.ReadFrom(DevicesJson) then
            exit(false);

        foreach Token in DevicesArray do begin
            Obj := Token.AsObject();
            if Obj.Get('uniqueId', UniqueIdToken) and Obj.Get('id', IdToken) then
                if UniqueIdToken.AsValue().AsText() = IMEI then begin
                    DeviceId := IdToken.AsValue().AsInteger();
                    exit(true);
                end;
        end;

        exit(false);
    end;

    local procedure GetPositionHistory(DeviceId: Integer): Text
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        PathBuilder: TextBuilder;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i: Integer;
    begin
        if not SendAuthenticatedGetRequest(StrSubstNo('%1/api/positions?deviceId=%2&maxResults=20', GetServerURL(), DeviceId), ResponseText) then
            exit('');

        if not JsonArray.ReadFrom(ResponseText) then
            exit('');

        PathBuilder.Append('[');
        for i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject();

            if i > 0 then PathBuilder.Append(',');

            PathBuilder.Append(StrSubstNo(
                '[%1,%2]',
                GetJsonValue(JsonObject, 'latitude'),
                GetJsonValue(JsonObject, 'longitude')
            ));
        end;
        PathBuilder.Append(']');
        exit(PathBuilder.ToText());
    end;

    local procedure GetJsonValue(JsonObject: JsonObject; PropertyName: Text): Decimal
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JsonToken) then
            exit(JsonToken.AsValue().AsDecimal());
        exit(0);
    end;

    local procedure SendAuthenticatedGetRequest(URL: Text; var ResponseText: Text): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Config: Record "GPS Configuration";
        AuthToken: Text;
    begin
        if not Config.Get('CFG') then
            exit(false);

        AuthToken := Config."Auth Token";
        Request.SetRequestUri(URL);
        Request.Method := 'GET';
        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Basic ' + AuthToken);

        Client.Send(Request, Response);
        if not Response.IsSuccessStatusCode() then
            exit(false);

        Response.Content.ReadAs(ResponseText);
        exit(true);
    end;

    local procedure GetServerURL(): Text
    var
        Config: Record "GPS Configuration";
    begin
        if Config.Get('CFG') then
            exit(Config."Server URL");
        exit('');
    end;

    local procedure TryConvertToDateTime(InputText: Text; var Result: DateTime): Boolean
    begin
        exit(Evaluate(Result, InputText));
    end;
}
