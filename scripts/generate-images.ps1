# ==========================================================================
# generate-images.ps1 ??? rebuilds the identity images for this portfolio.
#
#   powershell -ExecutionPolicy Bypass -File scripts/generate-images.ps1
#
# Produces (all in assets/):
#   og-image.png        1200 x 630  social sharing card
#   favicon.png           64 x 64   browser tab fallback
#   apple-touch-icon.png 180 x 180  iOS home screen
#   icon-192.png / icon-512.png     web app manifest (maskable-safe)
#
# Requires Windows PowerShell with System.Drawing. No other tools.
# Edit the palette or the name below and re-run to rebrand.
# ==========================================================================

param(
  [string]$Name    = "Ningyuan Zhou",
  [string]$Role    = "AI APPLICATION DEVELOPMENT  /  CS SOPHOMORE",
  [string]$Tagline = "Putting models to work in real life.",
  [string]$Subline = "Local agents  /  Chat bots  /  Full-stack",
  [string]$SiteUrl = "swdlawa.github.io/portfolio"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

# --- Palette (mirrors css/styles.css) -------------------------------------
$ink    = [System.Drawing.ColorTranslator]::FromHtml("#161c22")
$paper  = [System.Drawing.ColorTranslator]::FromHtml("#f7f4ed")
$accent = [System.Drawing.ColorTranslator]::FromHtml("#b0472a")
$muted  = [System.Drawing.ColorTranslator]::FromHtml("#5d6a74")
$line   = [System.Drawing.ColorTranslator]::FromHtml("#e2dbcd")

$outDir = Join-Path (Split-Path $PSScriptRoot -Parent) "assets"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function New-RoundedRect {
  param([float]$x, [float]$y, [float]$w, [float]$h, [float]$r)
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $p.AddArc($x, $y, $d, $d, 180, 90)
  $p.AddArc(($x + $w - $d), $y, $d, $d, 270, 90)
  $p.AddArc(($x + $w - $d), ($y + $h - $d), $d, $d, 0, 90)
  $p.AddArc($x, ($y + $h - $d), $d, $d, 90, 90)
  $p.CloseFigure()
  return $p
}

function New-Canvas {
  param([int]$w, [int]$h)
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  return @($bmp, $g)
}

# The mark: a rounded square with a cream "N" and one accent dot.
function Draw-Mark {
  param($g, [float]$cx, [float]$cy, [float]$size, [bool]$withPlate = $true)

  $x = $cx - $size / 2
  $y = $cy - $size / 2

  if ($withPlate) {
    $plate = New-RoundedRect $x $y $size $size ($size * 0.26)
    $plateBrush = New-Object System.Drawing.SolidBrush($ink)
    $g.FillPath($plateBrush, $plate)
    $plateBrush.Dispose()
    $plate.Dispose()
  }

  $px = { param($v) $x + $size * $v }
  $py = { param($v) $y + $size * $v }

  $pts = @(
    (New-Object System.Drawing.PointF((& $px 0.26), (& $py 0.75))),
    (New-Object System.Drawing.PointF((& $px 0.26), (& $py 0.25))),
    (New-Object System.Drawing.PointF((& $px 0.385), (& $py 0.25))),
    (New-Object System.Drawing.PointF((& $px 0.615), (& $py 0.605))),
    (New-Object System.Drawing.PointF((& $px 0.615), (& $py 0.25))),
    (New-Object System.Drawing.PointF((& $px 0.74), (& $py 0.25))),
    (New-Object System.Drawing.PointF((& $px 0.74), (& $py 0.75))),
    (New-Object System.Drawing.PointF((& $px 0.615), (& $py 0.75))),
    (New-Object System.Drawing.PointF((& $px 0.385), (& $py 0.395))),
    (New-Object System.Drawing.PointF((& $px 0.385), (& $py 0.75)))
  )
  $glyph = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glyph.AddPolygon($pts)
  $cream = New-Object System.Drawing.SolidBrush($paper)
  $g.FillPath($cream, $glyph)

  $dotBrush = New-Object System.Drawing.SolidBrush($accent)
  $r = $size * 0.062
  $g.FillEllipse($dotBrush, ((& $px 0.80) - $r), ((& $py 0.70) - $r), ($r * 2), ($r * 2))

  $cream.Dispose(); $dotBrush.Dispose(); $glyph.Dispose()
}

function Draw-Text {
  param($g, [string]$text, $font, $brush, [float]$x, [float]$y)
  $g.DrawString($text, $font, $brush, $x, $y)
}

# --- 1. App icons + favicon -----------------------------------------------
foreach ($size in @(64, 180, 192, 512)) {
  $pair = New-Canvas $size $size
  $bmp = $pair[0]; $g = $pair[1]
  $g.Clear($ink)

  # Maskable icons keep the glyph inside the middle 80% safe zone.
  $markSize = $size * 0.62
  Draw-Mark $g ($size / 2) ($size / 2) $markSize $false

  $fileName = switch ($size) {
    64  { "favicon.png" }
    180 { "apple-touch-icon.png" }
    192 { "icon-192.png" }
    512 { "icon-512.png" }
  }
  $bmp.Save((Join-Path $outDir $fileName), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

# --- 1b. favicon.ico (16 / 32 / 48, PNG-compressed entries) ---------------
function Get-IconPng {
  param([int]$size)
  $pair = New-Canvas $size $size
  $bmp = $pair[0]; $g = $pair[1]
  $g.Clear([System.Drawing.Color]::Transparent)
  Draw-Mark $g ($size / 2) ($size / 2) ($size * 0.92) $true
  $ms = New-Object System.IO.MemoryStream
  $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
  $bytes = $ms.ToArray()
  $ms.Dispose(); $g.Dispose(); $bmp.Dispose()
  return ,$bytes
}

$icoSizes = @(16, 32, 48)
$icoPngs = @()
foreach ($s in $icoSizes) { $icoPngs += ,(Get-IconPng $s) }

$icoStream = New-Object System.IO.MemoryStream
$icoWriter = New-Object System.IO.BinaryWriter($icoStream)
$icoWriter.Write([UInt16]0)                  # reserved
$icoWriter.Write([UInt16]1)                  # type: icon
$icoWriter.Write([UInt16]$icoSizes.Count)    # image count

$icoOffset = 6 + 16 * $icoSizes.Count
for ($i = 0; $i -lt $icoSizes.Count; $i++) {
  $s = $icoSizes[$i]
  $data = $icoPngs[$i]
  $dim = if ($s -ge 256) { 0 } else { $s }
  $icoWriter.Write([Byte]$dim)               # width
  $icoWriter.Write([Byte]$dim)               # height
  $icoWriter.Write([Byte]0)                  # palette count
  $icoWriter.Write([Byte]0)                  # reserved
  $icoWriter.Write([UInt16]1)                # colour planes
  $icoWriter.Write([UInt16]32)               # bits per pixel
  $icoWriter.Write([UInt32]$data.Length)     # bytes in resource
  $icoWriter.Write([UInt32]$icoOffset)       # offset
  $icoOffset += $data.Length
}
foreach ($data in $icoPngs) { $icoWriter.Write($data) }
$icoWriter.Flush()
[System.IO.File]::WriteAllBytes((Join-Path (Split-Path $PSScriptRoot -Parent) "favicon.ico"), $icoStream.ToArray())
$icoWriter.Dispose(); $icoStream.Dispose()

# --- 2. Open Graph card ----------------------------------------------------
$pair = New-Canvas 1200 630
$bmp = $pair[0]; $g = $pair[1]
$g.Clear($paper)

# Hairline frame
$framePen = New-Object System.Drawing.Pen($line, 2)
$g.DrawRectangle($framePen, 40, 40, 1120, 550)

# Left accent rule
$ruleBrush = New-Object System.Drawing.SolidBrush($accent)
$g.FillRectangle($ruleBrush, 96, 116, 10, 190)

# Upper label
$labelFont = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Regular)
$labelBrush = New-Object System.Drawing.SolidBrush($muted)
Draw-Text $g "PORTFOLIO  /  2026" $labelFont $labelBrush 136 108

# Name
$nameFont  = New-Object System.Drawing.Font("Georgia", 56, [System.Drawing.FontStyle]::Bold)
$inkBrush  = New-Object System.Drawing.SolidBrush($ink)
$accentBrush = New-Object System.Drawing.SolidBrush($accent)
Draw-Text $g $Name $nameFont $inkBrush 130 152

# Role line
$roleFont = New-Object System.Drawing.Font("Consolas", 17, [System.Drawing.FontStyle]::Regular)
Draw-Text $g $Role $roleFont $accentBrush 134 244

# Tagline
$tagFont = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$subFont = New-Object System.Drawing.Font("Segoe UI", 21, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$mutedBrush = New-Object System.Drawing.SolidBrush($muted)
Draw-Text $g $Tagline $tagFont $inkBrush 134 322
Draw-Text $g $Subline $subFont $mutedBrush 136 380

# Bottom: url + small dot
$urlFont = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Regular)
Draw-Text $g $SiteUrl $urlFont $mutedBrush 136 512
$g.FillEllipse($accentBrush, 96, 520, 10, 10)

# Right: the mark, slightly tilted
$g.TranslateTransform(940, 310)
$g.RotateTransform(-6)
Draw-Mark $g 0 0 300 $true
$g.ResetTransform()

# Small caption under the mark
$capFont = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Regular)
$capBrush = New-Object System.Drawing.SolidBrush($muted)
Draw-Text $g "LOCAL AGENT / BOTS / WEB" $capFont $capBrush 790 520

$bmp.Save((Join-Path $outDir "og-image.png"), [System.Drawing.Imaging.ImageFormat]::Png)

# --- Cleanup ---------------------------------------------------------------
foreach ($obj in @($framePen, $ruleBrush, $labelFont, $labelBrush, $nameFont,
                   $roleFont, $inkBrush, $accentBrush, $tagFont, $subFont, $mutedBrush,
                   $urlFont, $capFont, $capBrush)) {
  $obj.Dispose()
}
$g.Dispose(); $bmp.Dispose()

Write-Output "Generated identity images in $outDir"
Get-ChildItem $outDir -Filter *.png | Select-Object Name, Length
