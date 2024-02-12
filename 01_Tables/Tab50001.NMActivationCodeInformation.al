table 50001 NMActivationCodeInformation
{
    Caption = 'Activation Code Information', Comment = 'Información Activación Código';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; ActivationCode; Text[14])
        {
            Caption = 'Activation Code', Comment = 'Código Activación';
            DataClassification = SystemMetadata;
            Description = 'Activation code used to activate Customer Rewards';
        }

        field(2; "Date Activated"; Date)
        {
            Caption = 'Date Activated', Comment = 'Fecha Activación';
            DataClassification = SystemMetadata;
            Description = 'Date Customer Rewards was activated';
        }

        field(3; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date', Comment = 'Fecha Expiración';
            DataClassification = SystemMetadata;
            Description = 'Date Customer Rewards activation expires';
        }
    }

    keys
    {
        key(PK; ActivationCode)
        {
            Clustered = true;
        }
    }
}
