*** Settings *** 
Library          zi4pitstop.lib.pitstop 

*** Variables ***
${dut}  ap
${lan_client_1}  ap_lan_client_1
${lan_client_2}  ap_lan_client_2
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1
${wan_ip}  172.16.0.62
${count}      4

*** Test Cases ***

Verify Internet connectivity From Dut - ping 8.8.8.8
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}    Ping Ipv4    ${dut}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

Verify Internet connectivity From Dut - ping google.co.in
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}    Ping Ipv4    ${dut}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

Verify Internet connectivity - Ethernet Client1 - ping 8.8.8.8
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}  Ping Ipv4  ${lan_client_1}  ${public_dns}  ${count}
    Should Be True  ${loss} < ${5}

Verify Internet connectivity - Ethernet Client2 - ping 8.8.8.8
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}  Ping Ipv4  ${lan_client_2}  ${public_dns}  ${count}
    Should Be True  ${loss} < ${5}

Verify Internet connectivity - Ethernet Client1 - ping google.co.in
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}  Ping Ipv4  ${lan_client_1}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

Verify Internet connectivity - Ethernet Client2 - ping google.co.in
    [Tags]    Ethernet    SMOKE_SANITY
    ${loss}  Ping Ipv4  ${lan_client_1}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

Verify LAN connectivity - Ping from DUT to Ethernet Client1
    [Tags]    Ethernet    SMOKE_SANITY
    ${ip}  Get Client Ipv4  ${lan_client_1}
    Log To Console  \n${lan_client_1}:${ip}
    ${loss}  Ping IPV4  ${dut}  ${ip}  ${COUNT}
    Should Be True  ${loss} < ${5}

Verify LAN connectivity - Ping from DUT to Ethernet Client2
    [Tags]    Ethernet    SMOKE_SANITY
    ${ip}  Get Client Ipv4  ${lan_client_2}
    Log To Console  \n${lan_client_2}:${ip}
    ${loss}  Ping IPV4  ${dut}  ${ip}  ${COUNT}
    Should Be True  ${loss} < ${5}

Verify LAN connectivity - Ping between Ethernet Client1 To Ethernet Client2
    [Tags]    Ethernet    SMOKE_SANITY
    ${ip}  Get Client Ipv4  ${lan_client_2}
    Log To Console  \n${lan_client_2}:${ip}
    ${loss}  Ping IPv4  ${lan_client_1}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

Verify LAN connectivity - Ping between Ethernet Client2 To Ethernet Client1         
    [Tags]    Ethernet    SMOKE_SANITY
    ${ip}  Get Client Ipv4  ${lan_client_1}
    Log To Console  \n${lan_client_1}:${ip}
    ${loss}  Ping IPv4  ${lan_client_2}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

Verify IP address is assigned to WAN Interface
    [Tags]    ETHERNET    SMOKE_SANITY  TEST
    ${ip}  Get Dut Wan Ipv4    ${dut}
    Log To Console   \n${dut}:${ip}
    Should Match    ${ip}    ${wan_ip}

Verify IP address is assigned to br-lan Interface
    [Tags]    ETHERNET    SMOKE_SANITY  TEST
    ${ip}    Get Dut Bridge Ipv4    ${dut}
    Log To Console   \n${dut}:${ip}
    Should Match    ${ip}    ${bridge_ip}
