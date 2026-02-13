*** Settings ***
Library            zi4pitstop.lib.pitstop


*** Variables ***
${BRIDGE_IPv4}  192.168.1.1
${BRIDGE_IPv6}  fd83:ca41:a56f::1
${LAN_CLIENT}   ap_lan_client_1
${DUT}          ap
${COUNT}        ${4}
${PUBLIC_DNS}   8.8.8.8
${WEBSITE}      google.com


*** Test Cases ***
Test Case ping From Dut To Lan Client - Ipv4
    [Tags]  PING
    ${ip}  Get Client Ipv4  ${LAN_CLIENT}
    Log To Console  \n${LAN_CLIENT}:${ip}
    ${loss}  Ping IPV4  ${DUT}  ${ip}  ${COUNT}
    Should Be True  ${loss} < ${5}

Test Case ping From Lan Client To Dut - Ipv4
    [Tags]  PING
    ${ip}  Get Client Ipv4  ${LAN_CLIENT}
    Log To Console  \n${LAN_CLIENT}:${ip}
    ${loss}  Ping IPv4  ${DUT}  ${ip}  ${COUNT}
    Should Be True  ${loss} < ${5}

Test Case ping From Dut To Public Dns - Ipv4
    [Tags]  PING
    ${loss}  Ping Ipv4  ${DUT}  ${PUBLIC_DNS}  ${COUNT}
    Should Be True  ${loss} < ${5}

Test Case ping From Lan Client To Dut - Ipv6
    [Tags]  PING
    Log To Console    \nAP_BRIDGE_IP: ${BRIDGE_IPv6}
    ${loss}  Ping Ipv6  ${LAN_CLIENT}  ${BRIDGE_IPv6}  ${COUNT}
    Should Be True  ${loss} < ${5}

Test Case ping From Lan Client To ${WEBSITE} - Ipv4
    [Tags]  PING
    ${loss}  Ping Ipv4  ${LAN_CLIENT}  ${WEBSITE}  ${COUNT}
    Should Be True  ${loss} < ${5}
