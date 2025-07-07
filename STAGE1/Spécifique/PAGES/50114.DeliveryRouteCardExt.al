pageextension 50114 "Delivery Route Card Ext" extends "Delivery Route Card"
{
    layout
    {
        addlast(General)
        {
            field(IMEI; Rec.IMEI)
            {
                ApplicationArea = All;
                ToolTip = 'Numéro IMEI du GPS/GPRS du véhicule';
            }
          
        }
    }
}