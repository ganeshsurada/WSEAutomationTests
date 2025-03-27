﻿<#
DESCRIPTION:
    This function initiates tracing for a specified scenario using the tracelog utility.
    It starts the trace session, enables system rundown tracing, and configures detailed trace logging.
INPUT PARAMETERS:
    - snarioName [string] :- The name of the scenario for which tracing is initiated. This name is used to organize log files.
RETURN TYPE:
    - void (Starts the trace session and logs output without returning a value.)
#>
function StartTrace($snarioName)
{   
    #path to logger binaries
    $pathlogger = ".\LoggerBinaries\tracelog.exe"
    $patheprint = ".\LoggerBinaries\eprint.exe"
    if (!(Test-path -path "$pathLogsFolder\$snarioName" ))
    {
        CreateScenarioLogsFolder $snarioName
    }

    #Setting Scenario specific folders
    $pathAsgTraceETL = "$pathLogsFolder\$snarioName\" + "AsgTrace.etl"
    $pathAsgTraceLogTxt = "$pathLogsFolder\$snarioName\" + "AsgTraceLog.txt"
    $pathAsgTraceTxt = "$pathLogsFolder\$snarioName\" + "AsgTrace.txt"
    
    if(Test-path -Path $pathlogger)
    {
         Write-Log -Message "Initiating StartTrace" -IsOutput
         & $pathlogger -start AsgTrace -f $pathAsgTraceETL > $pathAsgTraceLogTxt
         Start-Sleep -m 500
         & $pathlogger -systemrundown AsgTrace >> $pathAsgTraceLogTxt
         Start-Sleep -m 500
         & $pathlogger -enableex AsgTrace -guid `#AB71FE82-3742-446b-982A-1FEDBB7D9594 -level 0xff  >> $pathAsgTraceLogTxt
         Write-Log -Message "Asg Traces started" -IsOutput
    }
    else
    {
        Write-Error "File does not exist $pathlogger" 
    }
} 

<#
DESCRIPTION:
    This function stops the active trace session for a specified scenario and processes the collected trace logs.
    It converts the trace logs into a readable text format and stores them in the scenario-specific log folder.
INPUT PARAMETERS:
    - snarioName [string] :- The name of the scenario for which tracing is stopped. This name is used to locate the correct log files.
RETURN TYPE:
    - void (Stops the trace session and processes the logs without returning a value.)
#>
function StopTrace($snarioName)
{   
    #path to logger binaries
    $pathlogger = ".\LoggerBinaries\tracelog.exe"
    $patheprint = ".\LoggerBinaries\eprint.exe"

    #Setting Scenario specific folders
    $pathAsgTraceETL = "$pathLogsFolder\$snarioName\" + "AsgTrace.etl"
    $pathAsgTraceLogTxt = "$pathLogsFolder\$snarioName\" + "AsgTraceLog.txt"
    $pathAsgTraceTxt = "$pathLogsFolder\$snarioName\" + "AsgTrace.txt"
    
    if((Test-path -Path $patheprint) -and (Test-path -Path $pathlogger))
    {
        Write-Log -Message "Initiating StopTrace" -IsOutput
        & $pathlogger -stop AsgTrace >> $pathAsgTraceLogTxt
        Start-Sleep -m 500
        & $patheprint $pathAsgTraceETL /o $pathAsgTraceTxt /oftext /time >> $pathAsgTraceLogTxt
        Start-Sleep -Seconds 2 #Wait for 2 secs so that Asgtrace.txt is generated properly before verifyLogs function starts
        Write-Log -Message "Asg Traces Stopped" -IsOutput
    }
    else
    {
        Write-Error "File does not exist $patheprint or $pathlogger" 
    }
}
