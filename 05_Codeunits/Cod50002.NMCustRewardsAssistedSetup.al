codeunit 50002 NMCustRewardsAssistedSetup
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure NMAddExtensionAssistedSetup_OnRegisterAssistedSetup();
    var
        NMGuidedExperience: Codeunit "Guided Experience";
        NMCurrentGlobalLanguage: Integer;
        NMMyAppInfo: ModuleInfo;
        NMWizardTxt: Label 'Customer Rewards assisted setup guide', Comment = 'Guía instalación asistida Recompensas Cliente';
        NMGuidedExperienceType: Enum "Guided Experience Type";
        NMVideoCategory: Enum "Video Category";
    begin
        NavApp.GetCurrentModuleInfo(NMMyAppInfo);
        NMCurrentGlobalLanguage := GlobalLanguage();
        NMGuidedExperience.InsertAssistedSetup(NMWizardTxt, NMWizardTxt, NMWizardTxt, 5, ObjectType::Page, page::NMCustomerRewardsWizard, "Assisted Setup Group"::Extensions, '', NMVideoCategory::Uncategorized, '');
        GLOBALLANGUAGE(1033);
        NMGuidedExperience.AddTranslationForSetupObjectTitle(NMGuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::NMCustomerRewardsWizard, NMCurrentGlobalLanguage, NMWizardTxt);
    end;
}
