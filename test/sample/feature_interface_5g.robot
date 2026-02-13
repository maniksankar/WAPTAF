*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        Suite Setup For 5G Radio


*** Keywords ***
Suite Setup For 5G Radio
    Set Radio State   ap   5g_radio_index   ${1}
    ${channel}    Read From Database    ap    5g_channel_36
    Set Channel    ap    5g_radio_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20
    Set Bandwidth    ap    5g_radio_index    ${bandwidth}
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   5g_radio_index   ${standard}
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Sleep    5
    Load WiFi    ap
    Sleep    10
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20_val
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    5g_iface_index    ${bandwidth}
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    5g_iface_index    ${reg_domain}

*** Test Cases ***
    
#TS003 TC001 5G Set Interface
#    [Tags]    TS003    TS003-TC001    5G    OPENWRT
#    Set Interface From Database    ap    5g_radio_index
#    Load Wifi    ap
#    Sleep  3
#    ${ret}    Get Interface    ap    5g_radio_index
#    Should Be Equal    ${ret}    ${5G_Interface}
#    Check Interface    ap    5g_radio_index

TS003 TC001 5G Set Ssid
    [Tags]    TS003    TS003-TC001    5G
    ${ssid}    Read From Database    ap    5g_ssid_1
    Set Ssid    ap    5g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    5g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    5g_iface_index    ${ssid}
    ${ssid}    Read From Database    ap    5g_ssid_2
    Set Ssid    ap    5g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    5g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    5g_iface_index    ${ssid}

TS003 TC002 5G Set Encryption None
    [Tags]  TS003    TS003-TC002    5G
    ${security}    Read From Database    ap    security_none
    Set Encryption    ap    5g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_ap_index
    Should Be Equal    ${ret}    ${security}

TS003 TC003 5G Set Encryption WPA2-Personal
    [Tags]  TS003    TS003-TC003    5G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    5g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_ap_index
    Should Be Equal    ${ret}    ${security}

TS003 TC004 5G Set Password 1
    [Tags]  TS003    TS003-TC004    5G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    5g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_1
    Set Password    ap    5g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    5g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

TS003 TC005 5G Set Password 2
    [Tags]  TS003    TS003-TC005    5G
    ${security}    Read From Database    ap    security_wpa2_personal
    Set Encryption    ap    5g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_2
    Set Password    ap    5g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    5g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

