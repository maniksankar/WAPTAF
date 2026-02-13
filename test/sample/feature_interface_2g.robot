*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        Suite Setup For 2G Radio


*** Keywords ***

Set Interface Name For 2g Radio
    Set Interface From Database    ap    2g_radio_index
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Interface    ap    2g_radio_index
    ${iface}    Read From Database    ap    wifi_ifname
    ${index}    Read From Database    ap    2g_radio_index
    Should Be Equal    ${ret}    ${iface}${index}
    Wait Until Keyword Succeeds    30    1    Check Interface    ap    2g_radio_index
    
Suite Setup For 2G Radio
    #${platform}    Read From Database    ap    platform
    #Run Keyword If    '${platform}' == 'openwrt'    Set Interface Name For 2g Radio    
    Set Radio State   ap   2g_radio_index   ${1}
    ${channel}    Read From Database    ap    2g_channel_1
    Set Channel    ap    2g_radio_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20
    Set Bandwidth    ap    2g_radio_index    ${bandwidth}
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   2g_radio_index   ${standard}
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Sleep    5
    Load WiFi    ap
    Sleep    10
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${1}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20_val
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    2g_iface_index    ${bandwidth}
    ${ret}    Get Radio Standard    ap    2g_radio_index
    Should Be Equal    ${ret}    ${standard}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain}

*** Test Cases ***

TS002 TC001 2G Set Ssid
    [Tags]    TS002    TS002-TC001    2G
    ${ssid}    Read From Database    ap    2g_ssid_1
    Set Ssid    ap    2g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    2g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    2g_iface_index    ${ssid}
    ${ssid}    Read From Database    ap    2g_ssid_2
    Set Ssid    ap    2g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    2g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    2g_iface_index    ${ssid}

TS002 TC002 2G Set Encryption None
    [Tags]  TS002    TS002-TC002    2G
    ${security}    Read From Database    ap    security_none
    Set Encryption    ap    2g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_ap_index
    Should Be Equal    ${ret}    ${security}

TS002 TC003 2G Set Encryption WPA2-Personal
    [Tags]  TS002    TS002-TC003    2G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    2g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_ap_index
    Should Be Equal    ${ret}    ${security}

TS002 TC004 2G Set Password 1
    [Tags]  TS002    TS002-TC004    2G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    2g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_1
    Set Password    ap    2g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    2g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

TS002 TC005 2G Set Password 2
    [Tags]  TS002    TS002-TC005    2G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    2g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_2
    Set Password    ap    2g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    2g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

