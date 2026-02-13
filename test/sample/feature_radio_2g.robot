*** Settings ***
Library            zi4pitstop.lib.pitstop
#Suite Setup        Suite Setup For 2G Radio


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
    ${platform}    Read From Database    ap    platform
    Run Keyword If    '${platform}' == 'openwrt'    Set Interface Name For 2g Radio

*** Test Cases ***

TS004 TC001 2G Radio Channel 01
    [Tags]    TS004   TS004-TC001    2G
    ${channel}    Read From Database    ap    2g_channel_1
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}

TS004 TC002 2G Radio Channel 06
    [Tags]    TS004   TS004-TC002    2G
    ${channel}    Read From Database    ap    2g_channel_6
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}

TS004 TC003 2G Radio Channel 11
    [Tags]    TS004   TS004-TC003    2G
    ${channel}    Read From Database    ap    2g_channel_11
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}


TS004 TC004 2G Radio Bandwidth 20MHz
    [Tags]    TS004   TS004-TC004    2G
    ${bandwidth}    Read From Database    ap    bandwidth_20
    Set Bandwidth    ap    2g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    2g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_20_val
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    2g_iface_index    ${bandwidth}


TS004 TC005 2G Radio Bandwidth 40MHz
    [Tags]    TS004   TS004-TC005    2G
    ${bandwidth}    Read From Database    ap    bandwidth_40
    Set Bandwidth    ap    2g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    2g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_40_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    2g_iface_index    ${bandwidth}


TS004 TC006 2G Radio State
    [Tags]    TS004   TS004-TC006    2G    OPENWRT
    Set Radio State   ap   2g_radio_index   ${0}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   2g_radio_index   ${1}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${1}


TS004 TC007 2G Radio State
    [Tags]    TS004   TS004-TC007    2G    PRPL
    Set Radio State   ap   2g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   2g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${1}


TS004 TC008 2G Radio Standard G
    [Tags]    TS004   TS004-TC008    2G
    ${standard}    Read From Database    ap    operating_standard_g
    Set Radio Standard   ap   2g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    2g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS004 TC009 2G Radio Standard N
    [Tags]    TS004   TS004-TC009    2G
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   2g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    2g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS004 TC010 2G Transmit Power 25
    [Tags]    TS004   TS004-TC010    2G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    2g_iface_index    ${tx_power}


TS004 TC011 2G Transmit Power 6
    [Tags]    TS004   TS004-TC011    2G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS004 TC012 2G Transmit Power 25
    [Tags]    TS004   TS004-TC012    2G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS004 TC013 2G Regulatory Domain US
    [Tags]    TS004   TS004-TC013    2G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    2g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain}


TS004 TC014 2G Regulatory Domain DE
    [Tags]    TS004   TS004-TC014    2G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    2g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain}
