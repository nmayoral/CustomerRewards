tableextension 50000 NMCustomer extends Customer
{
    fields
    {
        field(10001; NMRewardPoints; Integer)
        {
            Caption = 'Reward Points', Comment = 'Puntos Recompensa';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
