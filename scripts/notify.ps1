# Send Windows toast notification (UTF-8 BOM)
param(
    [string]$Title = "Task done",
    [string]$Message = "Task finished, results are ready.",
    [int]$TimeoutSec = 6
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$tip = New-Object System.Windows.Forms.NotifyIcon
$tip.Icon = [System.Drawing.SystemIcons]::Information
$tip.Visible = $true
$tip.ShowBalloonTip($TimeoutSec * 1000, $Title, $Message, [System.Windows.Forms.ToolTipIcon]::Info)
Start-Sleep -Seconds $TimeoutSec
$tip.Dispose()