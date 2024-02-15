page 50001 NMRewardsLevelList
{
    PageType = List;
    SourceTable = NMRewardLevel;
    SourceTableView = sorting(NMMinimumRewardPoints) order(ascending);
    Caption = 'Rewards Level List', Comment = 'Lista Recompensa Niveles';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(NMLevel; Rec.NMLevel)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the level of reward that the customer has at this point.';
                }

                field(NMMinimumRewardPoints; Rec.NMMinimumRewardPoints)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of points that customers must have to reach this level.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        if not NMCustomerRewardsExtMgt.NMIsCustomerRewardsActivated then
            Error(NMNotActivatedTxt);
    end;

    var
        NMCustomerRewardsExtMgt: Codeunit NMCustomerRewardsExtMgt;
        NMNotActivatedTxt: Label 'Customer Rewards is not activated', Comment = 'Recompensas Cliente no está activado';
}