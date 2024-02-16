pageextension 50000 NMCustomerList extends "Customer List"
{
    actions
    {
        addfirst("&Customer")
        {
            action("Reward Levels")
            {
                Caption = 'Reward Levels', Comment = 'Niveles Recompensa';
                ApplicationArea = All;
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the list of reward levels', Comment = 'Abre la lista de niveles recompensa';

                trigger OnAction();
                var
                    NMCustomerRewardsExtMgt: Codeunit NMCustomerRewardsExtMgt;
                begin
                    if NMCustomerRewardsExtMgt.NMIsCustomerRewardsActivated then
                        NMCustomerRewardsExtMgt.NMOpenRewardsLevelPage
                    else
                        NMCustomerRewardsExtMgt.NMOpenCustomerRewardsWizard;
                end;
            }
        }
    }
}
