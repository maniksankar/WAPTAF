*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        Suite Setup For 2G Radio

*** Variables  ***
${5G_CHANNEL}    ${48}
${5G_HTMODE}    VHT80
${5G_BANDWIDTH}    ${80}
${5G_STANDARD}    11axn
${5G_TXPOWER}    ${25}
${5G_REG}    DE
${5G_Interface}  wlan0
${5G_Ssid}  ssid_valid
${5G_Encryption}  psk2+ccmp
${5G_Password}  zilo@123

*** Keywords ***

Suite Setup For 2G Radio
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
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain

*** Test Cases ***
    
Test Case Set Interface
    [Tags]  Interface
    Set Interface From Database    ap    5g_radio_index
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Interface    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Interface}
    Check Interface    ap    5g_radio_index

Test Case Set Ssid
    [Tags]  Ssid
    Set Ssid    ap    5g_radio_index    ${5G_Ssid}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Ssid    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Ssid}
    Check Ssid    ap    5g_radio_index    ${5G_Ssid}

Test Case Set Encryption
    [Tags]  Encryption
    Set Encryption    ap    5g_radio_index    ${5G_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Encryption}

Test Case Set Password
    [Tags]  Password
    Set Password    ap    5g_radio_index    ${5G_Password}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Password    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Password}

