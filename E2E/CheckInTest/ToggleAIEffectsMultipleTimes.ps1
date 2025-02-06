﻿Add-Type -AssemblyName UIAutomationClient

<#
DESCRIPTION:
    This function toggles a specified AI effect on and off for a given number of times 
    in the Windows Settings App. It is used to test the stability and responsiveness 
    of AI effect toggles.

INPUT PARAMETERS:
    - uiEle [object] :- The UI automation element representing the Settings app window.
    - clsNme [string] :- The class name of the UI element (e.g., "ToggleSwitch").
    - proptyNme [string] :- The property name of the AI effect to be toggled (e.g., "Automatic framing").
    - times [int] :- The number of times the AI effect should be toggled on and off.

RETURN TYPE:
    - void
#>
function OnandOffAiEffects($uiEle, $clsNme, $proptyNme, $times)
{ 
   
   $i = 0
   while($i -le $times)
   {  
      FindAndSetValue $ui $clsNme $proptyNme "On"
      FindAndSetValue $ui $clsNme $proptyNme "Off"
      $i++
   }
}

<#
DESCRIPTION:
    This function toggles various AI effects in the Windows Settings app multiple times to test system stability.
    It collects logs, checks memory usage, verifies logs, and ensures the device returns to a neutral state.

INPUT PARAMETERS:
    - devPowStat [string] :- The power state of the device (e.g., "PluggedIn", "OnBattery").
    - token [string] :- Authentication token required to control the smart plug.
    - SPId [string] :- Smart plug ID used to control device power states.

RETURN TYPE:
    - void
#>
function ToggleAIEffectsMultipleTimes($devPowStat, $token, $SPId)
{
    $startTime = Get-Date 
    $ErrorActionPreference='Stop'
    $scenarioName = "$devPowStat\ToggleAIEffectsMultipleTimes"
    $logFile = "$devPowStat-ToggleAIEffectsMultipleTimes.txt"
    
    $devState = CheckDevicePowerState $devPowStat $token $SPId
    if($devState -eq $false)
    {   
       TestOutputMessage $scenarioName "Skipped" $startTime "Token is empty"  
       return
    }

    try
	{  
      
        #Create scenario specific folder for collecting logs
        Write-Output "Creating folder for capturing logs"
        CreateScenarioLogsFolder $scenarioName

        #Strating to collect Traces for generic error
        Write-Output "Entering StartTrace"
        StartTrace $scenarioName

       #open Camera App and set default setting to "Use system settings" 
       Set-SystemSettingsInCamera

        #open settings app and obtain ui automation from it
        $ui = OpenApp 'ms-settings:' 'Settings'
        Start-Sleep -m 500
        
        #open camera effects page and toggle AI effects
        Write-Output "Navigate to camera effects setting page"
        FindCameraEffectsPage $ui
        Start-Sleep -m 500 
               
        Write-Output "Toggle camera effects in setting Page"
        OnandOffAiEffects $ui ToggleSwitch "Automatic framing" "2"
        OnandOffAiEffects $ui ToggleSwitch "Eye contact" "2"
        OnandOffAiEffects $ui ToggleSwitch "Background effects" "2"

        $wsev2PolicyState = CheckWSEV2Policy
        if($wsev2PolicyState -eq $true)
        {
           OnandOffAiEffects $ui ToggleSwitch "Portrait light" "2"
           OnandOffAiEffects $ui ToggleSwitch "Creative filters" "2"
        } 

        #close settings app
        CloseApp 'systemsettings'
        start-sleep -s 1

        #Change AI toggle in camera App UI(We will have change once the effects are available in camera App UI)
        ToggleAiEffectsInCameraApp -AFVal "On" -PLVal "On" -BBVal "On" -BSVal "False" -BPVal "True" `
                                     -ECVal "On" -ECSVal "False" -ECEVal "True" `
                                     -CF "On" -CFI "False" -CFA "False" -CFW "True" 

        
        #open settings app and obtain ui automation from it
        $ui = OpenApp 'ms-settings:' 'Settings'
        Start-Sleep -m 500
        
        #open camera effects page and toggle AI effects
        Write-Output "Navigate to camera effects setting page"
        FindCameraEffectsPage $ui
        Start-Sleep -m 500 

        Write-Output "Toggle camera effects in setting Page"
        OnandOffAiEffects $ui ToggleSwitch "Automatic framing" "2"
        OnandOffAiEffects $ui ToggleSwitch "Eye contact" "2"
        OnandOffAiEffects $ui ToggleSwitch "Background effects" "2"
        $wsev2PolicyState = CheckWSEV2Policy
        if($wsev2PolicyState -eq $true)
        {
           OnandOffAiEffects $ui ToggleSwitch "Portrait light" "2"
           OnandOffAiEffects $ui ToggleSwitch "Creative filters" "2"
        }

        #close settings app
        CloseApp 'systemsettings'
        start-sleep -s 1
                     
        #Change AI toggle in camera App UI (We will have change once the effects are available in camera App UI)
        ToggleAiEffectsInCameraApp -AFVal "Off" -PLVal "Off" -BBVal "On" -BSVal "True" -BPVal "False" `
                                     -ECVal "On" -ECSVal "True" -ECEVal "False" `
                                     -CF "On" -CFI "True" -CFA "False" -CFW "False" 

        #open settings app and obtain ui automation from it
        $ui = OpenApp 'ms-settings:' 'Settings'
        Start-Sleep -m 500
        
        #open camera effects page and toggle AI effects
        Write-Output "Navigate to camera effects setting page"
        FindCameraEffectsPage $ui
        Start-Sleep -m 500 

        Write-Output "Toggle camera effects in setting Page"
        OnandOffAiEffects $ui ToggleSwitch "Automatic framing" "2"
        OnandOffAiEffects $ui ToggleSwitch "Eye contact" "2"
        OnandOffAiEffects $ui ToggleSwitch "Background effects" "2"
        $wsev2PolicyState = CheckWSEV2Policy
        if($wsev2PolicyState -eq $true)
        {
           OnandOffAiEffects $ui ToggleSwitch "Portrait light" "2"
           OnandOffAiEffects $ui ToggleSwitch "Creative filters" "2"
        }

        #close settings app
        CloseApp 'systemsettings'
        start-sleep -s 1
               
        #Change AI toggle in camera App UI
        ToggleAiEffectsInCameraApp -AFVal "On" -PLVal "On" -BBVal "On" -BSVal "False" -BPVal "True" `
                                     -ECVal "On" -ECSVal "False" -ECEVal "True" `
                                     -CF "On" -CFI "False" -CFA "True" -CFW "False" `
        
        
        Start-Sleep -s 2
        #Toggling All effects on
        Write-Output "Entering ToggleAIEffectsInSettingsApp function to toggle all effects On"
        ToggleAIEffectsInSettingsApp -AFVal "On" -PLVal "On" -BBVal "On" -BSVal "False" -BPVal "True" `
                                     -ECVal "On" -ECSVal "False" -ECEVal "True" -VFVal "On" `
                                     -CF "On" -CFI "False" -CFA "False" -CFW "True"
        Start-Sleep -s 2       

        #close settings app
        CloseApp 'systemsettings'

        #Close camera App
        CloseApp 'WindowsCamera'

        #Checks if frame server is stopped
        Write-Output "Entering CheckServiceState function"
        CheckServiceState 'Windows Camera Frame Server'

        #Stop the Trace for generic error
        Write-Output "Entering StopTrace function"
        StopTrace $scenarioName

        #check for generic error
        GenericError $scenarioName

        #Check if AvgMemoryUsage is greater than 250MB
        CheckMemoryUsage $scenarioName

        #Create scenario specific folder for collecting logs
        Write-Output "Creating folder for capturing logs"
        $scenarioName = "$devPowStat\ToggleAIEffectsMultipleTimes-ValidateScenarioID"
        CreateScenarioLogsFolder $scenarioName
                      
        #Strating to collect Traces
        Write-Output "Entering StartTrace function"
        StartTrace $scenarioName

        #Open camera App
        $InitTimeCameraApp = CameraPreviewing "20"
        $cameraAppStartTime = $InitTimeCameraApp[-1]
        Write-Output "Camera App start time in UTC: ${cameraAppStartTime}"
        
        #Checks if frame server is stopped
        Write-Output "Entering CheckServiceState function"
        CheckServiceState 'Windows Camera Frame Server'

        #Stop the Trace
        Write-Output "Entering StopTrace function"
        StopTrace $scenarioName

        $wsev2PolicyState = CheckWSEV2Policy
        if($wsev2PolicyState -eq $false)
        {  
           #ScenarioID 81968 is based on v1 effects.   
           Write-Output "Entering Verifylogs function"
           Verifylogs $scenarioName "81968" $startTime

           #calculate Time from camera app started until PC trace first frame processed
           Write-Output "Entering CheckInitTimeCameraApp function" 
           CheckInitTimeCameraApp $scenarioName "81968" $cameraAppStartTime
        }
        else
        { 
           #ScenarioID 737312 is based on v1+v2 effects.   
           Write-Output "Entering Verifylogs function"
           Verifylogs $scenarioName "2834432" $startTime #(Need to change the scenario ID, not sure if this is correct)

           #calculate Time from camera app started until PC trace first frame processed
           Write-Output "Entering CheckInitTimeCameraApp function" 
           CheckInitTimeCameraApp $scenarioName "2834432" $cameraAppStartTime #(Need to change the scenario ID, not sure if this is correct)
        }
        #collect data for Reporting
        Reporting $Results "$pathLogsFolder\Report.txt"

        #For our Sanity, we make sure that we exit the test in netural state,which is pluggedin
        SetSmartPlugState $token $SPId 1
       
    }
    catch
    {   
       Error-Exception -snarioName $scenarioName -strttme $startTime -rslts $Results -logFile $logFile -token $token -SPID $SPID
    }
}












