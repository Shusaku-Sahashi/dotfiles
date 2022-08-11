##########################################################################################
### WSL�ŋN�������v���Z�X��Emulator��Lan����Q�Ƃ���ۂɁA�|�[�g�t�H���[�h����K�v������B
### �������������X�N���v�g�B
##########################################################################################


## Created command referring below article.
## https://stackoverflow.com/a/62765432

param (
    $listenaddress = '127.0.0.1',
    $connectaddress,
    [array]$ports,
    [switch]$show,
    [switch]$reset,
    [switch]$help
)

Function AddPortProxyConf(){
    $remoteport = bash.exe -c "ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
    $found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

    if ($found)
    {
        $remoteport = $matches[0];
        echo "[wslbridge] Found WSL IP address: $remoteport"
    }
    else
    {
        write-host "[wslbridge] The Script Exited, the ip address of WSL 2 cannot be found";
        exit;
    }

    if ($connectaddress)
    {
        $remoteport = $connectaddress
    }

    foreach($port in $ports){
        $comm = "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenaddress;"
        $comm += "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenaddress connectport=$port connectaddress=$remoteport;";
        ExecuteAsAdmin $comm

        write-host "[wslbridge] Port $port configured: (Listen address: $listenaddress, Connect address: $remoteport)"
    }

    netsh interface portproxy show all
}

Function ShowHelp() {
    Write-Host "show => show all portproxys configured." -ForegroundColor Yellow
    Write-Host "reset => reset all portproxys configured."  -ForegroundColor Yellow
    Write-Host "ports (-ports 8081,3333)"  -ForegroundColor Yellow
    Write-Host "listenaddress (-listenaddress 127.0.0.1)"  -ForegroundColor Yellow
    Write-Host "connectaddress (-connectaddress 127.0.0.1)"  -ForegroundColor Yellow
}

Function ExecuteAsAdmin([string] $command) {
    ## Escalate administrator.
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators"))
    {
       Start-Process powershell -Verb RunAs -ArgumentList $command
    }
}


if ($help) {
    ShowHelp
    exit;
} elseif ($show) {
    netsh interface portproxy show all
    exit;
} elseif ($reset) {
    ExecuteAsAdmin "netsh interface portproxy reset"
    exit;
} elseif ($ports.Length -ge 1) {
    AddPortProxyConf
    exit;
}

Write-Host "Specified arguments are not supported" -ForegroundColor Red
ShowHelp
exit;