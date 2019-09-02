#Open pdf from report

[CmdletBinding()]
param($Interval = 5000, [switch]$RightClick, [switch]$NoMove)
 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
$DebugViewWindow_TypeDef = @'
[DllImport("user32.dll")]
public static extern IntPtr FindWindow(string ClassName, string Title);
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")]
public static extern bool SetCursorPos(int X, int Y);
[DllImport("user32.dll")]
public static extern bool GetCursorPos(out System.Drawing.Point pt);
 
[DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
 
private const int MOUSEEVENTF_LEFTDOWN = 0x02;
private const int MOUSEEVENTF_LEFTUP = 0x04;
private const int MOUSEEVENTF_RIGHTDOWN = 0x08;
private const int MOUSEEVENTF_RIGHTUP = 0x10;
 
public static void LeftClick(){
    mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
}
 
public static void RightClick(){
    mouse_event(MOUSEEVENTF_RIGHTDOWN | MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
}
'@
Add-Type -MemberDefinition $DebugViewWindow_TypeDef -Namespace AutoClicker -Name Temp -ReferencedAssemblies System.Drawing
 
$pt = New-Object System.Drawing.Point

Read-Host 'Press Enter to begin' | Out-Null

$file = Import-CSV C:\Users\lg6548\Desktop\Unencrypt2\encrypted.csv



ForEach ($record in $file){

$pathway = $record.Path
$filename = split-path $pathway -leaf
$deskpath = "C:\Users\lg6548\Desktop\" + $filename

Write-Host $pathway

Move-Item $pathway $deskpath | Wait-Job

Invoke-Item $deskpath

start-sleep -seconds 7

# Use this to create screenshot of pdf to check OCR status
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)

   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

   $bmp.Save($path)

   $graphics.Dispose()
   $bmp.Dispose()
}

$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1366, 768)
screenshot $bounds "C:\users\lg6548\desktop\unencrypt2\color.png"

#Use this to get pixel
$Cave = [System.Drawing.Bitmap]::FromFile('C:\users\lg6548\desktop\unencrypt2\color.png')

$Waitforfinish = ($Cave.GetPixel(447,352).name).substring(2,6)

Write-Host $waitforfinish

$Cave.Dispose()

if ($waitforfinish -ne "eec200"){
Write-Host "Error skipping file"
start-sleep -seconds 3
[AutoClicker.Temp]::LeftClick()
start-sleep -seconds 3
Stop-Process -name acrobat -force

start-sleep -seconds 10

Move-Item $deskpath $pathway | Wait-Job
Continue
}

[System.Windows.Forms.SendKeys]::SendWait('KePRO216#')
start-sleep -seconds 2
[System.Windows.Forms.SendKeys]::SendWait('~')
start-sleep -seconds 10
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(529,59)
start-sleep -seconds 3
[AutoClicker.Temp]::LeftClick()
start-sleep -seconds 1
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(529,179)
start-sleep -seconds 3
[AutoClicker.Temp]::LeftClick()
start-sleep -seconds 1
[System.Windows.Forms.SendKeys]::SendWait('~')
start-sleep -seconds 3
[System.Windows.Forms.SendKeys]::SendWait('^s')
start-sleep -seconds 3
Stop-Process -name acrobat -force
start-sleep -seconds 10

Move-Item $deskpath $pathway | Wait-Job

$pathway >> completedu.csv

}


cmd /c pause