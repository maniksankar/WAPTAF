*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup      This Suite Setup
Suite Teardown   This Suite Teardown
 
*** Variables ***
${dut}    ap
${wlan_client_1}    dev_ap_wc_1
${wlan_client_2}  dev_ap_wc_2
${5g_radio_index}    5g_radio_index
${5g_iface_index}    5g_iface_index
${5g_ssid_index}    5g_ssid_index
${5g_ap_index}    5g_ap_index
${htmode}  80
${open_ap}    none


${htmode_2}  160
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1
${count}      4
${htmode_3}    40
${htmode_4}    20


*** Keywords ***

This Suite Setup
    Initialize Database    ${CONFIG_DIR}
    Connect With Device    ${dut}
    Connect With Device    ${wlan_client_1}
    Connect With Device    ${wlan_client_2}

This Suite Teardown
    Close Connection    ${dut}
    Close Connection    ${wlan_client_1}
    Close Connection    ${wlan_client_2}

CCheck If Device Is Alive
    [Arguments]    ${device}
    ${result}    Is Device Alive    ${device}
    Skip If    ${result} == ${False}    SKIP: The device ${device} is not accessible

Check If Radio Is Enabled In The Ap
    [Arguments]    ${dut}    ${index}
    ${status}    ${msg}=    Run Keyword And Ignore Error    Check Interface    ${dut}    ${index}
    Skip If    '${status}' == 'FAIL'    SKIP: Radio Index ${index} Is Not Enbled

Check If Radio Is Enabled In Wlan Client
    [Arguments]    ${client}
    ${state}    Get Client Radio State    ${client}
    Skip If    ${state} != 1    SKIP: The device ${client} is not accessible
    Make Client To Default State    ${client}

Initial Check Ap And Its 5G Radio
    Test Precondition

Initial Check Ap And Its 5G Radio And Wlan Client 1
    Test Precondition
    Make Client To Default State    ${wlan_client_1}

Initial Check AP And Its 5G Radio And Wlan Client 2
    Test Precondition
    Make Client To Default State    ${wlan_client_2}

Initial Check AP And Its 5G Radio And Wlan Client 1 And Client 2
    Test Precondition
    Make Client To Default State    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_2}
  

Get 5G Ssid 1
    ${ssid}    Read From Database    ${dut}    5g_ssid_1
    RETURN    ${ssid}

Get 5G Ssid 2
    ${ssid}    Read From Database    ${dut}    5g_ssid_2
    RETURN    ${ssid}

Get Password 1
    ${ssid}    Read From Database    ${dut}    passphrase_1
    RETURN    ${ssid}

Get Password 2
    ${ssid}    Read From Database    ${dut}    passphrase_2
    RETURN    ${ssid}

Get Bandwidth 20MHz
    ${bandwidth}    Read From Database    ${dut}    bandwidth_20
    RETURN    ${bandwidth}

Get Bandwidth 40MHz
    ${bandwidth}    Read From Database    ${dut}    bandwidth_40 
    RETURN    ${bandwidth}

Get Bandwidth 80MHz
    ${bandwidth}    Read From Database    ${dut}    bandwidth_80
    RETURN    ${bandwidth} 

Get Operating Standard axa
    ${standard}    Read From Database    ${dut}    operating_standard_axa
    RETURN    ${standard}

Get Bandwidth 160MHz
    ${bandwidth}    Read From Database    ${dut}     bandwidth_160
    RETURN    ${bandwidth} 

Get Operating Standard na
    ${standard}    Read From Database    ${dut}    operating_standard_na
    RETURN    ${standard}

Get Operating Standard ac
    ${standard}    Read From Database    ${dut}    operating_standard_ac
    RETURN    ${standard}

Get Encryption WPA2
    ${encryption}    Read From Database    ${dut}    security_wpa3_personal_psk2
    RETURN    ${encryption} 


Get Encryption WPA2-Personal
    ${encryption}    Read From Database    ${dut}     security_wpa2_personal
    RETURN     ${encryption}

Get Encryption WPA3
    ${encryption}    Read From Database    ${dut}     security_wpa3_personal
    RETURN     ${encryption}    

Get Encryption security_wpa3_mixed
    ${encryption}    Read From Database    ${dut}     security_wpa3_mixed
    RETURN     ${encryption}    
 
Get Region Domain US
    ${domain}    Read From Database    ${dut}     reg_domain_us
    RETURN     ${domain} 

Get Region Domain DE
    ${domain}    Read From Database    ${dut}     reg_domain_de
    RETURN     ${domain} 
    

Get Encryption Security_none
    ${security_none}    Read From Database    ${dut}     security_none
    RETURN     ${security_none}   

Get Channel 40
    ${channel_1}    Read From Database    ${dut}    5g_channel_40 
    RETURN    ${channel_1}

Get Channel 36
    ${channel_1}    Read From Database    ${dut}    5g_channel_36 
    RETURN    ${channel_1} 

Get Channel 44
    ${channel}    Read From Database    ${dut}    5g_channel_44
    RETURN    ${channel}





Test Precondition
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption_wpa2_personal}    Get Encryption WPA2-Personal
    ${bandwidth_80}    Get Bandwidth 80MHz
    ${standard_axa}    Get Operating Standard axa
    ${channel_1}    Get Channel 36


    Set Radio State    ${dut}    ${5g_radio_index}  ${1}
    Set Interface From Database    ${dut}    ${5g_iface_index}
    Set Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption_wpa2_personal}
    Set Password    ${dut}    ${5g_ap_index}    ${password_1}
    Set Channel    ${dut}    ${5g_radio_index}    ${channel_1}
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth_80}
    Set Radio Standard     ${dut}    ${5g_radio_index}   ${standard_axa}
    #Set Regulatory Domain    ${dut}    2g_radio_index    ${reg_domain}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Radio State    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${1}
    Wait Until Keyword Succeeds    30    3    Check Interface    ${dut}    ${5g_iface_index}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption_wpa2_personal}
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${5g_radio_index}    ${channel_1}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode} 
    ${ret}    Get Radio Standard    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${standard_axa}
    #Check Regulatory Domain    ${dut}    2g_radio_index    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${password_1}
    # Remove All Wifi Connections    ap_wlan_client_1
    #Make Client To Default State    ap_wlan_client_1
    #Make Client To Default State    ${wlan_client_2}

Make Client To Default State
    [Arguments]    ${client}
    Remove All Wifi Connections    ${client}
    # Set Client Interface State    ${client}    ${0}
    # ${state}    Get Client Interface State    ${client}
    # Should Be Equal    ${state}    ${0}
    # Sleep    5
    # Set Client Radio State    ${client}    ${0}
    # ${state}    Get Client Radio State    ${client}
    # Should Be Equal    ${state}    ${0}
    # Sleep    5
    # Set Client Radio State    ${client}    ${1}
    # ${state}    Get Client Radio State    ${client}
    # Should Be Equal    ${state}    ${1}
    # Sleep    5
    # Set Client Interface State    ${client}    ${1}
    # ${state}    Get Client Interface State    ${client}
    # Should Be Equal    ${state}    ${1}

Client Should Be Connected With Ssid
    [Arguments]    ${client}    ${ssid}
    ${ret}  Get Client Connected Ssid  ${client}
    Should Be Equal  ${ssid}  ${ret}

Check And Connect A Client To A Secured Ssid
    [Arguments]    ${client}    ${ssid}    ${password}
    Wait Until Keyword Succeeds    60    3    Check Ap Ssid Visibility   ${client}   ${ssid}
    Wait Until Keyword Succeeds    60    3    Connect Client To Ssid   ${client}   ${ssid}   ${password}
    Wait Until Keyword Succeeds    60    3    Client Should Be Connected With Ssid    ${client}    ${ssid}
    
Configure And Check The Bandwidth
    [Arguments]    ${bandwidth_2}
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    1
    # Set Prop Coext   ${dut}    ${index}
    # Set Prop Cfg     ${dut}    ${index}
    #Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_2}

Configure And Check The Encryption
    [Arguments]    ${encryption}
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  1

*** Test Cases ***
TS02001: Verify WIFI Client1 are getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC02002: Verify WIFI Client2 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TS02003: Verify WIFI Client1 are getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Ipv4    ${wlan_client_1}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_1} IPV4 address : ${ret}

TC02004: Verify WIFI Client2 is getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Ipv4    ${wlan_client_2}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_2} IPV4 address : ${ret}

TS02005: Verify Internet connectivity - WIFI Client1 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TS02006: Verify Internet connectivity - WIFI Client2 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TS02007: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TS02008: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TS02009: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    ${wlan_client_1}
    Log To Console    ${wlan_client_1} : ${ip}
    ${loss}    Ping Ipv4    ap    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02010: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console    ${wlan_client_2} : ${ip}
    ${loss}    Ping Ipv4    ${dut}    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02011: Verify WLAN connectivity - Ping from WIFI Client1 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}  Get Dut Bridge Ipv4    ap
    Log To Console  ap : ${ip}
    ${loss}  Ping Ipv4  ${wlan_client_1}    ${ip}    ${count}
    Should Be True  ${loss} < ${5}

TS02012: Verify WLAN connectivity - Ping from WIFI Client2 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Dut Bridge Ipv4  ap
    Log To Console  ap : ${ip}
    ${loss}  Ping Ipv4  dev_ap_wc_2    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02013: Verify WLAN connectivity - Ping between WIFI Client1 To Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1    DEV_AP_WC_2
    Initial Check AP And Its 5G Radio And Wlan Client 1 And Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Client Ipv4     dev_ap_wc_1
    Log To Console  dev_ap_wc_2  : ${ip}
    ${loss}  Ping Ipv4  dev_ap_wc_2  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TS02014: Verify WLAN connectivity - Ping between WIFI Client2 To Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1     DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 1 And Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Client Ipv4    dev_ap_wc_2
    Log To Console  dev_ap_wc_2 : ${ip}
    ${loss}  Ping Ipv4    dev_ap_wc_1    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TS02015: Changing Channel to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${channel}    Get Channel 44
    Set Channel    ${dut}    ${5g_radio_index}    ${channel}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Channel    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${5g_radio_index}    ${channel}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ret}  Get Client Channel   dev_ap_wc_1
    Should Be Equal  ${ret}  ${channel}

TS02016: Changing Channel to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${channel_2}    Get Channel 44
    Set Channel    ${dut}    ${5g_radio_index}    ${channel_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Channel    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${channel_2}
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${5g_radio_index}    ${channel_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ret}  Get Client Channel   dev_ap_wc_2
    Should Be Equal  ${ret}  ${channel_2}

TS02017: Changing bandwidth to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1 
    ${domain}    Get Region Domain US
    ${bandwidth_2}    Get Bandwidth 160MHz
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth_2}
    Set Regulatory Domain    ${dut}    ${domain}  
    #Sleep  3
    Check Regulatory Domain    ${dut}    ${5g_radio_index}    ${domain}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Bandwidth     dev_ap_wc_1
    Should Not Be Empty    ${ret}

TS02018: Changing bandwidth to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1 
    ${domain}    Get Region Domain US
    ${bandwidth_2}    Get Bandwidth 160MHz
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth_2}
    Set Regulatory Domain    ${dut}    ${domain}  
    #Sleep  3
    Check Regulatory Domain    ${dut}    ${5g_radio_index}    ${domain}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    20    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Bandwidth     dev_ap_wc_2
    Should Not Be Empty  ${ret} 

TC02019: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${bandwidth_2}    Get Bandwidth 160MHz
    Configure And Check The Bandwidth    ${bandwidth_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}    
    ${ip}    Get Client Ipv4    dev_ap_wc_1
    Log To Console   dev_ap_wc_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02020: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${bandwidth_2}    Get Bandwidth 160MHz
    Configure And Check The Bandwidth    ${bandwidth_2}
    Wait Until Keyword Succeeds    30    3    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_2
    Log To Console   dev_ap_wc_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02021: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${bandwidth_2}    Get Bandwidth 160MHz
    Configure And Check The Bandwidth    ${bandwidth_2}   
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02022: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2 
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${bandwidth_2}    Get Bandwidth 160MHz
    Configure And Check The Bandwidth    ${bandwidth_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_2  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02023: Changing SSID to 5GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_2}    Get 5G Ssid 2
    ${password_2}    Get Password 2
    Set Ssid    ${dut}    ${5g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${5g_ap_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${5g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Password    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password_2}

TC02024: Changing SSID to 5GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_2}    Get 5G Ssid 2
    ${password_2}    Get Password 2
    Set Ssid    ${dut}    ${5g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${5g_ap_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${5g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Password    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password_2}

TC02025: Verify STA1 association to 5GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${open_ap}    Get Encryption Security_none
    Set Encryption    ${dut}    ${5g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC02026: Verify STA2 association to 5GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1  
    ${open_ap}    Get Encryption Security_none
    Set Encryption    ${dut}    ${5g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
#########################
TC02027: Change Encryption (WPA2-Personal) method of 5GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC02028: Change Encryption (WPA2-Personal) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TC02029: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_1
    Log To Console   dev_ap_wc_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02030: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_2
    Log To Console   dev_ap_wc_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}


TC02031: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02032: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02033: Open_Source_Regression_11AXAHE40_OPEN_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${bandwidth}    Get Bandwidth 40MHz
    ${open_ap}    Get Encryption Security_none
    ${ssid_1}    Get 5G Ssid 1
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth}
    #Set Radio Standard   ${dut}   ${5g_radio_index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds   30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_3}
    #${ret}    Get Radio Standard    ${dut}    ${5g_radio_index}
    #Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02034: Open_Source_Regression_11NAHT20_OPEN_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${bandwidth}    Get Bandwidth 20MHz
    ${open_ap}    Get Encryption Security_none
    ${standard}    Get Operating Standard na
    ${ssid_1}    Get 5G Ssid 1
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth}
    Set Radio Standard   ${dut}   ${5g_radio_index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds   30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_4}
    ${ret}    Get Radio Standard    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Wait Until Keyword Succeeds   30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02035: Open_Source_Regression_11AXAHE80_WPA2_PSK_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${encryption}    Get Encryption WPA2
    ${ssid_1}    Get 5G Ssid 1
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds   30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02036: Open_Source_Regression_11NAHT40_WPA2_PSK_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${bandwidth}    Get Bandwidth 20MHz
    ${open_ap}    Get Encryption Security_none
    ${standard}    Get Operating Standard na
    ${ssid_1}    Get 5G Ssid 1
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth}
    Set Radio Standard   ${dut}   ${5g_radio_index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds   30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_4}
    ${ret}    Get Radio Standard    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Wait Until Keyword Succeeds   30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02037: Change Encryption (WPA2+WPA3) method of 5GHz Interface and verify with WiFi Client1 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption security_wpa3_mixed
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC02038: Change Encryption (WPA2+WPA3) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption security_wpa3_mixed
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TC02039: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_1
    Log To Console   dev_ap_wc_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02040: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_1
    Log To Console   dev_ap_wc_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02041: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02042: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02043: Change Encryption (WPA3-Personal) method of 5GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA3
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC02044: Change Encryption (WPA3-Personal) method of 5GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA3
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}


TC02045: Verify WLAN connectivity - Ping from DUT to WIFI Client1.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_1
    Log To Console   dev_ap_wc_1 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02046: Verify WLAN connectivity - Ping from DUT to WIFI Clients(client2).
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    dev_ap_wc_2
    Log To Console   dev_ap_wc_2 : ${ip}
    ${loss}  Ping Ipv4  ap  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC02047: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_1
    Initial Check Ap And Its 5G Radio And Wlan Client 1
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_1  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC02048: Verify Internet connectivity - WIFI Clients(client2) - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    DEV_AP_WC_2
    Initial Check Ap And Its 5G Radio And Wlan Client 2
    ${ssid_1}    Get 5G Ssid 1
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA2-Personal
    Configure And Check The Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4   dev_ap_wc_2    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC02049:Open_Source_Regression_11ACVHT80_WPA3_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${ssid_1}    Get 5G Ssid 1
    ${standard}    Get Operating Standard ac
    ${encryption}    Get Encryption WPA3
    Set Radio Standard   ${dut}   ${5g_radio_index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Radio Standard    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds   20    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02050: Open_Source_Regression_11AXAHE20_WPA3-SAE_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${encryption}    Get Encryption WPA2
    ${ssid_1}    Get 5G Ssid 1
    ${bandwidth}    Get Bandwidth 20MHz
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth}
    #Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds   30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_4}
    #${ret}    Get Radio Standard    ${dut}    ${index}
    #Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds   30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02051: Open_Source_Regression_11AXAHE160_WPA3_5G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G
    Initial Check Ap And Its 5G Radio
    ${ssid_1}    Get 5G Ssid 1
    ${bandwidth}    Get Bandwidth 160MHz
    ${encryption}    Get Encryption WPA3
    Set Bandwidth    ${dut}    ${5g_radio_index}    ${bandwidth}
    #Set Radio Standard   ${dut}   ${index}   ${standard}
    Set Encryption    ${dut}    ${5g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${5g_iface_index}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${5g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds   30    3    Check Bandwidth    ${dut}    ${5g_radio_index}    ${htmode_2}
    #${ret}    Get Radio Standard    ${dut}    ${index}
    #Should Be Equal    ${ret}    ${standard}
    ${ret}    Get Encryption    ${dut}    ${5g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds   30    3    Check Ssid    ${dut}    ${5g_ssid_index}    ${ssid_1}

TC02052: Set country code by using iw reg set
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    REG_DOMAIN
    Initial Check Ap And Its 5G Radio
    ${domain}    Get Region Domain US
    Set Regulatory Domain    ${dut}    ${domain}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${5g_radio_index}    ${domain}
    #Get Supported Channels Count    ${dut}    ${index}
    #Get Highest Supported Channel    ${dut}    ${index}    

TC02053: Change Country code & check Channel list
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G   REG_DOMAIN
    Initial Check Ap And Its 5G Radio
    ${domain_de}    Get Region Domain DE  
    Set Regulatory Domain    ${dut}    ${domain_de}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${5g_radio_index}    ${domain_de}
    # Get Supported Channels Count    ${dut}    ${index}
    # Get Highest Supported Channel    ${dut}    ${index}

TC02054: Reset Country code to US and Verify
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_5G    REG_DOMAIN
    Initial Check Ap And Its 5G Radio
    ${domain}    Get Region Domain US
    Set Regulatory Domain    ${dut}    ${domain}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${5g_radio_index}    ${domain}
    # Get Supported Channels Count    ${dut}    ${index}
    # Get Highest Supported Channel    ${dut}    ${index}

