#App Registration details
$TenantID = "c9f560a4-66fc-45ed-b0b5-5a8c8c0ee8fc"
$ClientID = "f30a7b07-1258-42ad-b5d6-dbe79c8dc06f"
$ClientSecret = "nvT7Q~sSt6Ux1Ct6Fn0d1QNMul0eWPLog4wWF"
 
$Body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $ClientID
    Client_Secret = $ClientSecret
}
 
$Connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token `
    -Method POST `
    -Body $body
 
#Get the Access Token
$Token = $Connection.access_token

#Connect to Microsoft Graph 
Connect-MgGraph -AccessToken ($Token |ConvertTo-SecureString -AsPlainText -Force)

#$today = get-date -Format "yyyy-MM-ddT00:00:00Z" 
$today = (get-date).AddDays(-2).ToString("yyyy-MM-ddT00:00:00Z")
$yesterday = (get-date).AddDays(-3).ToString("yyyy-MM-ddT00:00:00Z")


$messages = Get-MgUserMessage -UserId software@librariesunlimited.org.uk -Filter "ReceivedDateTime ge $yesterday and ReceivedDateTime lt $today and Subject eq 'Kiosk connection to LMS/ILS offline'" -all
#$messages = Get-MgUserMessage -UserId software@librariesunlimited.org.uk -Filter "ReceivedDateTime ge $today and Subject eq 'Kiosk connection to LMS/ILS offline'" -all

$output = @()
foreach ($m in $messages) 
{
    #write-host "$($m.receiveddatetime) "  " $([regex]::match($m.bodypreview, 'Site location: (.*)').groups[1].value)" 
    $eOutput = New-Object psobject
    $eOutput | Add-Member NoteProperty -Name "ReceivedDateTime" -Value $m.ReceivedDateTime.AddSeconds(-($m.ReceivedDateTime.Second))
    $locString = ([regex]::match($m.bodypreview, 'Site location: (.*)').groups[1].value) -replace ".$"
    $eOutput | Add-Member NoteProperty -Name "Location" -Value $locString
    $eOutput | Add-Member NoteProperty -Name "Device" -Value ([regex]::match($m.bodypreview, 'Device name: (.*)').groups[1].value)
    $output += $eOutput
}

# get unique sorted list of Locations
$locationList = $output.location | Sort-Object -Descending -Unique
$locations = @()
$i = 0.5
foreach ($l in $locationList)
{
        $eLocation = New-Object psobject
        $eLocation | Add-Member NoteProperty -Name "Location" -Value $l
        $eLocation | Add-Member NoteProperty -Name "YValue" -Value $i
        $locations += $eLocation
        $i++
}


Function New-Chart() {
    param (
        [cmdletbinding()]
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $True)]
        [int]$width,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $True)]
        [int]$height,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [string]$ChartTitle,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [string]$ChartTitleFont = $null,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [System.Drawing.ContentAlignment]$ChartTitleAlign = [System.Drawing.ContentAlignment]::TopCenter,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [System.Drawing.Color]$ChartColor = [System.Drawing.Color]::White,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [boolean]$WithChartArea = $true,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [boolean]$WithChartLegend = $true
    )
    # Example:  $Chart = New-Chart -width 1024 -height 800 -ChartTitle "test"
    
    
    $CurrentChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
    
    if($CurrentChart -eq $null) {
        throw "Unable to create Chart Object"
    }
    
    $CurrentChart.Width         = $width 
    $CurrentChart.Height        = $height
    #TODO:$CurrentChart.Left    = $LeftPadding
    #TODO:$CurrentChart.Top     = $TopPadding
    
    $CurrentChart.BackColor     = $ChartColor
    
    if($WithChartArea) {
        $CurrentChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
        
        if($CurrentChartArea -eq $null) {
            throw "Unable to create ChartArea object"
        }
        
        $CurrentChart.ChartAreas.Add($CurrentChartArea)
    }
    
    if([String]::isNullOrEmpty($ChartTitleFont)) {
        $ChartTitleFont = "Arial,35pt"
    }
    
    if(-Not [String]::isNullOrEmpty($ChartTitle)) {
        [void]$CurrentChart.Titles.Add($ChartTitle)
        $CurrentChart.Titles[0].Font        = $ChartTitleFont
        $CurrentChart.Titles[0].Alignment   = $ChartTitleAlign
    }
    
    if($WithChartLegend) {
        $ChartLegend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
        $ChartLegend.name = "Chart Legend"
        $Chart.Legends.Add($ChartLegend)
    }
    
    $CurrentChart
}

Function New-ChartSeries() {
    param (
        [cmdletbinding()]
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $True)]
        [String]$SeriesName,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [int]$BorderWidth = 3,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [boolean]$IsVisibleInLegend = $false,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [string]$ChartAreaName = $null,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [string]$LegendName    = $null,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [string]$HTMLColor     = $null,
        [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $False)]
        [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]$ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
    )
    
    $CurrentChartSeries = New-Object  System.Windows.Forms.DataVisualization.Charting.Series
    
    if($CurrentChartSeries -eq $null) {
        throw "Unable to create Chart Series"
    }
    
    $CurrentChartSeries.Name                = $SeriesName
    $CurrentChartSeries.ChartType           = $ChartType 
    $CurrentChartSeries.BorderWidth         = $BorderWidth 
    $CurrentChartSeries.IsVisibleInLegend   = $IsVisibleInLegend 
    
    if(-Not([string]::isNullOrEmpty($ChartAreaName))) {
        $CurrentChartSeries.ChartArea = $ChartAreaName
    }
    
    if(-Not([string]::isNullOrEmpty($LegendName))) {
        $CurrentChartSeries.Legend = $LegendName
    }
    
    if(-Not([string]::isNullOrEmpty($HTMLColor))) {
        $CurrentChartSeries.Color = $HTMLColor
    }
    
    $CurrentChartSeries
}

# ------------------
# Script Settings
Add-Type -AssemblyName "System.Windows.Forms.DataVisualization"
$ChartTitle      = "LMS Failure Notification Emails"
$ChartSeriesType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Point
$ChartSeriesHTMLColor = $null
# ------------------
 
#Chart object creation
$Chart = New-Chart -width 4096 -height 1600 -ChartTitle $ChartTitle -WithChartArea $true -WithChartLegend $false
# Chart area settings
$Chart.ChartAreas[0].Name              = "DefaultArea"
$Chart.ChartAreas[0].AxisY.Title       = ""
$Chart.ChartAreas[0].AxisX.Title       = ""
$Chart.ChartAreas[0].AxisX.IntervalType = "Hours"
$Chart.ChartAreas[0].AxisX.Interval = 2
$Chart.ChartAreas[0].AxisX.LabelStyle.Format = "{0:HH:mm}"
$Chart.ChartAreas[0].AxisX.LabelStyle.Font = "Arial,20pt"
$Chart.ChartAreas[0].AxisY.Interval = 1
$Chart.ChartAreas[0].AxisY.LabelStyle.Enabled = $false
    #optional settings for axes
 
# Chart Legend
$ChartLegend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
$ChartLegend.name = "Chart Legend"
$Chart.Legends.Add($ChartLegend)
 
# Chart Series creation
$ChartSeries = New-ChartSeries -SeriesName "Series 1" -LegendName "Chart Legend" -ChartAreaName "DefaultArea" -ChartType $ChartSeriesType -HTMLColor $ChartSeriesHTMLColor
$Chart.Series.Add($ChartSeries)
$ChartSeries = New-ChartSeries -SeriesName "Series 2" -LegendName "Chart Legend" -ChartAreaName "DefaultArea" -ChartType $ChartSeriesType -HTMLColor $ChartSeriesHTMLColor
$Chart.Series.Add($ChartSeries)

$chart.Series["Series 1"].MarkerSize = 15
$chart.Series["Series 2"].MarkerSize = 1
$chart.Series["Series 2"].Font = "Arial,23pt"
#$chart.Series["Series 2"].SmartLabelStyle.MovingDirection = 8
#$chart.Series["Series 2"].SmartLabelStyle.MaxMovingDistance = 800
#$chart.Series["Series 2"].SmartLabelStyle.MinMovingDistance = 80
$chart.Series["Series 2"].SmartLabelStyle.Enabled = $false
foreach ($o in $output)
{
    [void]$Chart.Series["Series 1"].Points.AddXY($o.ReceivedDateTime,($locations | where -property Location -eq $o.Location).YValue)
    #$o.ReceivedDateTime,($locations | where -property Location -eq $o.Location).YValue
}
foreach ($l in $locations)
{
    [void]$Chart.Series["Series 2"].Points.AddXY((get-date -date $yesterday).AddHours(-1),$l.YValue-.5)
}
foreach ($p in $chart.series["Series 2"].points)
{
    $val = $($p.YValues)+.5
    $p.Label = ($locations | where -property YValue -like $val).Location
}


#[void]$Chart.Series["Series 1"].Points.AddXY($SqlRec.XAxisValue,$SqlRec.YAxisValue)
$Chart.SaveImage("C:\Users\ewen.robinson\Downloads\chart28102023.jpg","JPEG")