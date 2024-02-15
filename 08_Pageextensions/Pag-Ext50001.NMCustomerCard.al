pageextension 50001 NMCustomerCard extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(NMRewardLevel; NMRewardLevel)
            {
                ApplicationArea = All;
                Caption = 'Reward Level', Comment = 'Nivel Recompensa';
                Description = 'Reward level of the customer.';
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                Editable = false;
            }

            field(NMRewardPoints; Rec.NMRewardPoints)
            {
                ApplicationArea = All;
                Caption = 'Reward Points', Comment = 'Puntos Recompensa';
                Description = 'Reward points accrued by customer';
                ToolTip = 'Specifies the total number of points that the customer has at this point.';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        NMCustomerRewardsMgtExt: Codeunit NMCustomerRewardsExtMgt;
    begin
        // Get the reward level associated with reward points - Toma el nivel de recompensa asociado con los puntos de recompensa
        NMRewardLevel := NMCustomerRewardsMgtExt.NMGetRewardLevel(Rec.NMRewardPoints);
    end;

    var
        NMRewardLevel: Text;
}