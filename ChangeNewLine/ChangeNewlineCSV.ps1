Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Создание файлового диалога csv файла
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (*.csv)|*.csv'
}
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$outputpath = [Environment]::GetFolderPath('Desktop')

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Исправление новых строк CSV'
$form.Size = New-Object System.Drawing.Size(540,340)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20,40)
$label.Size = New-Object System.Drawing.Size(360,20)
$label.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
$label.Text = 'Выберите файл csv для исправления:'
$form.Controls.Add($label)

$labelpath = New-Object System.Windows.Forms.Label
$labelpath.Location = New-Object System.Drawing.Point(20,60)
$labelpath.Size = New-Object System.Drawing.Size(360,20)
$labelpath.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Regular)
$labelpath.Text = 'Путь не выбран'
$form.Controls.Add($labelpath)

$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Location = New-Object System.Drawing.Point(20,160)
$labelStatus.Size = New-Object System.Drawing.Size(360,20)
$labelStatus.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Regular)
$labelStatus.ForeColor = "#005676"
$labelStatus.Text = 'Ожидание...'
$form.Controls.Add($labelStatus)

$labelSavePath = New-Object System.Windows.Forms.Label
$labelSavePath.Location = New-Object System.Drawing.Point(20,100)
$labelSavePath.Size = New-Object System.Drawing.Size(360,20)
$labelSavePath.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
$labelSavePath.Text = 'Место сохранения файла:'
$form.Controls.Add($labelSavePath)

$labelSavePathValue = New-Object System.Windows.Forms.Label
$labelSavePathValue.Location = New-Object System.Drawing.Point(20,120)
$labelSavePathValue.Size = New-Object System.Drawing.Size(360,20)
$labelSavePathValue.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Regular)
$labelSavePathValue.Text = $outputpath
$form.Controls.Add($labelSavePathValue)

$selectCsvButton = New-Object System.Windows.Forms.Button
$selectCsvButton.Location = New-Object System.Drawing.Point(380,40)
$selectCsvButton.Size = New-Object System.Drawing.Size(120,30)
$selectCsvButton.Font = New-Object System.Drawing.Font("Verdana",10,[System.Drawing.FontStyle]::Regular)
$selectCsvButton.Text = 'Выбрать CSV'
$selectCsvButton.Add_Click({
    $isCsvReady = $FileBrowser.ShowDialog()
    if($FileBrowser.FileName.Contains(".csv")){
        $labelpath.Text = $FileBrowser.FileName    
    }
})
$form.Controls.Add($selectCsvButton)

$saveCsvButton = New-Object System.Windows.Forms.Button
$saveCsvButton.Location = New-Object System.Drawing.Point(380,100)
$saveCsvButton.Size = New-Object System.Drawing.Size(120,30)
$saveCsvButton.Font = New-Object System.Drawing.Font("Verdana",10,[System.Drawing.FontStyle]::Regular)
$saveCsvButton.Text = 'Расположение'
$saveCsvButton.Add_Click({
    $FolderBrowser.ShowDialog()
    if ($FolderBrowser.SelectedPath -ne "") {
        $labelSavePathValue.Text = $FolderBrowser.SelectedPath
        $outputpath = $FolderBrowser.SelectedPath
    }
})
$form.Controls.Add($saveCsvButton)

$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(20,210)
$startButton.Size = New-Object System.Drawing.Size(150,40)
$startButton.Font = New-Object System.Drawing.Font("Verdana",10,[System.Drawing.FontStyle]::Regular)
$startButton.Text = 'OK'
$startButton.Add_Click({
    # Проверка на загруженность файла
    if($FileBrowser.FileName.Contains(".csv")){
        $csv = $FileBrowser.FileName.Trim(".csv") + '_buffer.csv'
        Get-Content $FileBrowser.FileName | where {$_ -notmatch '^(\t* *)$'} > $csv
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList ($csv)
        $writer = New-Object System.IO.StreamWriter -ArgumentList ((CheckFolder($FolderBrowser.SelectedPath)), $false, [System.Text.Encoding]::UTF8)
        $bufferString = ""

        while ($read = $reader.ReadLine()){
            if($read.IndexOf('"').Equals(0)) {
                if ($bufferString -ne "" -and $bufferString.EndsWith('"')){
                    $writer.WriteLine($bufferString);
                    $bufferString = $read
                } else {
                    $bufferString += $read
                }
            } else {
                $bufferString += " " + $read
            }
            
        }
        $writer.WriteLine($bufferString);
        
        $writer.Close()
        $writer.Dispose()

        $labelStatus.ForeColor = "#826e27"
        $labelStatus.Text = "Первый этап завершен..."

        # Второй этап. Создание файлов на основе строки в "связи с".


    } else {
        $labelStatus.ForeColor = "Red"
        $labelStatus.Text = "Ошибка выполнения"
    }
})
$form.AcceptButton = $startButton
$form.Controls.Add($startButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(190,210)
$cancelButton.Size = New-Object System.Drawing.Size(150,40)
$cancelButton.Font = New-Object System.Drawing.Font("Verdana",10,[System.Drawing.FontStyle]::Regular)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

function CheckFolder($formFolder) {
    if ($formFolder -eq "") {
        return ($outputpath + "\zayavki.csv")
    } else {
        return ($formFolder + "\zayavki.csv")
    };
}

$result = $form.ShowDialog()
