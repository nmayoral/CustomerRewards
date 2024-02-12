table 50000 NMRewardLevel
{
    Caption = 'Reward Level', Comment = 'Nivel recompensa';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Level; Text[20])
        {
            Caption = 'Level', Comment = 'Nivel';
            DataClassification = CustomerContent;
        }

        field(2; "Minimum Reward Points"; Integer)
        {
            Caption = 'Minimum Reward Points', Comment = 'Puntos mínimos recompensa';
            DataClassification = CustomerContent;
            MinValue = 0;
            NotBlank = true;

            trigger OnValidate();
            var
                RewardLevel: Record NMRewardLevel;
                tempPoints: Integer;
            begin
                tempPoints := "Minimum Reward Points";
                RewardLevel.SetRange("Minimum Reward Points", tempPoints);
                if not RewardLevel.IsEmpty() then
                    Error('Minimum Reward Points must be unique');
            end;
        }
    }

    keys
    {
        key(PK; Level)
        {
            Clustered = true;
        }
        key("Minimum Reward Points"; "Minimum Reward Points") { }
    }

    trigger OnInsert();
    begin

        Validate("Minimum Reward Points");
    end;

    trigger OnModify();
    begin
        Validate("Minimum Reward Points");
    end;
}