# Run (Ctrl+C to stop, or delete the flag file):
#   powershell -ExecutionPolicy Bypass -File jiggle.ps1

$flag = "C:\scripts\jiggle.on"
New-Item -Path $flag -ItemType File -Force | Out-Null

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System.Runtime.InteropServices;
public class M {
  [DllImport("user32.dll")] public static extern void mouse_event(
    uint flags, int dx, int dy, uint data, System.UIntPtr extra);
}
"@

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$w = $screen.Width
$h = $screen.Height

function Move-To($x, $y) {
  # Absolute coordinates are normalised to 0..65535 across the screen
  $ax = [int](($x * 65535) / $w)
  $ay = [int](($y * 65535) / $h)
  # MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE
  [M]::mouse_event(0x8001, $ax, $ay, 0, [System.UIntPtr]::Zero)
}

while (Test-Path $flag) {
  # Random circle: centre, radius, direction, starting angle
  $radius = Get-Random -Minimum 60  -Maximum 220
  $cx     = Get-Random -Minimum $radius -Maximum ($w - $radius)
  $cy     = Get-Random -Minimum $radius -Maximum ($h - $radius)
  $start  = Get-Random -Minimum 0 -Maximum 360
  $dir    = if ((Get-Random -Maximum 2) -eq 0) { 1 } else { -1 }
  $steps  = 36  # one circle in 10° increments

  for ($i = 0; $i -le $steps; $i++) {
    if (-not (Test-Path $flag)) { break }
    $angle = $start + ($dir * $i * (360 / $steps))
    $rad   = $angle * [Math]::PI / 180
    $x     = $cx + $radius * [Math]::Cos($rad)
    $y     = $cy + $radius * [Math]::Sin($rad)
    Move-To $x $y
    Start-Sleep -Milliseconds 40
  }

  # Random pause between circles
  Start-Sleep -Seconds (Get-Random -Minimum 30 -Maximum 90)
}
