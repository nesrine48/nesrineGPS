codeunit 50123 "Get Traccar Connector"
{
    procedure GetTrackerPosition()
    var
    Client: HttpClient;
    Request: HttpRequestMessage;
    Response: HttpResponseMessage;
    Headers: HttpHeaders;
    ResponseText: Text;
begin
    Request.SetRequestUri('http://localhost:8082/api/devices');
    Request.Method := 'GET';

    Request.GetHeaders(Headers); // ← passage par référence obligatoire
    Headers.Add('Authorization', 'Basic bmVzcmluZWFtbWFyNDhAZ21haWwuY29tOk5zbW4xNDA3');

    Client.Send(Request, Response);
    if Response.IsSuccessStatusCode() then begin
        Response.Content().ReadAs(ResponseText);
        Message('📦 Réponse Traccar : %1', ResponseText);
    end else
        Message('❌ Erreur : %1 %2', Response.HttpStatusCode(), Response.ReasonPhrase());
end;


}
