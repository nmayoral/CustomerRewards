codeunit 50002 NMCustRewardsAssistedSetup
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddExtensionAssistedSetup_OnRegisterAssistedSetup();
    var
        GuidedExperience: Codeunit "Guided Experience";
        CurrentGlobalLanguage: Integer;
        myAppInfo: ModuleInfo;
        WizardTxt: Label 'Customer Rewards assisted setup guide';
        GuidedExperienceType: Enum "Guided Experience Type";
        VideoCategory: Enum "Video Category";
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo);
        CurrentGlobalLanguage := GlobalLanguage();
        GuidedExperience.InsertAssistedSetup(WizardTxt, WizardTxt, WizardTxt, 5, ObjectType::Page, page::NMCustomerRewardsWizard, "Assisted Setup Group"::Extensions, '', VideoCategory::Uncategorized, '');
        GLOBALLANGUAGE(1033);
        GuidedExperience.AddTranslationForSetupObjectTitle(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::NMCustomerRewardsWizard, CurrentGlobalLanguage, WizardTxt);
    end;
}
