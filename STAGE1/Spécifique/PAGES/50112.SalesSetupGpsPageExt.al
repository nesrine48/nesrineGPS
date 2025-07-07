pageextension 50112 "GPS-Server Sales Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(Content)
        {
            group("GPS-Server") // Ceci crée un nouvel onglet/section
            {
                Caption = 'GPS-Server';

                field("GPS-Server Url"; Rec."GPS-Server Url")
                {
                    ApplicationArea = All;
                    ToolTip = 'Spécifie l''URL du GPS-Server';
                }
                field("GPS-Server User Key"; Rec."GPS-Server User Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clé utilisateur pour l''authentification GPS-Server';
                }
                field("Speed Limit"; Rec."Speed Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Limite de vitesse en km/h';
                }
                field("GPS-Server Auto Refresh Rate"; Rec."GPS-Server Auto Refresh Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Taux de rafraîchissement automatique en ms (min. 10000)';
                }
                field("GPS-Server Proxy"; Rec."GPS-Server Proxy")
                {
                    ApplicationArea = All;
                    ToolTip = 'URL du proxy pour le GPS-Server';
                }
            }
        }
    }
}