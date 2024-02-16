codeunit 50001 NMCustomerRewardsExtMgt
{
    EventSubscriberInstance = StaticAutomatic;

    // Determines if the extension is activated 
    procedure NMIsCustomerRewardsActivated(): Boolean;
    var
        NMActivationCodeInformation: Record NMActivationCodeInformation;
    begin
        if not NMActivationCodeInformation.FindFirst() then
            exit(false);

        if (NMActivationCodeInformation.NMDateActivated <= Today) and (Today <= NMActivationCodeInformation.NMExpirationDate) then
            exit(true);
        exit(false);
    end;

    // Opens the Customer Rewards Assisted Setup Guide 
    procedure NMOpenCustomerRewardsWizard();
    var
        NMCustomerRewardsWizard: Page NMCustomerRewardsWizard;
    begin
        NMCustomerRewardsWizard.RunModal();
    end;

    // Opens the Reward Level page 
    procedure NMOpenRewardsLevelPage();
    var
        NMRewardsLevelList: Page NMRewardsLevelList;
    begin
        NMRewardsLevelList.Run();
    end;

    // Determines the corresponding reward level and returns it 
    procedure NMGetRewardLevel(NMRewardPoints: Integer) NMRewardLevelTxt: Text;
    var
        NMRewardLevel: Record NMRewardLevel;
        NMMinRewardLevelPoints: Integer;
    begin
        NMRewardLevelTxt := NMNoRewardlevelTxt;

        if NMRewardLevel.IsEmpty() then
            exit;
        NMRewardLevel.SetRange(NMMinimumRewardPoints, 0, NMRewardPoints);
        NMRewardLevel.SetCurrentKey(NMMinimumRewardPoints); // sorted in ascending order 

        if not NMRewardLevel.FindFirst() then
            exit;
        NMMinRewardLevelPoints := NMRewardLevel.NMMinimumRewardPoints;

        if NMRewardPoints >= NMMinRewardLevelPoints then begin
            NMRewardLevel.Reset();
            NMRewardLevel.SetRange(NMMinimumRewardPoints, NMMinRewardLevelPoints, NMRewardPoints);
            NMRewardLevel.SetCurrentKey(NMMinimumRewardPoints); // sorted in ascending order 
            NMRewardLevel.FindLast();
            NMRewardLevelTxt := NMRewardLevel.NMLevel;
        end;
    end;

    // Activates Customer Rewards if activation code is validated successfully  
    procedure NMActivateCustomerRewards(NMActivationCode: Text): Boolean;
    var
        NMActivationCodeInformation: Record NMActivationCodeInformation;
    begin
        // raise event 
        NMOnGetActivationCodeStatusFromServer(NMActivationCode);
        exit(NMActivationCodeInformation.Get(NMActivationCode));
    end;

    // publishes event 
    [IntegrationEvent(false, false)]
    procedure NMOnGetActivationCodeStatusFromServer(NMActivationCode: Text);
    begin
    end;

    // Subscribes to OnGetActivationCodeStatusFromServer event and handles it when the event is raised 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::NMCustomerRewardsExtMgt, 'NMOnGetActivationCodeStatusFromServer', '', false, false)]
    local procedure OnGetActivationCodeStatusFromServerSubscriber(NMActivationCode: Text);
    var
        NMActivationCodeInfo: Record NMActivationCodeInformation;
        NMResponseText: Text;
        NMResult: JsonToken;
        NMJsonRepsonse: JsonToken;
    begin
        if not NMCanHandle() then
            exit; // use the mock 

        // Get response from external service and update activation code information if successful 
        if (NMGetHttpResponse(NMActivationCode, NMResponseText)) then begin
            NMJsonRepsonse.ReadFrom(NMResponseText);

            if (NMJsonRepsonse.SelectToken('ActivationResponse', NMResult)) then
                if (NMResult.AsValue().AsText() = 'Success') then begin

                    if (NMActivationCodeInfo.FindFirst()) then
                        NMActivationCodeInfo.Delete();

                    NMActivationCodeInfo.Init();
                    NMActivationCodeInfo.NMActivationCode := NMActivationCode;
                    NMActivationCodeInfo.NMDateActivated := Today;
                    NMActivationCodeInfo.NMExpirationDate := CALCDATE('<1Y>', Today);
                    NMActivationCodeInfo.Insert();
                end;
        end;
    end;

    // Helper method to make calls to a service to validate activation code 
    local procedure NMGetHttpResponse(NMActivationCode: Text; var NMResponseText: Text): Boolean;
    begin
        // You will typically make external calls / http requests to your service to validate the activation code 
        // here but for the sample extension we simply return a successful dummy response 
        if NMActivationCode = '' then
            exit(false);

        NMResponseText := NMDummySuccessResponseTxt;
        exit(true);
    end;

    // Subscribes to the OnAfterReleaseSalesDoc event and increases reward points for the sell to customer in posted sales order 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure NMOnAfterReleaseSalesDocSubscriber(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean);
    var
        NMCustomer: Record Customer;
    begin
        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;

        NMCustomer.Get(SalesHeader."Sell-to Customer No.");
        NMCustomer.NMRewardPoints += 1; // Add a point for each new sales order 
        NMCustomer.Modify();
    end;

    // Checks if the current codeunit is allowed to handle Customer Rewards Activation requests rather than a mock. 
    local procedure NMCanHandle(): Boolean;
    var
        NMCustomerRewardsMgtSetup: Record NMCustomerRewardsMgtSetup;
    begin
        if NMCustomerRewardsMgtSetup.Get() then
            exit(NMCustomerRewardsMgtSetup."NMCustRewExtMgtCUID" = CODEUNIT::NMCustomerRewardsExtMgt);
        exit(false);
    end;

    var
        NMDummySuccessResponseTxt: Label '{"ActivationResponse": "Success"}', Locked = true;
        NMNoRewardlevelTxt: Label 'None', Comment = 'Nada';
}
