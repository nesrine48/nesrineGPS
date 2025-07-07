codeunit 50117 "Traccar API"
{
    procedure GetCurrentPosition(IMEI: Text[30]; var Latitude: Decimal; var Longitude: Decimal): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        GPSConfig: Record "GPS Configuration";
        DeviceId: Integer;
    begin
        if not GPSConfig.Get() then
            exit(false);

        if not GetDeviceIdFromIMEI(IMEI, DeviceId) then
            exit(false);

        if not Client.Get(StrSubstNo('%1/api/positions?deviceId=%2', GPSConfig."Server URL", Format(DeviceId)), Response) then
            exit(false);

        if not Response.IsSuccessStatusCode() then
            exit(false);

        Response.Content.ReadAs(JsonText);

        if not JsonArray.ReadFrom(JsonText) or (JsonArray.Count = 0) then
            exit(false);

        JsonArray.Get(0, JsonToken);

        exit(ExtractPositionFromToken(JsonToken, Latitude, Longitude));
    end;

    procedure GetPositionHistory(IMEI: Text[30]): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonArray: JsonArray;
        PathBuilder: TextBuilder;
        PositionToken: JsonToken;
        GPSConfig: Record "GPS Configuration";
        i: Integer;
        DeviceId: Integer;
    begin
        if not GPSConfig.Get() then
            exit('');

        if not GetDeviceIdFromIMEI(IMEI, DeviceId) then
            exit('');

        if not Client.Get(StrSubstNo('%1/api/positions?deviceId=%2&maxResults=20', GPSConfig."Server URL", Format(DeviceId)), Response) then
            exit('');

        if not Response.IsSuccessStatusCode() then
            exit('');

        Response.Content.ReadAs(JsonText);

        if not JsonArray.ReadFrom(JsonText) then
            exit('');

        PathBuilder.Append('[');
        for i := 0 to JsonArray.Count - 1 do begin
            if i > 0 then
                PathBuilder.Append(',');

            JsonArray.Get(i, PositionToken);
            PathBuilder.Append(FormatPosition(PositionToken));
        end;
        PathBuilder.Append(']');
        exit(PathBuilder.ToText());
    end;

    local procedure GetDeviceIdFromIMEI(IMEI: Text[30]; var DeviceId: Integer): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObj: JsonObject;
        UniqueIdToken, IdToken: JsonToken;
        GPSConfig: Record "GPS Configuration";
    begin
        DeviceId := 0;

        if not GPSConfig.Get() then
            exit(false);

        if not Client.Get(GPSConfig."Server URL" + '/api/devices', Response) then
            exit(false);

        if not Response.IsSuccessStatusCode() then
            exit(false);

        Response.Content.ReadAs(JsonText);

        if not JsonArray.ReadFrom(JsonText) then
            exit(false);

        foreach JsonToken in JsonArray do begin
            JsonObj := JsonToken.AsObject();
            if JsonObj.Get('uniqueId', UniqueIdToken) and JsonObj.Get('id', IdToken) then
                if UniqueIdToken.AsValue().AsText() = IMEI then begin
                    DeviceId := IdToken.AsValue().AsInteger();
                    exit(true);
                end;
        end;

        exit(false);
    end;

    local procedure ExtractPositionFromToken(Token: JsonToken; var Latitude: Decimal; var Longitude: Decimal): Boolean
    var
        JsonObj: JsonObject;
        ValueToken: JsonToken;
    begin
        if not Token.IsObject() then
            exit(false);

        JsonObj := Token.AsObject();

        if not JsonObj.Get('latitude', ValueToken) or not ValueToken.IsValue() then
            exit(false);
        Latitude := ValueToken.AsValue().AsDecimal();

        if not JsonObj.Get('longitude', ValueToken) or not ValueToken.IsValue() then
            exit(false);
        Longitude := ValueToken.AsValue().AsDecimal();

        exit(true);
    end;

    local procedure FormatPosition(Token: JsonToken): Text
    var
        JsonObj: JsonObject;
        LatToken, LonToken: JsonToken;
        Lat, Lon: Decimal;
    begin
        if Token.IsObject() then begin
            JsonObj := Token.AsObject();

            if JsonObj.Get('latitude', LatToken) and LatToken.IsValue() then
                Lat := LatToken.AsValue().AsDecimal();

            if JsonObj.Get('longitude', LonToken) and LonToken.IsValue() then
                Lon := LonToken.AsValue().AsDecimal();
        end;

        exit(StrSubstNo('[%1,%2]', Lat, Lon));
    end;
}
