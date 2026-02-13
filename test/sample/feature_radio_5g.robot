*** Settings ***
Library            zi4pitstop.lib.pitstop


*** Test Cases ***

TS006 TC001 5G Radio Channel 36
    [Tags]    TS006   TS006-TC001    5G
    ${channel}    Read From Database    ap    5g_channel_36
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}

TS006 TC002 5G Radio Channel 40
    [Tags]    TS006   TS006-TC002    5G
    ${channel}    Read From Database    ap    5g_channel_40
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}

TS006 TC003 5G Radio Channel 48
    [Tags]    TS006   TS006-TC003    5G
    ${channel}    Read From Database    ap    5g_channel_48
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}


TS006 TC004 5G Radio Bandwidth 80MHz
    [Tags]    TS006   TS006-TC004    5G
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}
    ${bandwidth}    Read From Database    ap    bandwidth_80
    Set Bandwidth    ap    5g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    5g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_80_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    5g_iface_index    ${bandwidth}


TS006 TC005 5G Radio Bandwidth 160MHz
    [Tags]    TS006   TS006-TC005    5G
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}
    ${bandwidth}    Read From Database    ap    bandwidth_160
    Set Bandwidth    ap    5g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    5g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_160_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    5g_iface_index    ${bandwidth}


TS006 TC006 5G Radio State
    [Tags]    TS006   TS006-TC006    5G    OPENWRT
    Set Radio State   ap   5g_radio_index   ${0}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   5g_radio_index   ${1}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}


TS006 TC007 5G Radio State
    [Tags]    TS006   TS006-TC007    5G    PRPL
    Set Radio State   ap   5g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   5g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}


TS006 TC008 5G Radio Standard AC
    [Tags]    TS006   TS006-TC008    5G
    ${standard}    Read From Database    ap    operating_standard_ac
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS006 TC009 5G Radio Standard N
    [Tags]    TS006   TS006-TC009    5G
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS006 TC010 5G Transmit Power 25
    [Tags]    TS006   TS006-TC010    5G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    5g_iface_index    ${tx_power}


TS006 TC011 5G Transmit Power 6
    [Tags]    TS006   TS006-TC011    5G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS006 TC012 5G Transmit Power 25
    [Tags]    TS006   TS006-TC012    5G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS006 TC013 5G Regulatory Domain US
    [Tags]    TS006   TS006-TC013    5G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    5g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    5g_iface_index    ${reg_domain}


TS006 TC014 5G Regulatory Domain DE
    [Tags]    TS006   TS006-TC014    5G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    5g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    5g_iface_index    ${reg_domain}
