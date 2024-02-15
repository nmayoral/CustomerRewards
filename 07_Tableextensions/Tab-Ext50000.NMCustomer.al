tableextension 50000 NMCustomer extends Customer
{
    fields
    {
        field(10001; RewardPoints; Integer)
        {
            Caption = 'Reward Points', Comment = 'Puntos Recompensa';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
