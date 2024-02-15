page 50001 NMRewardsLevelList
{
    PageType = List;
    SourceTable = NMRewardLevel;
    SourceTableView = sorting("Minimum Reward Points") order(ascending);
    Caption = 'Rewards Level List', Comment = 'Lista Recompensa Niveles';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the level of reward that the customer has at this point.';
                }

                field("Minimum Reward Points"; Rec."Minimum Reward Points")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of points that customers must have to reach this level.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        if not CustomerRewardsExtMgt.IsCustomerRewardsActivated then
            Error(NotActivatedTxt);
    end;

    var
        CustomerRewardsExtMgt: Codeunit NMCustomerRewardsExtMgt;
        NotActivatedTxt: Label 'Customer Rewards is not activated';
}