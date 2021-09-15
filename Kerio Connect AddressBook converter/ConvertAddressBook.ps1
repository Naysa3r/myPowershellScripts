# ��������� �������� ����� � ������� vCard � eml ����� ��� ������� � ���������������� ������ Kerio Connect.
# ��� ������ �������� ����� �������� ����� ������ ���� � ��������� UTF-8 � BOM
#
# ������: .\ConvertAddressBook.ps1 [������������ ����� ������� .vcf] [������� ��� �������� ������]
#
# ���������� ����� ��������� �� ������ Kerio Connect � ������� [/opt/kerio/mailserver/store/mail/footberg.by/������������/Contacts/#msgs]
# ��������������� ������������ ����� web-��������� Kerio Connect


param (
    $filepath = "D:\��������\��������� ������.vcf",
    $outputpath = "D:\��������\eml\"
)
#Get-Content -Path "D:\��������\��������� ������.vcf" | Out-File -FilePath "D:\��������\TestBook.eml" -Encoding utf8
#$addressbook = Get-Content -Path $filepath
if (Test-Path -Path $outputpath) {
    
} else {
    New-Item -Path $outputpath -ItemType Directory
}

$filesCounter = 1
$US = New-Object System.Globalization.CultureInfo("en-US")
$addressbook = Get-Item $filepath
$reader = New-Object -TypeName System.IO.StreamReader -ArgumentList ($addressbook)
#$writer = New-Object -TypeName System.IO.StreamWriter -ArgumentList ("$outputpath\out$($filesCounter).eml", [System.Text.Encoding]::$Utf8BomEncoding)
$writer = New-Object System.IO.StreamWriter -ArgumentList (("$outputpath" + "{0:D8}" -f $filesCounter + ".eml"), $false, [System.Text.Encoding]::UTF8)
$flagfn = 0
while ($read = $reader.ReadLine()){
    if($read -match "FN:"){
        $subjectname = $read.Trim("FN:")
        Write-Host ($subjectname)
        $flagfn = 1
    }
    elseif ($read -eq "END:VCARD" -and $flagfn -eq 0) {
        $subjectname = "UNKNOWN"
        Write-Host ($subjectname)
    } 

    $writer.WriteLine($read)
    if ($read -eq "END:VCARD"){
        $flagfn = 0
        $writer.Close()
        $writer.Dispose()
        
        $date = (Get-Date).ToString("ddd, dd MMM yyyy HH:mm:ss K",$US)

        @("Subject: $subjectname
Date: $date
Content-Type: text/vcard; charset=`"utf-8`"
Content-Transfer-Encoding: 8bit
") + (Get-Content -Path ("$outputpath" + "{0:D8}" -f $filesCounter + ".eml")) |  Out-File -FilePath ("$outputpath" + "{0:D8}" -f $filesCounter + ".eml") -Encoding utf8

        $filesCounter++
        $writer = New-Object -TypeName System.IO.StreamWriter -ArgumentList (("$outputpath" + "{0:D8}" -f $filesCounter + ".eml"), $false, [System.Text.Encoding]::UTF8)
        
    }
    
}
$writer.Close()
$writer.Dispose()