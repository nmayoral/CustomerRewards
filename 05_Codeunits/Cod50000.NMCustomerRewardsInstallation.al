codeunit 50000 NMCustomerRewardsInstallation
{
    // Customer Rewards Install Logic 
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
        NMMyAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(NMMyAppInfo); // Get info about the currently executing module

        if NMMyAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            NMHandleFreshInstall()
        else
            NMHandleReinstall(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure NMHandleFreshInstall();
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was installed
        // - Initial data setup for use
        NMSetDefaultCustomerRewardsExtMgtCodeunit();
        NMInsertDefaultRewardLevels();
        NMInitializeRewardsForExistingCustomers();
    end;

    local procedure NMHandleReinstall();
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Set up 'welcome back' messaging for next user access.
    end;

    procedure NMSetDefaultCustomerRewardsExtMgtCodeunit();
    var
        NMCustomerRewardsMgtSetup: Record NMCustomerRewardsMgtSetup;
    begin
        NMCustomerRewardsMgtSetup.DeleteAll();
        NMCustomerRewardsMgtSetup.Init();
        // Default Customer Rewards Ext. Mgt codeunit to use for handling events  
        NMCustomerRewardsMgtSetup."NMCustRewExtMgtCUID" := Codeunit::NMCustomerRewardsExtMgt;
        NMCustomerRewardsMgtSetup.Insert();
    end;

    procedure NMInsertDefaultRewardLevels()
    var
        NMRewardLevels: Record NMRewardLevel;
    begin
        Clear(NMRewardLevels);
        if not NMRewardLevels.IsEmpty then
            exit;
        NMInsertRewardLevel('Bronze', 10);
        NMInsertRewardLevel('Silver', 20);
        NMInsertRewardLevel('Gold', 30);
        NMInsertRewardLevel('Platinum', 40);

    end;

    local procedure NMInsertRewardLevel(NMLevel: Text[20]; NMPoints: integer)
    var
        NMRewardLevel: Record NMRewardLevel;
    begin
        Clear(NMRewardLevel);
        NMRewardLevel.NMLevel := NMLevel;
        NMRewardLevel.NMMinimumRewardPoints := NMPoints;
        NMRewardLevel.Insert();
    end;

    local procedure NMInitializeRewardsForExistingCustomers()
    var
        NMCustomer: Record Customer;
        NMSalesHeader: Record "Sales Header";
    begin
        Clear(NMSalesHeader);
        NMSalesHeader.SetCurrentKey("Sell-to Customer No.");
        NMSalesHeader.SetRange(Status, NMSalesHeader.Status::Released);
        if NMSalesHeader.FindSet() then
            repeat
                if not NMCustomer.Get(NMSalesHeader."Sell-to Customer No.") then
                    exit;
                NMCustomer.NMRewardPoints += 1; // Add a point for each new sales order 
                NMCustomer.Modify();
            until NMSalesHeader.Next() = 0;
    end;
}
