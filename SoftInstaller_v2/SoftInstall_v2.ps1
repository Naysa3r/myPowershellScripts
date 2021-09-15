# ��������� JSON ��������
$menu =  Get-Content -Path ".\menus.json" | ConvertFrom-Json

$curs = 0

function ReadCurs($curs)
{
    $curs = Read-Host "������� #"
    switch ($curs){
        $curs {
            Clear-Host
            if ($curs -eq 'q') {
                $curs = 0
            }
            elseif ($curs -eq 'x') {
                exit
            }
            elseif ($menu.global.$curs.type -eq "install"){
                ReadInstallerCurs($curs)
            }
        }
    }
}
function ReadInstallerCurs($curs){
            
                ShowInstallMenu
                $installcurs = Read-Host "installcurs #"
                Clear-Host
                switch ($installcurs) {
                    $installcurs {
                        if ($installcurs -eq 'q') {
                            $installcurs = 0
                            break
                        }
                        elseif ($installcurs -eq 'x') {
                            exit
                        }
                        Installation
                        ReadInstallerCurs($curs)
                        Clear-Host
                    }
                }
            
                #ShowMenu
        }



function Installation(){
    Invoke-Expression $menu.global.$curs.mymenu[$installcurs-1][1]
}

# ����� �� ����� ������������� ����
function ShowInstallMenu()
{

Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host ($menu.global.$curs | Select-Object -ExpandProperty "message") -ForegroundColor Yellow
Write-Host "----------------------------------------------------" -ForegroundColor Green

# 
    $counter = $menu.global.$curs.mymenu.Count
    
    for ($n=0; $n -lt $counter; $n++){
    Write-Host $menu.global.$curs.mymenu[$n][0] -Separator "`n"
    }

#
Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host "       Q. [�����]                  X. [�����]       "
Write-Host "----------------------------------------------------" -ForegroundColor Green

}
# ����� �� ����� ���� ���������
function ShowMenu()
{

Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host ($menu.global.$curs | Select-Object -ExpandProperty "message") -ForegroundColor Yellow
Write-Host "----------------------------------------------------" -ForegroundColor Green

    Write-Host $menu.global.$curs.mymenu -Separator "`n"

Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host "       Q. [�����]                  X. [�����]       "
Write-Host "----------------------------------------------------" -ForegroundColor Green

}

# main
# ����������� Chocolatey
Write-Host "�������� ���������� �� Choco..." -ForegroundColor Yellow
try {
    choco version
    Clear-Host
}
catch {
#    Write-Host "Choco �� ����������"
#    Return
    Write-Host "������ ��������� Choco, ��������� ���������." -ForegroundColor Green

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}


while ($true) {
    ShowMenu
    ReadCurs
}

