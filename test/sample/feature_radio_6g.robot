*** Settings ***
Library            zi4pitstop.lib.pitstop


*** Test Cases ***

TS007 TC001 6G Radio Channel 1
    [Tags]    TS007   TS007-TC001    6G
    ${channel}    Read From Database    ap    6g_channel_1
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}

TS007 TC002 6G Radio Channel 33
    [Tags]    TS007   TS007-TC002    6G
    ${channel}    Read From Database    ap    6g_channel_33
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}

TS007 TC003 6G Radio Channel 61
    [Tags]    TS007   TS007-TC003    6G
    ${channel}    Read From Database    ap    6g_channel_61
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}


TS007 TC004 6G Radio Bandwidth 80MHz
    [Tags]    TS007   TS007-TC004    6G
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}
    ${bandwidth}    Read From Database    ap    bandwidth_80
    Set Bandwidth    ap    6g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    6g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_80_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    6g_iface_index    ${bandwidth}


TS007 TC005 6G Radio Bandwidth 160MHz
    [Tags]    TS007   TS007-TC005    6G
    ${standard}    Read From Database    ap    operating_standard_be
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}
    ${bandwidth}    Read From Database    ap    bandwidth_160
    Set Bandwidth    ap    6g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    6g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_160_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    6g_iface_index    ${bandwidth}


TS007 TC006 6G Radio State
    [Tags]    TS007   TS007-TC006    6G    OPENWRT
    Set Radio State   ap   6g_radio_index   ${0}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   6g_radio_index   ${1}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${1}


TS007 TC007 6G Radio State
    [Tags]    TS007   TS007-TC007    6G    PRPL
    Set Radio State   ap   6g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   6g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${1}


TS007 TC008 6G Radio Standard AC
    [Tags]    TS007   TS007-TC008    6G
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS007 TC009 6G Radio Standard N
    [Tags]    TS007   TS007-TC009    6G
    ${standard}    Read From Database    ap    operating_standard_be
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS007 TC010 6G Transmit Power 25
    [Tags]    TS007   TS007-TC010    6G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    6g_iface_index    ${tx_power}


TS007 TC011 6G Transmit Power 6
    [Tags]    TS007   TS007-TC011    6G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS007 TC012 6G Transmit Power 25
    [Tags]    TS007   TS007-TC012    6G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS007 TC013 6G Regulatory Domain US
    [Tags]    TS007   TS007-TC013    6G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    6g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    6g_iface_index    ${reg_domain}


TS007 TC014 6G Regulatory Domain DE
    [Tags]    TS007   TS007-TC014    6G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    6g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    6g_iface_index    ${reg_domain}
