*** Settings ***
Library            zi4pitstop.lib.pitstop


*** Test Cases ***

TS001 TC001 2G Radio Channel 01
    [Tags]    TS001   TS001-TC001    2G
    ${channel}    Read From Database    ap    2g_channel_1
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}

TS001 TC002 2G Radio Channel 06
    [Tags]    TS001   TS001-TC002    2G
    ${channel}    Read From Database    ap    2g_channel_6
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}

TS001 TC003 2G Radio Channel 11
    [Tags]    TS001   TS001-TC003    2G
    ${channel}    Read From Database    ap    2g_channel_11
    Set Channel    ap    2g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    2g_iface_index    ${channel}


TS001 TC004 2G Radio Bandwidth 20MHz
    [Tags]    TS001   TS001-TC004    2G
    ${bandwidth}    Read From Database    ap    bandwidth_20
    Set Bandwidth    ap    2g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    2g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_20_val
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    2g_iface_index    ${bandwidth}


TS001 TC005 2G Radio Bandwidth 40MHz
    [Tags]    TS001   TS001-TC005    2G
    ${bandwidth}    Read From Database    ap    bandwidth_40
    Set Bandwidth    ap    2g_radio_index    ${bandwidth}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Bandwidth    ap    2g_radio_index
    Should Be Equal    ${ret}    ${bandwidth}
    ${bandwidth}    Read From Database    ap    bandwidth_40_val    
    Wait Until Keyword Succeeds    30    1    Check Bandwidth    ap    2g_iface_index    ${bandwidth}


TS001 TC006 2G Radio State
    [Tags]    TS001   TS001-TC006    2G    OPENWRT
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


TS001 TC007 2G Radio State
    [Tags]    TS001   TS001-TC007    2G    PRPL
    Set Radio State   ap   2g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   2g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${1}


TS001 TC008 2G Radio Standard G
    [Tags]    TS001   TS001-TC008    2G
    ${standard}    Read From Database    ap    operating_standard_g
    Set Radio Standard   ap   2g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    2g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC009 2G Radio Standard N
    [Tags]    TS001   TS001-TC009    2G
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   2g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    2g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC010 2G Transmit Power 25
    [Tags]    TS001   TS001-TC010    2G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    2g_iface_index    ${tx_power}


TS001 TC011 2G Transmit Power 6
    [Tags]    TS001   TS001-TC011    2G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC012 2G Transmit Power 25
    [Tags]    TS001   TS001-TC012    2G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    2g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    2g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC013 2G Regulatory Domain US
    [Tags]    TS001   TS001-TC013    2G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    2g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain}


TS001 TC014 2G Regulatory Domain DE
    [Tags]    TS001   TS001-TC014    2G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    2g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    2g_iface_index    ${reg_domain}

TS001 TC015 5G Radio Channel 36
    [Tags]    TS001   TS001-TC015    5G
    ${channel}    Read From Database    ap    5g_channel_36
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}

TS001 TC016 5G Radio Channel 40
    [Tags]    TS001   TS001-TC016    5G
    ${channel}    Read From Database    ap    5g_channel_40
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}

TS001 TC017 5G Radio Channel 48
    [Tags]    TS001   TS001-TC017    5G
    ${channel}    Read From Database    ap    5g_channel_48
    Set Channel    ap    5g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    5g_iface_index    ${channel}


TS001 TC018 5G Radio Bandwidth 80MHz
    [Tags]    TS001   TS001-TC018    5G
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


TS001 TC019 5G Radio Bandwidth 160MHz
    [Tags]    TS001   TS001-TC019    5G
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


TS001 TC020 5G Radio State
    [Tags]    TS001   TS001-TC020    5G    OPENWRT
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


TS001 TC021 5G Radio State
    [Tags]    TS001   TS001-TC021    5G    PRPL
    Set Radio State   ap   5g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   5g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}


TS001 TC022 5G Radio Standard AC
    [Tags]    TS001   TS001-TC022    5G
    ${standard}    Read From Database    ap    operating_standard_ac
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC023 5G Radio Standard N
    [Tags]    TS001   TS001-TC023    5G
    ${standard}    Read From Database    ap    operating_standard_n
    Set Radio Standard   ap   5g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    5g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC024 5G Transmit Power 25
    [Tags]    TS001   TS001-TC024    5G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    5g_iface_index    ${tx_power}


TS001 TC025 5G Transmit Power 6
    [Tags]    TS001   TS001-TC025    5G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC024 5G Transmit Power 25
    [Tags]    TS001   TS001-TC024    5G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    5g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    5g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC025 5G Regulatory Domain US
    [Tags]    TS001   TS001-TC025    5G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    5g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    5g_iface_index    ${reg_domain}


TS001 TC026 5G Regulatory Domain DE
    [Tags]    TS001   TS001-TC026    5G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    5g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    5g_iface_index    ${reg_domain}

TS001 TC027 6G Radio Channel 1
    [Tags]    TS001   TS001-TC027    6G
    ${channel}    Read From Database    ap    6g_channel_1
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}

TS001 TC028 6G Radio Channel 33
    [Tags]    TS001   TS001-TC028    6G
    ${channel}    Read From Database    ap    6g_channel_33
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}

TS001 TC029 6G Radio Channel 61
    [Tags]    TS001   TS001-TC029    6G
    ${channel}    Read From Database    ap    6g_channel_61
    Set Channel    ap    6g_radio_index    ${channel}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${channel}
    Wait Until Keyword Succeeds    30    1    Check Channel    ap    6g_iface_index    ${channel}


TS001 TC030 6G Radio Bandwidth 80MHz
    [Tags]    TS001   TS001-TC030    6G
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


TS001 TC031 6G Radio Bandwidth 160MHz
    [Tags]    TS001   TS001-TC031    6G
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


TS001 TC032 6G Radio State
    [Tags]    TS001   TS001-TC032    6G    OPENWRT
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


TS001 TC033 6G Radio State
    [Tags]    TS001   TS001-TC033    6G    PRPL
    Set Radio State   ap   6g_radio_index   ${0}
    Sleep    5
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Radio State   ap   6g_radio_index   ${1}
    Sleep    5
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${1}


TS001 TC034 6G Radio Standard AC
    [Tags]    TS001   TS001-TC034    6G
    ${standard}    Read From Database    ap    operating_standard_ax
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC035 6G Radio Standard N
    [Tags]    TS001   TS001-TC035    6G
    ${standard}    Read From Database    ap    operating_standard_be
    Set Radio Standard   ap   6g_radio_index   ${standard}
    Sleep    5
    Load Wifi    ap
    Sleep    5
    ${ret}    Get Radio Standard    ap    6g_radio_index
    Should Be Equal    ${ret}    ${standard}


TS001 TC036 6G Transmit Power 25
    [Tags]    TS001   TS001-TC036    6G    OPENWRT
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}
    Wait Until Keyword Succeeds    30    1    Check Txpower    ap    6g_iface_index    ${tx_power}


TS001 TC037 6G Transmit Power 6
    [Tags]    TS001   TS001-TC037    6G    PRPL
    ${tx_power}    Read From Database    ap    tx_power_6
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC038 6G Transmit Power 25
    [Tags]    TS001   TS001-TC038    6G
    ${tx_power}    Read From Database    ap    tx_power_25
    Set Txpower    ap    6g_radio_index    ${tx_power}
    Sleep    5
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Txpower    ap    6g_radio_index
    Should Be Equal    ${ret}    ${tx_power}


TS001 TC039 6G Regulatory Domain US
    [Tags]    TS001   TS001-TC039    6G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_us
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    6g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    6g_iface_index    ${reg_domain}


TS001 TC040 6G Regulatory Domain DE
    [Tags]    TS001   TS001-TC040    6G    PRPL
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    6g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    Wait Until Keyword Succeeds    30    1    Check Regulatory Domain    ap    6g_iface_index    ${reg_domain}


Test Case Regdomain 1
    [Tags]    TS001   TS001-TC010    5G    OPENWRT
    ${reg_domain}    Read From Database    ap    reg_domain_de
    Set Regulatory Domain    ap    ${reg_domain}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Regulatory Domain    ap    5g_radio_index
    Should Be Equal    ${ret}    ${reg_domain}
    ${ret}   Get Physical Interface Index   ap   5g_radio_index
    Log  ${ret}
    ${ret}   Get Supported Channels Count  ap  5g_radio_index
    Log  ${ret}
    ${ret}   Get Highest Supported Channel  ap  5g_radio_index
    Log  ${ret}
    ${ret}   Get Supported Channels List  ap  5g_radio_index
    Log  ${ret}
    Check Regulatory Domain    ap    5g_iface_index    ${5G_REG}


Test Case Noscan
    [Tags]    TS001   TS001_TC012    5G   OPENWRT
    Set Noscan    ap    5g_radio_index    ${0}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Noscan    ap    5g_radio_index
    Should Be Equal    ${ret}    ${0}
    Set Noscan    ap    5g_radio_index    ${1}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Noscan    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}
