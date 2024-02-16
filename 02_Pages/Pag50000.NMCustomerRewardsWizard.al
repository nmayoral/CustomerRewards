page 50000 NMCustomerRewardsWizard
{
    PageType = NavigatePage;
    Caption = 'Customer Rewards assisted setup guide', Comment = 'Guía instalación asistida Recompensas Cliente';

    layout
    {
        area(content)
        {
            group(MediaStandard)
            {
                Caption = '';
                Editable = false;
                Visible = NMTopBannerVisible;

                field(NMMediaReference; NMMediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(FirstPage)
            {
                Caption = '';
                Visible = NMFirstPageVisible;

                group(Welcome)
                {
                    Caption = 'Welcome', Comment = 'Bienvenido';
                    Visible = NMFirstPageVisible;

                    group(Introduction)
                    {
                        Caption = '';
                        InstructionalText = 'This Customer Rewards extension adds rewards tiers support for Customers', Comment = 'Esta extensión Recompensas Cliente agrega compatibilidad con niveles de recompensas para los Clientes';
                        Visible = NMFirstPageVisible;

                        field(NMSpacer1; '')
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }
                    }

                    group(Terms)
                    {
                        Caption = 'Terms of Use', Comment = 'Términos de Uso';
                        Visible = NMFirstPageVisible;

                        group(Terms1)
                        {
                            Caption = '';
                            InstructionalText = 'By enabling the Customer Rewards extension...', Comment = 'Al habilitar la extensión Recompensas Cliente...';
                            Visible = NMFirstPageVisible;
                        }
                    }

                    group(Terms2)
                    {
                        Caption = '';

                        field(NMEnableFeature; NMEnableCustomerRewards)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Editable = true;
                            Caption = 'I understand and accept these terms', Comment = 'He entendido y acepto estos términos';
                            ToolTip = 'Click to confirm: I understand and accept these terms', Comment = 'Pincha para confirmar: ';

                            trigger OnValidate();
                            begin
                                NMShowFirstPage();
                            end;
                        }
                    }
                }
            }

            group(SecondPage)
            {
                Caption = '';
                Visible = NMSecondPageVisible;

                group(Activation)
                {
                    Caption = 'Activation', Comment = 'Activación';
                    Visible = NMSecondPageVisible;

                    field(NMSpacer2; '')
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    group(ActivationMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Enter your 14 digit activation code to continue', Comment = 'Introduce los 14 dígitos del código de activación para continuar';
                        Visible = NMSecondPageVisible;

                        field(NMActivationcode; NMActivationCode)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = true;
                        }
                    }
                }
            }

            group(FinalPage)
            {
                Caption = '';
                Visible = NMFinalPageVisible;

                group(ActivationDone)
                {
                    Caption = 'You are done!', Comment = '¡Lo lograste!';
                    Visible = NMFinalPageVisible;

                    group(DoneMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Click Finish to set up your rewards level and start using Customer Rewards', Comment = 'Haga clic en Finalizar para configurar su nivel de recompensas y comenzar a usar Recompensas Cliente';
                        Visible = NMFinalPageVisible;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back', Comment = 'Atrás';
                Enabled = NMBackEnabled;
                Visible = NMBackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NMNextStep(true);
                end;
            }

            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next', Comment = 'Siguiente';
                Enabled = NMNextEnabled;
                Visible = NMNextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NMNextStep(false);
                end;
            }

            action(ActionActivate)
            {
                ApplicationArea = All;
                Caption = 'Activate', Comment = 'Activar';
                Enabled = NMActivateEnabled;
                Visible = NMActivateEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                var
                    NMCustomerRewardsExtMgt: Codeunit NMCustomerRewardsExtMgt;
                    NMActivationCodeIsBlankText: Label 'Activation code cannot be blank', Comment = 'Código Activación no puede estar vacío';
                    NMActivationCodeNot14Text: Label 'Activation code must have 14 digits', Comment = 'Código Activación debe tener 14 dígitos';
                    NMActivationCodeFailed: Label 'Activation failed. Please check the activation code you entered', Comment = 'Activación fallida. Por favor, comprueba el Código Activación que has introducido';
                begin
                    if NMActivationCode = '' then
                        Error(NMActivationCodeIsBlankText);

                    if Text.StrLen(NMActivationCode) <> 14 then
                        Error(NMActivationCodeNot14Text);

                    if NMCustomerRewardsExtMgt.NMActivateCustomerRewards(NMActivationCode) then
                        NMNextStep(false)
                    else
                        Error(NMActivationCodeFailed);
                end;
            }

            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish', Comment = 'Finalizar';
                Enabled = NMFinalPageVisible;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NMFinishAndEnableCustomerRewards();
                end;
            }
        }
    }

    trigger OnInit();
    begin
        NMLoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        NMStep := NMStep::First;
        NMEnableControls();
    end;

    local procedure NMEnableControls();
    begin
        NMResetControls();

        case NMStep of
            NMStep::First:
                NMShowFirstPage();

            NMStep::Second:
                NMShowSecondPage();

            NMStep::Finish:
                NMShowFinalPage();
        end;
    end;

    local procedure NMNextStep(NMBackwards: Boolean);
    begin
        if NMBackwards then
            NMStep := NMStep - 1
        ELSE
            NMStep := NMStep + 1;
        NMEnableControls();
    end;

    local procedure NMFinishAndEnableCustomerRewards();
    var
        NMCustomerRewardsExtMgt: Codeunit NMCustomerRewardsExtMgt;
        NMGuidedExperience: Codeunit "Guided Experience";
        NMInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(NMInfo);
        NMGuidedExperience.CompleteAssistedSetup(ObjectType::Page, PAGE::NMCustomerRewardsWizard);
        CurrPage.Close();
        NMCustomerRewardsExtMgt.NMOpenRewardsLevelPage();
    end;

    local procedure NMShowFirstPage();
    begin
        NMFirstPageVisible := true;
        NMSecondPageVisible := false;
        NMFinishEnabled := false;
        NMBackEnabled := false;
        NMActivateEnabled := false;
        NMNextEnabled := NMEnableCustomerRewards;
    end;

    local procedure NMShowSecondPage();
    begin
        NMFirstPageVisible := false;
        NMSecondPageVisible := true;
        NMFinishEnabled := false;
        NMBackEnabled := true;
        NMNextEnabled := false;
        NMActivateEnabled := true;
    end;

    local procedure NMShowFinalPage();
    begin
        NMFinalPageVisible := true;
        NMBackEnabled := true;
        NMNextEnabled := false;
        NMActivateEnabled := false;
    end;

    local procedure NMResetControls();
    begin
        NMFinishEnabled := true;
        NMBackEnabled := true;
        NMNextEnabled := true;
        NMActivateEnabled := true;
        NMFirstPageVisible := false;
        NMSecondPageVisible := false;
        NMFinalPageVisible := false;
    end;

    local procedure NMLoadTopBanners();
    begin
        if NMMediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE))
      then
            if NMMediaResourcesStandard.GET(NMMediaRepositoryStandard."Media Resources Ref")
        then
                NMTopBannerVisible := NMMediaResourcesStandard."Media Reference".HASVALUE;
    end;

    var
        NMMediaRepositoryStandard: Record "Media Repository";
        NMMediaResourcesStandard: Record "Media Resources";
        NMStep: Option First,Second,Finish;
        NMActivationCode: Text;
        NMTopBannerVisible: Boolean;
        NMFirstPageVisible: Boolean;
        NMSecondPageVisible: Boolean;
        NMFinalPageVisible: Boolean;
        NMFinishEnabled: Boolean;
        NMBackEnabled: Boolean;
        NMNextEnabled: Boolean;
        NMActivateEnabled: Boolean;
        NMEnableCustomerRewards: Boolean;
}
