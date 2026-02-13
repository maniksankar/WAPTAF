*** Settings ***
Library            zi4pitstop.lib.pitstop
Test Setup    This Suite Precondition

*** Variables ***
${dut}    ap
${wlan_client_1}    ap_wlan_client_1
${wlan_client_2}  ap_wlan_client_2
${index}    5g_radio_index
${ssid}    pitstop_test_5g
${channel}    40
${bandwidth}    HT80
${htmode}  80
${open_ap}    none
${secured_ap}    psk2+ccmp
${reg_domain}    US
${standard}    11axa
${password}    Zilogic_123

${ssid_2}    zi4pitstop_5g
${channel_2}    ${44}
${bandwidth_2}    HT160
${htmode_2}  160
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
    #Set Regulatory Domain    ${dut}    2g_radio_index    ${reg_domain}
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
    #Check Regulatory Domain    ${dut}    2g_radio_index    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${index}
    Should Be Equal    ${ret}    ${password}
    # Remove All Wifi Connections    ap_wlan_client_1
    Make Client To Default State    ap_wlan_client_1
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
    Wait Until Keyword Succeeds    90    3    Connect Client To Ssid  ${client}  ${ssid}   ${password}
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
TS02001: Verify WIFI Client1 are getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02002: Verify WIFI Client2 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TS02003: Verify WIFI Client1 are getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ret}    Get Client Ipv4    ${wlan_client_1}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_1} IPV4 address : ${ret}

TC02004: Verify WIFI Client2 is getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ret}    Get Client Ipv4    ${wlan_client_2}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_2} IPV4 address : ${ret}

TS02005: Verify Internet connectivity - WIFI Clients - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TS02006: Verify Internet connectivity - WIFI Client2 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TS02007: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TS02008: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TS02009: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4    ${wlan_client_1}
    Log To Console    ${wlan_client_1} : ${ip}
    ${loss}    Ping Ipv4    ap    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02010: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console    ${wlan_client_2} : ${ip}
    ${loss}    Ping Ipv4    ap     ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02011: Verify WLAN connectivity - Ping from WIFI Client1 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DUT1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}  Get Dut Bridge Ipv4    ap
    Log To Console  ap : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TS02012: Verify WLAN connectivity - Ping from WIFI Client2 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G  DUT1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Dut Bridge Ipv4  ap
    Log To Console  ap : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02013: Verify WLAN connectivity - Ping between WIFI Client1 To Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Client Ipv4    ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TS02014: Verify WLAN connectivity - Ping between WIFI Client2 To Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}  Get Client Ipv4    ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4    ap_wlan_client_1    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02015: Changing Channel to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Channel    ${dut}    ${index}    ${channel_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Channel    ${dut}    ${index}
    Should Be Equal    ${ret}    ${channel_2}
    Check Channel    ${dut}    ${index}    ${channel_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ret}  Get Client Channel  ap_wlan_client_1
    Should Be Equal  ${ret}  ${channel_2}

TS02016: Changing Channel to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Channel    ${dut}    ${index}    ${channel_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Channel    ${dut}    ${index}
    Should Be Equal    ${ret}    ${channel_2}
    Check Channel    ${dut}    ${index}    ${channel_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ret}  Get Client Channel  ap_wlan_client_2
    Should Be Equal  ${ret}  ${channel_2}

TS02017: Changing bandwidth to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ret}    Get Client Bandwidth    ap_wlan_client_1
    Should Not Be Empty    ${ret}

TS02018: Changing bandwidth to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ret}    Get Client Bandwidth    ap_wlan_client_2
    Should Not Be Empty    ${ret}

TC02019: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}    
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02020: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02021: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02022: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Bandwidth
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02023: Changing SSID to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Ssid    ${dut}    ${index}    ${ssid_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Ssid    ${dut}    ${index}
    Should Be Equal    ${ret}    ${ssid_2}
    Check Ssid    ${dut}    ${index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password}

TC02024: Changing SSID to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Ssid    ${dut}    ${index}    ${ssid_2}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Ssid    ${dut}    ${index}
    Should Be Equal    ${ret}    ${ssid_2}
    Check Ssid    ${dut}    ${index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password}

TC02025: Verify STA1 association to 5GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02026: Verify STA2 association to 5GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02027: Change Encryption (WPA2-Personal) method of 5GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    psk2+ccmp
    Load Wifi    ${dut}
    Sleep  10
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02028: Change Encryption (WPA2-Personal) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    psk2+ccmp
    Load Wifi    ${dut}
    Sleep  10
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC02029: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02030: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02031: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02032: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02033: Open_Source_Regression_11AXAHE40_OPEN_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT40
    Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT40
    Check Bandwidth    ${dut}    ${index}    40
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02034: Open_Source_Regression_11NAHT20_OPEN_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT20
    Set Radio Standard   ${dut}   ${index}   11na
    Set Encryption    ${dut}    ${index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT20
    Check Bandwidth    ${dut}    ${index}    20
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11na
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${open_ap}
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02035: Open_Source_Regression_11AXAHE80_WPA2_PSK_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT80
    Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${index}    psk2
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT80
    Check Bandwidth    ${dut}    ${index}    80
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02036: Open_Source_Regression_11NAHT40_WPA2_PSK_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT40
    Set Radio Standard   ${dut}   ${index}   11na
    Set Encryption    ${dut}    ${index}    psk2
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT40
    Check Bandwidth    ${dut}    ${index}    40
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11na
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    psk2
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02037: Change Encryption (WPA2+WPA3) method of 5GHz Interface and verify with WiFi Client1 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    sae-mixed
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae-mixed
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02038: Change Encryption (WPA2+WPA3) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    sae-mixed
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae-mixed
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC02039: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02040: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02041: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02042: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02043: Change Encryption (WPA3-Personal) method of 5GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}

TC02044: Change Encryption (WPA3-Personal) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  3
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}

TC02045: Verify WLAN connectivity - Ping from DUT to WIFI Clients.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_1
    Log To Console  ap_wlan_client_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02046: Verify WLAN connectivity - Ping from DUT to WIFI Clients(client2).
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${ip}    Get Client Ipv4   ap_wlan_client_2
    Log To Console  ap_wlan_client_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02047: Verify Internet connectivity - WIFI Clients - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02048: Verify Internet connectivity - WIFI Clients(client2) - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Configure And Check The Encryption    psk2+ccmp
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid}    ${password}
    ${loss}  Ping Ipv4  ap_wlan_client_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02049:Open_Source_Regression_11ACVHT80_WPA3_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT80
    Set Radio Standard   ${dut}   ${index}   11ac
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT80
    Check Bandwidth    ${dut}    ${index}    80
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    11ac
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02050: Open_Source_Regression_11AXAHE20_WPA3-SAE_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    HT20
    Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    HT20
    Check Bandwidth    ${dut}    ${index}    20
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02051: Open_Source_Regression_11AXAHE160_WPA3_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep    3
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    sae
    Check Ssid    ${dut}    ${index}    ${ssid}

TC02052: Set country code by using iw reg set
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Regulatory Domain    ${dut}     US
    Sleep  3
    Check Regulatory Domain    ${dut}    ${index}    US
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}    

TC02053: Change Country code & check Channel list
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Regulatory Domain    ${dut}    DE
    Sleep  2
    Check Regulatory Domain    ${dut}    ${index}    DE
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}

TC02054: Reset Country code to US and Verify
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Set Regulatory Domain    ${dut}    US
    Sleep  2
    Check Regulatory Domain    ${dut}    ${index}    US
    Get Supported Channels Count    ${dut}    ${index}
    Get Highest Supported Channel    ${dut}    ${index}

