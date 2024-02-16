table 50002 NMCustomerRewardsMgtSetup
{
    Caption = 'Customer Rewards Mgt. Setup', Comment = 'Configuración Recompensas Cliente';
    DataClassification = CustomerContent;

    fields
    {
        field(1; NMPrimaryKey; Code[10])
        {
            Caption = 'Primary Key', Comment = 'Clave Primaria';
            DataClassification = CustomerContent;
        }

        field(2; NMCustRewExtMgtCUID; Integer)
        {
            Caption = 'Customer Rewards Ext. Mgt. Codeunit ID', Comment = 'ID Codeunit Recompensas Cliente';
            DataClassification = CustomerContent;
            TableRelation = "CodeUnit Metadata".ID;
        }
    }

    keys
    {
        key(PK; NMPrimaryKey)
        {
            Clustered = true;
        }
    }
}
