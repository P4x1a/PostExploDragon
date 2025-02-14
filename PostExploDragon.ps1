param (
    [string]$outputFile = "$([Environment]::GetFolderPath('Desktop'))\scan_result.csv"
)

function Show-ProgressMessage {
    param ([string]$message)
    Write-Host "`n$message" -ForegroundColor Green
}

function Start-AlertSound {
    [console]::beep(800, 500)  # Beep mais longo
    Start-Sleep -Milliseconds 300
    [console]::beep(1200, 500)  # Beep com tom diferente
}

function Show-MacabreMonsterEffect {
    $monster = @"
           ___====-_  _-====___
        _--^^^#####//      \\#####^^^--_
     _-^##########// (    ) \\##########^-_
    -############//  |\^^/|  \\############-
  _/############//   (@::@)   \\############\_
 /#############((     \\//     ))#############\
-###############\\    (oo)    //###############-
-#################\\  / UUU \  //#################-
-###################\\/  (   )  \//###################-
_#/|##########/\######(   /   )######/\##########|\#_
|/ |#/\#/\#/\/  \#/\##\  ( /   \ )  /##/\#/  \/\#/\#| \
`  |/  V  |/    |/   |  ( |   | )  |   |   |   |  |   |
   `   '   `     `   `   `   `   `   `   `   `   `   `
"@

    $hackedText = @"
 H   H    A    CCCCC K   K EEEEE DDDD  
 H   H   A A   C     K  K  E     D   D 
 HHHHH  AAAAA  C     KKK   EEEE  D   D 
 H   H  A   A  C     K  K  E     D   D 
 H   H  A   A  CCCCC K   K EEEEE DDDD  
"@

    1..10 | ForEach-Object {
        Write-Host $monster -ForegroundColor Red
        Write-Host $hackedText -ForegroundColor Red
        Start-Sleep -Milliseconds 500
        Clear-Host
        Start-Sleep -Milliseconds 500
    }
}

Add-Type -AssemblyName System.Windows.Forms

Show-ProgressMessage "Iniciando análise do sistema..."
Start-Sleep -Seconds 1

# Simulando a coleta de dados com menos distrações
Show-ProgressMessage "Coletando informações essenciais..."

$infoJob = Start-Job -ScriptBlock {
    param ($outputFile)

    function Invoke-SilentCommand {
        param ([scriptblock]$cmd)
        try { & $cmd 2>$null } catch {}
    }

    $infoSistema = Invoke-SilentCommand { Get-WmiObject Win32_ComputerSystem }
    $infoSO = Invoke-SilentCommand { Get-WmiObject Win32_OperatingSystem }
    $infoCPU = Invoke-SilentCommand { Get-WmiObject Win32_Processor }
    $infoMemoria = Invoke-SilentCommand { Get-WmiObject Win32_PhysicalMemory }
    $infoDiscos = Invoke-SilentCommand { Get-WmiObject Win32_LogicalDisk }
    $infoRede = Get-NetAdapter | Get-NetIPAddress
    $infoBIOS = Invoke-SilentCommand { Get-WmiObject Win32_BIOS }
    $infoUsuarios = Invoke-SilentCommand { Get-WmiObject Win32_UserAccount }
    $infoGrupos = Invoke-SilentCommand { Get-WmiObject Win32_Group }
    $infoServicos = Invoke-SilentCommand { Get-Service }
    $infoProcessos = Invoke-SilentCommand { Get-Process }
    $infoProgramas = Invoke-SilentCommand { Get-WmiObject Win32_Product }
    $infoEventos = Invoke-SilentCommand { Get-EventLog -LogName System -Newest 100 }
    $infoFirewall = Invoke-SilentCommand { Get-NetFirewallRule }
    $infoTasks = Invoke-SilentCommand { Get-ScheduledTask }

    $csvData = @()

    $csvData += [pscustomobject]@{Categoria="Sistema"; Nome="Nome"; Valor=$infoSistema.Name}
    $csvData += [pscustomobject]@{Categoria="Sistema Operacional"; Nome="Nome"; Valor=$infoSO.Caption}
    $csvData += [pscustomobject]@{Categoria="CPU"; Nome="Nome"; Valor=$infoCPU.Name}
    $csvData += [pscustomobject]@{Categoria="Memoria"; Nome="Capacidade"; Valor=([Math]::Round($infoMemoria.Capacity / 1GB, 2)) + " GB"}
    $csvData += [pscustomobject]@{Categoria="BIOS"; Nome="Versao"; Valor=$infoBIOS.SMBIOSBIOSVersion}

    foreach ($disco in $infoDiscos) {
        $csvData += [pscustomobject]@{Categoria="Discos"; Nome="Nome"; Valor=$disco.Name}
        $csvData += [pscustomobject]@{Categoria="Discos"; Nome="Espaço Livre"; Valor=([Math]::Round($disco.FreeSpace / 1GB, 2)) + " GB"}
    }

    foreach ($rede in $infoRede) {
        $csvData += [pscustomobject]@{Categoria="Rede"; Nome="Adaptador"; Valor=$rede.InterfaceAlias}
        $csvData += [pscustomobject]@{Categoria="Rede"; Nome="Endereco IP"; Valor=$rede.IPAddress}
    }

    foreach ($usuario in $infoUsuarios) {
        $csvData += [pscustomobject]@{Categoria="Usuarios"; Nome="Nome"; Valor=$usuario.Name}
    }

    foreach ($grupo in $infoGrupos) {
        $csvData += [pscustomobject]@{Categoria="Grupos"; Nome="Nome"; Valor=$grupo.Name}
    }

    foreach ($servico in $infoServicos) {
        $csvData += [pscustomobject]@{Categoria="Servicos"; Nome="Nome"; Valor=$servico.DisplayName}
        $csvData += [pscustomobject]@{Categoria="Servicos"; Nome="Status"; Valor=$servico.Status}
    }

    foreach ($processo in $infoProcessos) {
        $csvData += [pscustomobject]@{Categoria="Processos"; Nome="Nome"; Valor=$processo.Name}
        $csvData += [pscustomobject]@{Categoria="Processos"; Nome="ID"; Valor=$processo.Id}
    }

    foreach ($programa in $infoProgramas) {
        $csvData += [pscustomobject]@{Categoria="Programas"; Nome="Nome"; Valor=$programa.Name}
        $csvData += [pscustomobject]@{Categoria="Programas"; Nome="Versao"; Valor=$programa.Version}
    }

    foreach ($evento in $infoEventos) {
        $csvData += [pscustomobject]@{Categoria="Eventos"; Nome="Fonte"; Valor=$evento.Source}
        $csvData += [pscustomobject]@{Categoria="Eventos"; Nome="Mensagem"; Valor=$evento.Message}
    }

    foreach ($firewall in $infoFirewall) {
        $csvData += [pscustomobject]@{Categoria="Firewall"; Nome="Nome"; Valor=$firewall.DisplayName}
        $csvData += [pscustomobject]@{Categoria="Firewall"; Nome="Status"; Valor=$firewall.Enabled}
    }

    foreach ($task in $infoTasks) {
        $csvData += [pscustomobject]@{Categoria="Tarefas Agendadas"; Nome="Nome"; Valor=$task.TaskName}
        $csvData += [pscustomobject]@{Categoria="Tarefas Agendadas"; Nome="Status"; Valor=$task.State}
    }

    # Salvar as informações em um arquivo CSV
    $csvData | Export-Csv -Path $outputFile -NoTypeInformation

} -ArgumentList $outputFile

# Somente 2 mensagens de progresso para distração mais eficiente
Show-ProgressMessage "Coletando dados... Aguarde."
Wait-Job $infoJob | Out-Null
Remove-Job $infoJob
Start-Sleep -Seconds 1

# Adicionando mais distrações rápidas enquanto os dados são coletados
Show-ProgressMessage "Verificando falhas de segurança..."
Start-Sleep -Seconds 2

Show-ProgressMessage "Salvando dados..."
Start-Sleep -Seconds 2

# Finalizando a execução e exibindo a mensagem de hackeamento
Show-ProgressMessage "Sistema comprometido com sucesso."
Show-ProgressMessage "Você foi hackeado. Relatório gerado: $outputFile"
Start-AlertSound

# Exibindo efeito de monstro aterrorizante após revelar hackeamento
Show-MacabreMonsterEffect
