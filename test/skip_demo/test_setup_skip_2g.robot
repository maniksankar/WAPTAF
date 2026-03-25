*** Settings *** 
Library          zi4pitstop.lib.pitstop
Suite Setup      This Suite Setup
Suite Teardown   This Suite Teardown
Test Setup    Test Precondition

*** Variables ***
${dut}    ap
${wlan_client_1}    dev_ap_wc_1
${wlan_client_2}    dev_ap_wc_2
${2g_radio_index}    2g_radio_index
${2g_iface_index}    2g_iface_index
${2g_ssid_index}    2g_ssid_index
${2g_ap_index}    2g_ap_index
${channel}    1

${htmode}  20
${open_ap}    none
${reg_domain}    US
${channel_2}    ${11}
${bandwidth_2}    HT40
${htmode_2}  40
${reg_domain_2}    DE
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1
${count}      4
                                       
  
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

Check If Device Is Alive
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

Initial Check Ap And Its 2G Radio
    #Check If Device Is Alive    ${dut}
    #Check If Radio Is Enabled In The Ap    ${dut}    ${2g_radio_index}
    Test Precondition

Initial Check Ap And Its 2G Radio And Wlan Client 1
    #Initial Check Ap And Its 2G Radio
    #Check If Device Is Alive    ${wlan_client_1}
    #Check If Radio Is Enabled In Wlan Client    ${wlan_client_1}
    Test Precondition
    Make Client To Default State    ${wlan_client_1}

Initial Check AP And Its 2G Radio And Wlan Client 2
    #Initial Check Ap And Its 2G Radio
    #Check If Device Is Alive    ${wlan_client_2}
    #heck If Radio Is Enabled In Wlan Client    ${wlan_client_2}
    Test Precondition
    Make Client To Default State    ${wlan_client_2}

Initial Check AP And Its 2G Radio And Wlan Client 1 And Client 2
    #Initial Check Ap And Its 2G Radio
    #Check If Device Is Alive    ${wlan_client_1}
    #Check If Radio Is Enabled In Wlan Client    ${wlan_client_1}
    #Check If Device Is Alive    ${wlan_client_2}
    #Check If Radio Is Enabled In Wlan Client    ${wlan_client_2}
    Test Precondition
    Make Client To Default State    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_2}

Get 2G Ssid 1
    ${ssid}    Read From Database    ${dut}    2g_ssid_1
    RETURN    ${ssid}

Get 2G Ssid 2
    ${ssid}    Read From Database    ${dut}    2g_ssid_2
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

Get Operating Standard ax
    ${standard}    Read From Database    ${dut}    operating_standard_ax
    RETURN    ${standard}

Get Operating Standard b
    ${standard}    Read From Database    ${dut}    operating_standard_b
    RETURN    ${standard}

Get Operating Standard axg
    ${standard}    Read From Database    ${dut}    operating_standard_axg
    RETURN    ${standard} 

Get Operating Standard ng
    ${standard}    Read From Database    ${dut}    operating_standard_ng
    RETURN    ${standard}   

Get Operating Standard g
    ${standard}    Read From Database    ${dut}    operating_standard_g
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

Get Channel 1
    ${channel_1}    Read From Database    ${dut}    2g_channel_1 
    RETURN    ${channel_1}  

Get Channel 6
    ${channel_2}    Read From Database    ${dut}    2g_channel_6 
    RETURN    ${channel_2}    

Get Noscan
    ${no_scan}    Read From Database    ${dut}    no_scan
    RETURN    ${no_scan}


Test Precondition
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    ${encryption_wpa2_personal}    Get Encryption WPA2-Personal
    ${bandwidth_20}    Get Bandwidth 20MHz
    ${standard_ax}    Get Operating Standard ax
    ${channel_1}    Get Channel 1
    

    Set Radio State    ${dut}    ${2g_radio_index}  ${1}
    Set Interface From Database    ${dut}    ${2g_iface_index}
   
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_1}
    
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption_wpa2_personal} 
  
    Set Password    ${dut}    ${2g_ap_index}    ${password_1}
    Set Channel    ${dut}    ${2g_radio_index}    ${channel_1}
    
    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth_20}    
    
    Set Radio Standard     ${dut}    ${2g_radio_index}   ${standard_ax}
    #Set Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Radio State    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${1}
    Wait Until Keyword Succeeds    30    3    Check Interface    ${dut}    ${2g_iface_index}
    #Check Ssid    ${dut}    ${2g_iface_index}    ${ssid_1} 
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_iface_index}    ${ssid_1}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption_wpa2_personal} 
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${2g_iface_index}    ${channel_1}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${2g_iface_index}    ${htmode}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_ax}
    #Check Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${password_1}
    # Remove All Wifi Connections    ${wlan_client_1}
    #Make Client To Default State    ${wlan_client_1}
    #Make Client To Default State    ${wlan_client_2}

Make Client To Default State
    [Arguments]    ${client}
    Remove All Wifi Connections    ${client}
    #Set Client Interface State    ${client}    ${0}
    #${state}    Get Client Interface State    ${client}
    #Should Be Equal    ${state}    ${0}
    #Sleep    5
    #Set Client Radio State    ${client}    ${0}
    #${state}    Get Client Radio State    ${client}
    #Should Be Equal    ${state}    ${0}
    #Sleep    5
    #Set Client Radio State    ${client}    ${1}
    #${state}    Get Client Radio State    ${client}
    #Should Be Equal    ${state}    ${1}
    #Sleep    5
    #Set Client Interface State    ${client}    ${1}
    #${state}    Get Client Interface State    ${client}
    #Should Be Equal    ${state}    ${1}

Client Should Be Connected With Ssid
    [Arguments]    ${client}    ${ssid}
    ${ret}  Get Client Connected Ssid  ${client}
    Should Be Equal  ${ssid}  ${ret}

Check And Connect A Client To A Secured Ssid
    [Arguments]    ${client}    ${ssid}    ${password}
    Wait Until Keyword Succeeds    30    3    Check Ap Ssid Visibility  ${client}  ${ssid}
    Wait Until Keyword Succeeds    30    3    Connect Client To Ssid  ${client}  ${ssid}   ${password}
    Wait Until Keyword Succeeds    30    3    Client Should Be Connected With Ssid    ${client}    ${ssid}
    
Configure And Check The Bandwidth To 40MHz
    ${bandwidth}    Get Bandwidth 40MHz    
    ${no_scan}    Get Noscan
    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth}    ${noscan}
    Load Wifi    ${dut}
    Sleep   1
    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode_2}

Configure And Check The Encryption  
    [Arguments]    ${encryption}
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  1

Configure And Check The Sae Encryption
    [Arguments]    ${encryption}
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep  1

*** Test Cases ***
TC01001: Verify WIFI Client1 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC01002: Verify WIFI Client2 is getting connected in all the WLAN Interfaces
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TC01003: Verify WIFI Client1 is getting IP address from all the WLAN IntSet Bandwidth    
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Ipv4    ${wlan_client_1}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_1} IPV4 address : ${ret}

TC01004: Verify WIFI Client2 is getting IP address from all the WLAN Interfaces.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Ipv4    ${wlan_client_2}
    Should Not Be Empty  ${ret}
    Log To Console    ${WLAN_CLIENT_2} IPV4 address : ${ret}

TC01005: Verify Internet connectivity - WIFI Client1 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TC01006: Verify Internet connectivity - WIFI Client2 - ping 8.8.8.8
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${public_dns}    ${count}
    Should Be True    ${loss} < ${5}

TC01007: Verify Internet connectivity - WIFI Client1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_1}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01008: Verify Internet connectivity - WIFI Client2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}    Ping Ipv4    ${wlan_client_2}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01009: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4    ${wlan_client_1}
    Log To Console    ${wlan_client_1} : ${ip}
    ${loss}    Ping Ipv4    ${dut}    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01010: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console    ${wlan_client_2} : ${ip}
    ${loss}    Ping Ipv4    ${dut}     ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01011: Verify WLAN connectivity - Ping from WIFI Client1 to DUT.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DUT    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}  Get Dut Bridge Ipv4    ${dut}
    Log To Console  ${dut} : ${ip}
    ${loss}  Ping Ipv4  ${wlan_client_1}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01012: Verify WLAN connectivity - Ping from WIFI Client2 to DUT
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DUT    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Dut Bridge Ipv4  ${dut}
    Log To Console  ${dut} : ${ip}
    ${loss}  Ping Ipv4  ${wlan_client_2}    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01013: Verify WLAN connectivity - Ping between WIFI Client1 To Client2.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 1 And Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Client Ipv4    ${wlan_client_1}
    Log To Console  ${wlan_client_1} : ${ip}
    ${loss}  Ping Ipv4  ${wlan_client_2}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01014: Verify WLAN connectivity - Ping between WIFI Client2 To Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 1 And Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}  Get Client Ipv4    ${wlan_client_2}
    Log To Console  ${wlan_client_2} : ${ip}
    ${loss}  Ping Ipv4    ${wlan_client_1}    ${ip}    ${count}
    Should Be True    ${loss} < ${5}

TC01015: Changing Channel bandwidth to 40MHz For 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${bandwidth_2}   Get Bandwidth 40MHz
    ${no_scan}    Get Noscan
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Set Bandwidth    ${dut}    ${2g_ap_index}    ${bandwidth_2}    ${noscan}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    30   3   Check Bandwidth    ${dut}    ${2g_ap_index}    ${htmode_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Bandwidth    ${wlan_client_1}
    Should Be Equal    ${ret}    40 MHz

TC01016: Changing Channel bandwidth to 40MHz For 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Configure And Check The Bandwidth To 40MHz
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ret}    Get Client Bandwidth    ${wlan_client_2}
    Should Be Equal    ${ret}    40 MHz

TC01017: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Configure And Check The Bandwidth To 40MHz
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}    
    ${ip}    Get Client Ipv4   ${wlan_client_1}
    Log To Console  ${wlan_client_1} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01018: Verify WLAN connectivity - Ping from DUT to WIFI Client2
     [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
     Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Configure And Check The Bandwidth To 40MHz
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1} 
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console  ${wlan_client_2} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01019: Verify Internet connectivity - WIFI Client 1 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Configure And Check The Bandwidth To 40MHz
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${dut}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01020: Verify Internet connectivity - WIFI Client 2 - ping google.co.in
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_1}    Get 2G Ssid 1
    ${password_1}    Get Password 1
    Configure And Check The Bandwidth To 40MHz
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_2}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01021: Changing SSID to 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${ssid_2}    Get 2G Ssid 2 
    ${password_2}    Get Password 2
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${2g_ssid_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Password    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password_2}

TC01022: Changing SSID to 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${ssid_2}    Get 2G Ssid 2
    ${password_2}    Get Password 2
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${2g_ssid_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Password    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password_2}

TC01023: Changing Channel to 2.4GHz radio and verify with a WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${channel_2}    Get Channel 6
    ${ssid_2}    Get 2G Ssid 2
    ${password_2}    Get Password 2
    Set Channel    ${dut}    ${2g_radio_index}    ${channel_2}
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}  
    Set Password    ${dut}    ${2g_ssid_index}    ${password_2}  
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Channel    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${channel_2}
    ${ret}    Get Password    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${2g_radio_index}    ${channel_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password_2}

TC01024: Changing Channel to 2.4GHz radio and verify with a WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${channel_2}    Get Channel 6
    ${ssid_2}    Get 2G Ssid 2 
    ${password_2}    Get Password 2
    Set Channel    ${dut}    ${2g_radio_index}    ${channel_2}
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}  
    Set Password    ${dut}    ${2g_ssid_index}    ${password_2}  
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Channel    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${channel_2}
    ${ret}    Get Password    ${dut}    ${2g_ssid_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${2g_radio_index}    ${channel_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password_2}

#--------------------------------------------------------------------
TC01025: Open_Source_Regression_11AXGHE20_OPEN_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio    
    ${bandwidth_1}    Get Bandwidth 20MHz
    ${no_scan}    Get Noscan
    ${standard_ax}    Get Operating Standard ax
    ${ssid_2}    Get 2G Ssid 2 

    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth_1}    ${no_scan}
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_ax}
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Set Encryption    ${dut}    ${2g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}   ${bandwidth_1}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_ax}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}

TC01026: Open_Source_Regression_11B_OPEN_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio
    ${standard_b}    Get Operating Standard b
    ${ssid_2}    Get 2G Ssid 2    
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_b}
    #Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    #Set Encryption    ${dut}    ${2g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep    1
    ${ret}    Get Radio standard    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${standard_b}
    #Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}

###------------------------
TC01027: Change Encryption (WPA2-Personal) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_2}    Get 2G Ssid 2 
    ${password_2}    Get Password 2

    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption_1}
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${2g_ap_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption_1}
    ${ret}    Get Password    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_2}    ${password_2}
    
###-------------------------
TC01028: Change Encryption (WPA2-Personal) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2  
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_2}    Get 2G Ssid 2 
    ${password_2}    Get Password 2

    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption_1}
    Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Set Password    ${dut}    ${2g_ap_index}    ${password_2}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Ssid    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${ssid_2}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption_1}
    ${ret}    Get Password    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${password_2}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_2}    ${password_2}
    
####------------------------------
TC01029: Verify WLAN connectivity - Ping from DUT to WIFI Client1.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1    
    Configure And Check The Encryption    ${encryption_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_1}
    Log To Console  ${wlan_client_1} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01030: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1

    Configure And Check The Encryption    ${encryption_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console  ${wlan_client_2} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01031: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1

    Configure And Check The Encryption    ${encryption_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_1}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01032: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption_1}    Get Encryption WPA2-Personal
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1

    Configure And Check The Encryption    ${encryption_1}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_2}    ${url}    ${count}
    Should Be True    ${loss} < ${5}

TC01033: Open_Source_Regression_11AXGHE with 40_WPA2_PSK_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio
    ${standard_axg}    Get Operating Standard axg
    ${Encryption}    Get Encryption WPA2
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    ${bandwidth_2}    Get Bandwidth 40MHz
    ${no_scan}    Get Noscan

    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth_2}    ${no_scan}
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_axg}
    Set Encryption    ${dut}    ${2g_ap_index}    ${Encryption} 
    #Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    #Set Password    ${dut}    ${2g_ap_index}    ${password_2}
    #Set Noscan    ${dut}   ${2g_ap_index}    ${noscan}
    Load Wifi    ${dut}
    Sleep    1

    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    #Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_axg}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${Encryption} 
    #Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid}

TC01034: Open_Source_Regression_11G_WPA2_PSK_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio
    ${standard_axg}    Get Operating Standard axg
    ${Encryption}    Get Encryption WPA2
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    ${bandwidth_2}    Get Bandwidth 40MHz
    ${no_scan}    Get Noscan

    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth_2}    ${no_scan}
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_axg}
    Set Encryption    ${dut}    ${2g_ap_index}    ${Encryption} 
    #Set Ssid    ${dut}    ${2g_ssid_index}    ${ssid_2}
    #Set Password    ${dut}    ${2g_ap_index}    ${password_2}
    #Set Noscan    ${dut}   ${2g_ap_index}    ${noscan}
    Load Wifi    ${dut}
    Sleep    1

    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    #Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_axg}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${Encryption} 
    #Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid}

TC01035: Verify STA1 association to 2.4GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${open_ap}    Get Encryption Security_none
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    #Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Encryption    ${dut}    ${2g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  1
    #${ret}  Get Bandwidth    ${dut}    ${index}
    #Should Be Equal    ${ret}    ${bandwidth}
    #Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC01036: Verify STA2 association to 2.4GHz channels in open authentication
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${open_ap}    Get Encryption Security_none
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    #Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Encryption    ${dut}    ${2g_ap_index}    ${open_ap}
    Load Wifi    ${dut}
    Sleep  1
    #${ret}  Get Bandwidth    ${dut}    ${index}
    #Should Be Equal    ${ret}    ${bandwidth}
    #Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${open_ap}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TC01037: Change Encryption (WPA3-Personal) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC01038: Change Encryption (WPA3-Personal) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    sae
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

TC01039: Verify WLAN connectivity - Ping from DUT to WIFI Client1.
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}    
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_1}
    Log To Console  ${wlan_client_1} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01040: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console  ${wlan_client_2} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01041: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_1}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01042: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption WPA3
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_2}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01043: Open_Source_Regression_11AXGHE40_WPA3-SAE_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio
    ${standard_axg}    Get Operating Standard axg
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA3
    ${bandwidth_2}    Get Bandwidth 40MHz
    ${no_scan}    Get Noscan

    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth_2}    ${noscan}
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_axg}
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep    1
    #Set Prop Coext   ${dut}    ${index}
    #Set Prop Cfg     ${dut}    ${index}
    #Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_axg}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_1}

TC01044: Change Encryption (WPA2+WPA3) method of 2.4GHz Interface and verify with WiFi Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}    ${ssid_1}    ${password_1}

TC01045: Change Encryption (WPA2+WPA3) method of 2.4GHz Interface and verify with WiFi Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep  1
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}    ${ssid_1}    ${password_1}

####------ sae-mixed
TC01046: Verify WLAN connectivity - Ping from DUT to WIFI Client1
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}   ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_1}
    Log To Console  ${wlan_client_1} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

####------ sae-mixed
TC01049: Verify WLAN connectivity - Ping from DUT to WIFI Client2
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid_1}    ${password_1}
    ${ip}    Get Client Ipv4   ${wlan_client_2}
    Log To Console  ${wlan_client_2} : ${ip}
    ${loss}  Ping Ipv4  ${dut}  ${ip}  ${count}
    Should Be True  ${loss} < ${5}

TC01050: Verify Internet connectivity - WIFI Client1 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_1  
    Initial Check Ap And Its 2G Radio And Wlan Client 1
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_1}   ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_1}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01051: Verify Internet connectivity - WIFI Client2 - ping google.co.in 
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    DEV_AP_WC_2
    Initial Check Ap And Its 2G Radio And Wlan Client 2
    ${encryption}    Get Encryption security_wpa3_mixed
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    Configure And Check The Sae Encryption    ${encryption}
    Check And Connect A Client To A Secured Ssid    ${wlan_client_2}   ${ssid_1}    ${password_1}
    ${loss}  Ping Ipv4  ${wlan_client_2}  ${url}  ${count}
    Should Be True  ${loss} < ${5}

TC01052: Open_Source_Regression_11NGHT40_WPA3-SAE_2G
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G
    Initial Check Ap And Its 2G Radio
    ${standard_ng}    Get Operating Standard ng
    ${ssid_1}    Get 2G Ssid 1 
    ${password_1}    Get Password 1
    ${encryption}    Get Encryption WPA3
    ${bandwidth}    Get Bandwidth 40MHz
    ${no_scan}    Get Noscan

    Set Bandwidth    ${dut}    ${2g_radio_index}    ${bandwidth}    ${noscan}
    Set Radio Standard   ${dut}   ${2g_radio_index}   ${standard_ng}
    Set Encryption    ${dut}    ${2g_ap_index}    ${encryption}
    Set Sae Parameters    ${dut}    ${2g_iface_index}
    Load Wifi    ${dut}
    Sleep    1
    #Set Prop Coext   ${dut}    ${index}
    #Set Prop Cfg     ${dut}    ${index}
    #Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${bandwidth}
    Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${2g_radio_index}    ${htmode_2}
    ${ret}    Get Radio Standard    ${dut}    ${2g_radio_index}
    Should Be Equal    ${ret}    ${standard_ng}
    ${ret}    Get Encryption    ${dut}    ${2g_ap_index}
    Should Be Equal    ${ret}    ${encryption}
    Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${2g_ssid_index}    ${ssid_1}

TC01053: Set country code by using iw reg set
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G   REG_DOMAIN
    Initial Check Ap And Its 2G Radio
    ${domain_us}    Get Region Domain US
    Set Regulatory Domain    ${dut}     ${domain_us}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${2g_radio_index}    ${domain_us}
    #Get Supported Channels Count    ${dut}    ${index}
    #Get Highest Supported Channel    ${dut}    ${index}    

TC01054: Change Country code & check Channel list
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G    REG_DOMAIN    
    Initial Check Ap And Its 2G Radio
    ${domain_de}    Get Region Domain DE  
    Set Regulatory Domain    ${dut}    ${domain_de}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${2g_radio_index}    ${domain_de}
    #Get Supported Channels Count    ${dut}    ${index}

TC01055: Reset Country code to US and Verify
    [Tags]  SMOKE_SANITY   SMOKE_SANITY_2G   REG_DOMAIN    
    Initial Check Ap And Its 2G Radio
    ${domain_us}    Get Region Domain US
    Set Regulatory Domain    ${dut}     ${domain_us}
    Sleep  1
    Check Regulatory Domain    ${dut}    ${2g_radio_index}    ${domain_us}
    #Get Supported Channels Count    ${dut}    ${index}
    #Get Highest Supported Channel    ${dut}    ${index}
