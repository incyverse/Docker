# PowerShell.exe -ExecutionPolicy Bypass -File <filename>
# PowerShell.exe -ExecutionPolicy Bypass -File .\wsl2-networks.ps1
$remote_port = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remote_port -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if ($found) {
    $remote_port = $matches[0];
} else {
    echo "The Script Exited, the ip address of WSL 2 cannot be found.";
    exit;
}

#[Ports]
#All the ports you want to forward separated by coma
$ports=@(
    80,
    443,
    3000,
    5432,
    8111,
    20000,
    20001,
    20002,
    20003
);

#[Static ip]
#You can change the addr to yur ip config to listen to a specific address
$addr='0.0.0.0';
$ports_a = $ports -join ",";

#Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

for ($i = 0; $i -lt $ports.length; $i++) {
    $port = $ports[$i];
    iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
    iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remote_port";
}