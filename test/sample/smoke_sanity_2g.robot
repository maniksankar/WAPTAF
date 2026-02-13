*** Settings *** 
Library          zi4pitstop.lib.pitstop 
#Suite Setup      This Suite Precondition
Test Setup    This Suite Precondition

*** Variables ***
${dut}    ap
${wlan_client_1}    ap_wlan_client_1
${wlan_client_2}  ap_wlan_client_2
${index}    2g_radio_index
${ssid}    pitstop_2g
${channel}    1
${bandwidth}    HT20
${htmode}  20
${open_ap}    none
${secured_ap}    psk2+ccmp
${reg_domain}    US
${standard}    11axg
${password}    Zilogic_123

${ssid_2}    zi4pitstop
${channel_2}    ${11}
${bandwidth_2}    HT40
${htmode_2}  40
${reg_domain_2}    DE
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1
${count}      4
  
*** Keywords ***

This Suite Precondition
    Set Radio State    ${dut}    ${index}  ${1}
    Set Interface From Database    ${dut}    ${index}
    Set Ssid    ${dut}    ${index}    ${ssid}
    Set Encryption    ${dut}    ${index}    ${secured_ap}
    Set Password    ${dut}    ${index}    ${password}
    Set Channel    ${dut}    ${index}    ${channel}
    Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Radio Standard     ${dut}    ${index}   ${standard}
    #Set Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    Load Wifi    ${dut}
    Sleep  5
    ${ret}    Get Radio State    ${dut}    ${index}
    Should Be Equal    ${ret}    ${1}
    Check Interface    ${dut}    ${index}
    Check Ssid    ${dut}    ${index}    ${ssid}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${secured_ap}
    Check Channel    ${dut}    ${index}    ${channel}
    Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    #Check Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${index}
    Should Be Equal    ${ret}    ${password}
    # Remove All Wifi Connections    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_2}

Make Client To Default State
    [Arguments]    ${client}
    Remove All Wifi Connections    ${client}
    Set Client Interface State    ${client}    ${0}
    ${state}    Get Client Interface State    ${client}
    Should Be Equal    ${state}    ${0}
    Sleep    5
    Set Client Radio State    ${client}    ${0}
    ${state}    Get Client Radio State    ${client}
    Should Be Equal    ${state}    ${0}
    Sleep    5
    Set Client Radio State    ${client}    ${1}
    ${state}    Get Client Radio State    ${client}
    Should Be Equal    ${state}    ${1}
    Sleep    5
    Set Client Interface State    ${client}    ${1}
    ${state}    Get Client Interface State    ${client}
    Should Be Equal    ${state}    ${1}

Client Should Be Connected With Ssid
    [Arguments]    ${client}    ${ssid}
    ${ret}  Get Client Connected Ssid  ${client}
    Should Be Equal  ${ssid}  ${ret}

Check And Connect A Client To A Secured Ssid
    [Arguments]    ${client}    ${ssid}    ${password}
    Wait Until Keyword Succeeds    30    3    Check Ap Ssid Visibility  ${client}  ${ssid}
    Wait Until Keyword Succeeds    30    3    Connect Client To Ssid  ${client}  ${ssid}   ${password}
    Wait Until Keyword Succeeds    30    3    Client Should Be Connected With Ssid    ${client}    ${ssid}
    
Configure And Check The Bandwidth
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}

Configure And Check The Encryption
    [Arguments]    ${encryption}
    Set Encryption    ${dut}    ${index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  10

Configure And Check The Sae Encryption
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  10

*** Test Cases ***
TC01001: Verify WIFI Client1 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01002: Verify WIFI Client2 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01003: Verify WIFI Client1 is getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ret}    Get Client Ipv4    ${wlan_client_1}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_1} IPV4 address : ${ret}

TC01004: Verify WIFI Client2 is getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ret}    Get Client Ipv4    ${wlan_client_2}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_2} IPV4 address : ${ret}

TC01005: Verify Internet connectivity - WIFI Client1 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TC01006: Verify Internet connectivity - WIFI Client2 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TC01007: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01008: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01009: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4    ${wlan_client_1}
    Log To Console    ${wlan_client_1} : ${ip}
    ${loss}    Ping Ipv4    ${dut}    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01010: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console    ${wlan_client_2} : ${ip}
    ${loss}    Ping Ipv4    ${dut}     ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01011: Verify WLAN connectivity - Ping from WIFI Client1 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DUT
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}  Get Dut Bridge Ipv4    ${dut}
    Log To Console  ${dut} : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01012: Verify WLAN connectivity - Ping from WIFI Client2 to DUT
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G  DUT
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Dut Bridge Ipv4  ${dut}
    Log To Console  ${dut} : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01013: Verify WLAN connectivity - Ping between WIFI Client1 To Client2.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Client Ipv4    ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01014: Verify WLAN connectivity - Ping between WIFI Client2 To Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Client Ipv4    ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4    ap_wlan_client_1    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01015: Changing Channel bandwidth to 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ret}    Get Client Bandwidth    ${wlan_client_1}
    Should Be Equal    ${ret}    40 MHz

TC01016: Changing Channel bandwidth to 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ret}    Get Client Bandwidth    ${wlan_client_2}
    Should Be Equal    ${ret}    40 MHz

TC01017: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}    
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01018: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01019: Verify Internet connectivity - WIFI Clients - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ${dut}_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01020: Verify Internet connectivity - WIFI Clients(client2) - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01021: Changing SSID to 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Ssid    ${dut}    ${index}    ${ssid_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Ssid    ${dut}    ${index}
    Should Be Equal    ${ret}    ${ssid_2}
    Check Ssid    ${dut}    ${index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password}

TC01022: Changing SSID to 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Ssid    ${dut}    ${index}    ${ssid_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Ssid    ${dut}    ${index}
    Should Be Equal    ${ret}    ${ssid_2}
    Check Ssid    ${dut}    ${index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password}

TC01023: Changing Channel to 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Channel    ${dut}    ${index}    ${channel_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Channel    ${dut}    ${index}
    Should Be Equal    ${ret}    ${channel_2}
    Check Channel    ${dut}    ${index}    ${channel_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01024: Changing Channel to 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Channel    ${dut}    ${index}    ${channel_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Channel    ${dut}    ${index}
    Should Be Equal    ${ret}    ${channel_2}
    Check Channel    ${dut}    ${index}    ${channel_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01025: Open_Source_Regression_11AXGHE20_OPEN_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    HT20
    Set Radio Standard   ${dut}   ${index}   11axg
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT20
    Check Bandwidth    ${dut}    ${index}    20
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11axg
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01026: Open_Source_Regression_11B_OPEN_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Radio Standard   ${dut}   ${index}   11b
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01027: Change Encryption (WPA2-Personal) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    psk2+ccmp
    Load Wifi    ${dut}
    Sleep  10
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01028: Change Encryption (WPA2-Personal) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    psk2+ccmp
    Load Wifi    ${dut}
    Sleep  10
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01029: Verify WLAN connectivity - Ping from DUT to WIFI Client1.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01030: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01031: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01032: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01033: Open_Source_Regression_11AXGHE40_WPA2_PSK_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Set Radio Standard   ${dut}   ${index}   11axg
    Set Encryption    ${dut}    ${index}    psk2
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep  2
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11axg
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01034: Open_Source_Regression_11G_WPA2_PSK_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Radio Standard   ${dut}   ${index}   11g
    Set Encryption    ${dut}    ${index}    psk2
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11g
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01035: Verify STA1 association to 2.4GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  30
    ${ret}  Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth}
    Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01036: Verify STA2 association to 2.4GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  30
    ${ret}  Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth}
    Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01037: Change Encryption (WPA3-Personal) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01038: Change Encryption (WPA3-Personal) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01039: Verify WLAN connectivity - Ping from DUT to WIFI Client1.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01040: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01041: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01042: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01043: Open_Source_Regression_11AXGHE40_WPA3-SAE_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Set Radio Standard   ${dut}   ${index}   11axg
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11axg
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01044: Change Encryption (WPA2+WPA3) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    sae-mixed
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae-mixed
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC01045: Change Encryption (WPA2+WPA3) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Encryption    ${dut}    ${index}    sae-mixed
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae-mixed
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC01046: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}   ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01049: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01050: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}   ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01051: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Configure And Check The Sae Encryption
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01052: Open_Source_Regression_11NGHT40_WPA3-SAE_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Set Bandwidth    ${dut}    ${index}    HT40
    Set Radio Standard   ${dut}   ${index}   11ng
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT40
    Check Bandwidth    ${dut}    ${index}    40
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11ng
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check Ssid    ${dut}    ${index}    ${ssid}

TC01053: Set country code by using iw reg set
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G   REG_DOMAIN
    Set Regulatory Domain    ${dut}     US
    Sleep  3
    Check Regulatory Domain    ${dut}    ${index}    US
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}    

TC01054: Change Country code & check Channel list
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    REG_DOMAIN
    Set Regulatory Domain    ${dut}    DE
    Sleep  2
    Check Regulatory Domain    ${dut}    ${index}    DE
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}

TC01055: Reset Country code to US and Verify
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G   REG_DOMAIN
    Set Regulatory Domain    ${dut}    US
    Sleep  2
    Check Regulatory Domain    ${dut}    ${index}    US
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}
