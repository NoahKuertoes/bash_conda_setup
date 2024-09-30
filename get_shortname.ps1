param (
    [string]$LongPath
)

function Get-ShortPathName {
    param ([string]$LongPath)
    $api = Add-Type -memberDefinition @"
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetShortPathName(
        string lpszLongPath,
        System.Text.StringBuilder lpszShortPath,
        int cchBuffer);
"@ -name "Win32GetShortPathName" -namespace Win32Functions -passThru

    $buffer = New-Object System.Text.StringBuilder 255
    $api::GetShortPathName($LongPath, $buffer, $buffer.Capacity) | Out-Null
    $buffer.ToString()
}

# Call the function and print the result
$shortName = Get-ShortPathName $LongPath
Write-Output $shortName
