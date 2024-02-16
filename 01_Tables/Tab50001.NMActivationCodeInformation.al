table 50001 NMActivationCodeInformation
{
    Caption = 'Activation Code Information', Comment = 'Información Código Activación';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; NMActivationCode; Text[14])
        {
            Caption = 'Activation Code', Comment = 'Código Activación';
            DataClassification = SystemMetadata;
        }

        field(2; NMDateActivated; Date)
        {
            Caption = 'Date Activated', Comment = 'Fecha Activación';
            DataClassification = SystemMetadata;
        }

        field(3; NMExpirationDate; Date)
        {
            Caption = 'Expiration Date', Comment = 'Fecha Expiración';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; NMActivationCode)
        {
            Clustered = true;
        }
    }
}
