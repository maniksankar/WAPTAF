*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        Suite Setup For 6G Radio


*** Keywords ***
Suite Setup For 6G Radio
    Set Radio State   ap   6g_radio_index   ${1}
    ${channel}    Read From Database    ap    6g_channel_1
    Set Channel    ap    6g_radio_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20
    Set Bandwidth    ap    6g_radio_index    ${bandwidth}
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   6g_radio_index   ${standard}
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Sleep    5
    Load WiFi    ap
    Sleep    10
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${1}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}
    ${bandwidth}    Read From Database    ap    bandwidth_20_val
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    6g_iface_index    ${bandwidth}
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    6g_iface_index    ${reg_domain}

*** Test Cases ***
    
#TS004 TC001 6G Set Interface
#    [Tags]    TS004    TS004-TC001    6G    OPENWRT
#    Set Interface From Database    ap    6g_radio_index
#    Load Wifi    ap
#    Sleep  3
#    ${ret}    Get Interface    ap    5g_radio_index
#    Should Be Equal    ${ret}    ${5G_Interface}
#    Check Interface    ap    5g_radio_index

TS004 TC001 6G Set Ssid
    [Tags]    TS004    TS004-TC001    6G
    ${ssid}    Read From Database    ap    6g_ssid_1
    Set Ssid    ap    6g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    6g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    6g_iface_index    ${ssid}
    ${ssid}    Read From Database    ap    6g_ssid_2
    Set Ssid    ap    6g_ssid_index    ${ssid}
    Sleep    5
    Load Wifi    ap
    Sleep  10
    ${ret}    Get Ssid    ap    6g_ssid_index
    Should Be Equal    ${ret}    ${ssid}
    Check Ssid    ap    6g_iface_index    ${ssid}

TS004 TC002 6G Set Encryption None
    [Tags]  TS004    TS004-TC002    6G
    ${security}    Read From Database    ap    security_none
    Set Encryption    ap    6g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    6g_ap_index
    Should Be Equal    ${ret}    ${security}

TS004 TC003 6G Set Encryption WPA3-Personal
    [Tags]  TS004    TS004-TC003    6G
    ${security}    Read From Database    ap    security_wpa3_personal
    Set Encryption    ap    6g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    6g_ap_index
    Should Be Equal    ${ret}    ${security}

TS004 TC004 6G Set Password 1
    [Tags]  TS004    TS004-TC004    6G
    ${security}    Read From Database    ap    security_wpa3_personal
    Set Encryption    ap    6g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    6g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_1
    Set Password    ap    6g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    6g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

TS004 TC005 6G Set Password 2
    [Tags]  TS004    TS004-TC005    6G
    ${security}    Read From Database    ap    security_wpa3_personal
    Set Encryption    ap    6g_ap_index    ${security}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    6g_ap_index
    Should Be Equal    ${ret}    ${security}
    ${passphrase}    Read From Database    ap    passphrase_2
    Set Password    ap    6g_ap_index    ${passphrase}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    6g_ap_index
    Should Be Equal    ${ret}    ${passphrase}

