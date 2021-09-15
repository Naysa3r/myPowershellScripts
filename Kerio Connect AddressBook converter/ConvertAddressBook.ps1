# Êîíâåðòåð àäðåñíîé êíèãè â ôîðìàòå vCard â eml ôàéëû äëÿ èìïîðòà â ïîëüçîâàòåëüñêèå àäðåñà Kerio Connect.
# Äëÿ ðàáîòû ðóññêîãî ÿçûêà àäðåñíàÿ êíèãà äîëæíà áûòü â êîäèðîâêå UTF-8 ñ BOM
#
# ÇÀÏÓÑÊ: .\ConvertAddressBook.ps1 [Ðàñïîëîæåíèå êíèãè ôîðìàòà .vcf] [Êàòàëîã äëÿ âûõîäíûõ äàííûõ]
#
# Ïîëó÷åííûå ôàéëû ïåðåíîñèì íà ñåðâåð Kerio Connect â êàòàëîã [/opt/kerio/mailserver/store/mail/domain.com/ïîëüçîâàòåëü/Contacts/#msgs]
# Ïåðåèíäåêñèðóåì ïîëüçîâàòåëÿ ÷åðåç web-èíòåðôåéñ Kerio Connect


param (
    $filepath = "D:\Çàãðóçêè\Ñîáðàííûå àäðåñà.vcf",
    $outputpath = "D:\Çàãðóçêè\eml\"
)
#Get-Content -Path "D:\Çàãðóçêè\Ñîáðàííûå àäðåñà.vcf" | Out-File -FilePath "D:\Çàãðóçêè\TestBook.eml" -Encoding utf8
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
