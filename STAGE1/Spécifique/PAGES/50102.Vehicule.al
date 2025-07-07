page 50102 "Vehicule"
{
   ApplicationArea = All;
    Caption = 'Vehicule';
    PageType = List;
    SourceTable = Vehicule;
     UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;
    
     layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Registration; Rec.Registration)
                {
                    ApplicationArea = All;
                }
                field(IMEI; Rec.IMEI)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
        
         }
     }
}
