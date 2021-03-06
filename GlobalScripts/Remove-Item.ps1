<#

    Wrapper around 'rm' (remove-item) which adds a parameter that supports the recursive/force command "rm -rf"
    
    I got so used to typing that on the mac that I kept wanting it on windows.

#>


function internal-remove-item {

[CmdletBinding(DefaultParameterSetName='Path', SupportsShouldProcess=$true, ConfirmImpact='Medium', SupportsTransactions=$true, HelpUri='http://go.microsoft.com/fwlink/?LinkID=113373')]
param(
    [Parameter(ParameterSetName='Path', Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string[]]
    ${Path},

    [Parameter(ParameterSetName='LiteralPath', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('PSPath')]
    [string[]]
    ${LiteralPath},

    [string]
    ${Filter},

    [string[]]
    ${Include},

    [string[]]
    ${Exclude},

    [switch]
    ${Recurse},

    [switch]
    ${Force},

    [switch]
    $rforce,

    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [pscredential]
    [System.Management.Automation.CredentialAttribute()]
    ${Credential})

begin
{
    try {

        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        if($PSBoundParameters.rforce) {
            $PSBoundParameters.Force = $true;
            $PSBoundParameters.Recurse = $true;
            $PSBoundParameters.Remove("rforce") | out-null
        }

        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Remove-Item', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
<#

.ForwardHelpTargetName Remove-Item
.ForwardHelpCategory Cmdlet

#>

}

Set-Alias -Name Remove-Item -Value Internal-Remove-Item -Option AllScope
Set-Alias -Name rm -Value Internal-Remove-Item -Option AllScope
