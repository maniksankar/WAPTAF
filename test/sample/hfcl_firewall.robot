*** Settings *** 
Library          zi4pitstop.lib.pitstop 
Suite Setup      Suite Precondition
#Test Setup    This Suite Precondition

*** Variables ***
${dut}    ap
${wlan_client_1}    ap_wlan_client_1
${wlan_client_2}  ap_wlan_client_2
${index}    2g_radio_index
${ssid}    OpenWrt2G
${channel}    6
${bandwidth}    HT20
${htmode}  20
${open_ap}    none
${secured_ap}    psk2
${reg_domain}    US
${standard}    11axg
${password}    Zilogic_123
${radio_type}     qcawificfg80211 
${mode}    ap  

${ssid_2}    zi4pitstop
${channel_2}    ${11}
${bandwidth_2}    HT40
${htmode_2}  40
${reg_domain_2}    DE
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1-1    
${count}      4
${Isolate}    1


${zone_index}    -1
${zone_name}    lan
${zone_name1}   lan
${zone_wan_name}    wan
${zone_wan_name1}   wan  
  
*** Keywords ***

Suite Precondition
    Set Radio State    ap    2g_radio_index    ${1}
    Load WiFi    ap
    Sleep    5
    ${ret}    Get Radio State    ap    2g_radio_index
    Should Be Equal    ${ret}    ${1}

This Suite Precondition
    Set Radio State    ${dut}    ${index}  ${1}
    Set Interface From Database    ${dut}    ${index}
    Set Ssid    ${dut}    ${index}    ${ssid}
    Set Encryption    ${dut}    ${index}    ${secured_ap}
    Set Password    ${dut}    ${index}    ${password}
    Set Channel    ${dut}    ${index}    ${channel}
    Set Bandwidth    ${dut}    ${index}    ${bandwidth}
    Set Radio Standard     ${dut}    ${index}   ${standard}
    #Set Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    Load Wifi    ${dut}
    Sleep  5
    ${ret}    Get Radio State    ${dut}    ${index}
    Should Be Equal    ${ret}    ${1}
    Check Interface    ${dut}    ${index}
    Check Ssid    ${dut}    ${index}    ${ssid}
    ${ret}    Get Encryption    ${dut}    ${index}
    Should Be Equal    ${ret}    ${secured_ap}
    Check Channel    ${dut}    ${index}    ${channel}
    Check Bandwidth    ${dut}    ${index}    ${htmode}
    ${ret}    Get Radio Standard    ${dut}    ${index}
    Should Be Equal    ${ret}    ${standard}
    #Check Regulatory Domain    ${dut}    ${index}    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${index}
    Should Be Equal    ${ret}    ${password}
    # Remove All Wifi Connections    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_1}
    Make Client To Default State    ${wlan_client_2}

Make Client To Default State
    [Arguments]    ${client}
    Remove All Wifi Connections    ${client}
    Set Client Interface State    ${client}    ${0}
    ${state}    Get Client Interface State    ${client}
    Should Be Equal    ${state}    ${0}
    Sleep    5
    Set Client Radio State    ${client}    ${0}
    ${state}    Get Client Radio State    ${client}
    Should Be Equal    ${state}    ${0}
    Sleep    5
    Set Client Radio State    ${client}    ${1}
    ${state}    Get Client Radio State    ${client}
    Should Be Equal    ${state}    ${1}
    Sleep    5
    Set Client Interface State    ${client}    ${1}
    ${state}    Get Client Interface State    ${client}
    Should Be Equal    ${state}    ${1}

Client Should Be Connected With Ssid
    [Arguments]    ${client}    ${ssid}
    ${ret}  Get Client Connected Ssid  ${client}
    Should Be Equal  ${ssid}  ${ret}

Check And Connect A Client To A Secured Ssid
    [Arguments]    ${client}    ${ssid}    ${password}
    Wait Until Keyword Succeeds    30    3    Check Ap Ssid Visibility  ${client}  ${ssid}
    Wait Until Keyword Succeeds    30    3    Connect Client To Ssid  ${client}  ${ssid}   ${password}
    Wait Until Keyword Succeeds    30    3    Client Should Be Connected With Ssid    ${client}    ${ssid}
    
Configure And Check The Bandwidth
    Set Bandwidth    ${dut}    ${index}    ${bandwidth_2}
    Load Wifi    ${dut}
    Sleep    3
    Set Prop Coext   ${dut}    ${index}
    Set Prop Cfg     ${dut}    ${index}
    Sleep   10
    ${ret}    Get Bandwidth    ${dut}    ${index}
    Should Be Equal    ${ret}    ${bandwidth_2}
    Check Bandwidth    ${dut}    ${index}    ${htmode_2}

Configure And Check The Encryption
    [Arguments]    ${encryption}
    Set Encryption    ${dut}    ${index}    ${encryption}
    Load Wifi    ${dut}
    Sleep  10

Configure And Check The Sae Encryption
    Set Encryption    ${dut}    ${index}    sae
    Set Sae Parameters    ${dut}    ${index}
    Load Wifi    ${dut}
    Sleep  10

*** Test Cases ***

# TC001 Verify Configure add firewall zone and name
#     [Tags]    HFCL_FIREWALL
#     Add Firewall Zone    ${dut}    ${zone_index}    ${zone_name}
#     Load Firewall    ${dut}
#     ${ret}    Get Zone Name    ${dut}    ${zone_name}
#     Should Be Equal    ${ret}    ${zone_name}


TC001 Verify Configure firewall Zone name for lan network
    [Tags]    HFCL_FIREWALL
    Set Zone Name    ${dut}    ${zone_name}   ${zone_name1}
    Load Firewall    ${dut}
    ${ret}    Get Zone Name    ${dut}    ${zone_name1}
    Should Be Equal    ${ret}    ${zone_name1}

TC002 Verify Configure Firewall Zone Network for lan
    [Tags]    HFCL_FIREWALL    FIRE
    Set Zone Network    ${dut}    ${zone_name1}    lan
    Load Firewall    ${dut}
    ${ret}    Get Zone Network    ${dut}    ${zone_name1}
    Should Be Equal    ${ret}    lan

TC003 Verify Configure Firewall Zone Input for lan network
    [Tags]    HFCL_FIREWALL    FIRE
    Set Zone Input    ${dut}    ${zone_name1}    ACCEPT
    Load Firewall    ${dut}
    ${ret}    Get Zone Input    ${dut}    ${zone_name1} 
    Should Be Equal    ${ret}    ACCEPT

TC004 Verify Configure Firewall Zone Output for lan
    [Tags]    HFCL_FIREWALL    FIRE
    Set Zone Output    ${dut}    ${zone_name1}    ACCEPT
    Load Firewall    ${dut}
    ${ret}    Get Zone Output    ${dut}    ${zone_name1}
    Should Be Equal    ${ret}    ACCEPT

TC005 Verify Configure Firewall Zone Forward for lan
    [Tags]    HFCL_FIREWALL 
    Set Zone Forward    ${dut}    ${zone_name1}    ACCEPT
    Load Firewall    ${dut}
    ${ret}    Get Zone Forward    ${dut}    ${zone_name1}
    Should Be Equal    ${ret}    ACCEPT

TC006 Verify Configure Firewall Zone Source for lan
    [Tags]    HFCL_FIREWALL
    Set Zone Source    ${dut}    ${zone_name1}    lan
    Load Firewall    ${dut}
    ${ret}    Get Zone Source    ${dut}    ${Zone_name1}
    Should Be Equal    ${ret}    lan

TC007 Verify Configure Firewall Zone Destination for lan
    [Tags]    HFCL_FIREWALL
    Set Zone Destination    ${dut}    ${zone_name1}    wan
    Load Firewall    ${dut}
    ${ret}    Get Zone Destination    ${dut}    ${zone_name1}
    Should Be Equal    ${ret}    wan

TC008 Verify Configure Firewall Zone Name for Wam
    [Tags]    HFCL_FIREWALL
    Set Zone Name    ${dut}    ${zone_wan_name}    ${zone_wan_name1}
    Load Firewall    ${dut}
    ${ret}    Get Zone Name    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    ${zone_wan_name1}

TC009 Verify Configure Firewall zoen network for wan
    [Tags]    HFCL_FIREWALL
    Set Zone Network    ${dut}    ${zone_wan_name1}    wan
    Load Firewall    ${dut}
    ${ret}    Get Zone Network    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    wan

TC010 Verify Configure Firewall zone Input for wan
    [Tags]    HFCL_FIREWALL
    Set Zone Input    ${dut}    ${zone_wan_name1}    ACCEPT
    Load Firewall    ${dut}
    ${ret}    Get Zone Input    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    ACCEPT

TC011 Verify Configure Firewall Zone Output for wan
    [Tags]    HFCL_FIREWALL    FIRE
    Set Zone Output    ${dut}    ${zone_wan_name1}    ACCEPT
    Load Firewall    ${dut}
    ${ret}    Get Zone Output    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    ACCEPT

TC012 Verify Configure Firewall Zone Forward for wan
    [Tags]    HFCL_FIREWALL
    Set Zone Forward    ${dut}    ${zone_wan_name1}    REJECT
    Load Firewall    ${dut}
    ${ret}    Get Zone Forward    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    REJECT

TC013 Verify Configure Firewall Zone Masq for wan
    [Tags]    HFCL_FIREWALL
    Set Zone Masq    ${dut}    ${zone_wan_name1}    1
    Load Firewall    ${dut}
    ${ret}    Get Zone Masq    ${dut}    ${zone_wan_name1}
    Should Be Equal    ${ret}    1

