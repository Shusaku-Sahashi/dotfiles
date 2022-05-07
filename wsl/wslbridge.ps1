##########################################################################################
### WSLで起動したプロセスをEmulatorやLanから参照する際に、ポートフォワードする必要がある。
### それを実現するスクリプト。
### Windows側のどこかに配置して、パスを通して使用する。
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
        iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenaddress";
        iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenaddress connectport=$port connectaddress=$remoteport";
        write-host "[wslbridge] Port $port configured: `nListen address: $listenaddress`nConnect address: $remoteport"
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

Function ChangeToAdmin() {
    ## Escalate administrator.
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators"))
    {
       Start-Process powershell.exe AddPortProxyConf -Verb RunAs; exit
    }
}


if ($help) {
    ShowHelp
    exit;
} elseif ($show) {
    netsh interface portproxy show all
    exit;
} elseif ($reset) {
    netsh interface portproxy reset
    exit;
} elseif ($ports.Length -ge 1) {
    ChangeToAdmin
    exit;
}

Write-Host "Specified arguments are not supported" -ForegroundColor Red
ShowHelp
exit;