page 50122 "Test GPS Config "
{
    PageType = Card;
    SourceTable = Customer;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(Name; Rec.Name) { ApplicationArea = All; }
            }
        }
    }
}
