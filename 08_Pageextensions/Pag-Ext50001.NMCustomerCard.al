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
                ToolTip = 'Specifies the level of reward that the customer has at this point', Comment = 'Especifica el nivel de recompensa que tiene el cliente en este momento';
                Editable = false;
            }

            field(NMRewardPoints; Rec.NMRewardPoints)
            {
                ApplicationArea = All;
                Caption = 'Reward Points', Comment = 'Puntos Recompensa';
                ToolTip = 'Specifies the total number of points that the customer has at this point', Comment = 'Especifica el número total de puntos que tiene el cliente en este momento';
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