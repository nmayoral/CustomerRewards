table 50000 NMRewardLevel
{
    Caption = 'Reward Level', Comment = 'Nivel Recompensa';
    DataClassification = CustomerContent;

    fields
    {
        field(1; NMLevel; Text[20])
        {
            Caption = 'Level', Comment = 'Nivel';
            DataClassification = CustomerContent;
        }

        field(2; NMMinimumRewardPoints; Integer)
        {
            Caption = 'Minimum Reward Points', Comment = 'Puntos Mínimos Recompensa';
            DataClassification = CustomerContent;
            MinValue = 0;
            NotBlank = true;

            trigger OnValidate();
            var
                NMRewardLevel: Record NMRewardLevel;
                NMtempPoints: Integer;
                NMMinNotUniqueText: Label 'Minimum Reward Points must be unique', Comment = 'Puntos Mínimos Recompensa debe ser único';
            begin
                NMtempPoints := NMMinimumRewardPoints;
                NMRewardLevel.SetRange(NMMinimumRewardPoints, NMtempPoints);
                if not NMRewardLevel.IsEmpty() then
                    Error(NMMinNotUniqueText);
            end;
        }
    }

    keys
    {
        key(PK; NMLevel)
        {
            Clustered = true;
        }
        key("Minimum Reward Points"; NMMinimumRewardPoints) { }
    }

    trigger OnInsert();
    begin

        Validate(NMMinimumRewardPoints);
    end;

    trigger OnModify();
    begin
        Validate(NMMinimumRewardPoints);
    end;
}