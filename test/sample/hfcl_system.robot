*** Settings ***
Library          zi4pitstop.lib.pitstop 
Suite Setup      Suite Precondition
#Test Setup    This Suite Precondition

*** Variables ***
${dut}    ap
${wlan_client_1}    ap_wlan_client_1
${wlan_client_2}  ap_wlan_client_2
${index}    5g_radio_index
${ssid}    OpenWrt5G
${channel}    36
${bandwidth}    HT80
${htmode}  20
${open_ap}    none
${secured_ap}    psk2
${reg_domain}    US
${standard}    11ac
${password}    123456789
${mode}    ap 

${ssid_2}    zi4pitstop_5g
${channel_2}    ${44}
${bandwidth_2}    HT160
${htmode_2}  160
${reg_domain_2}    DE
${public_dns}    8.8.8.8
${url}    google.co.in
${bridge_ip}  192.168.1.1
${count}      4
${Isolate}    1

${system_index}    0
${zone_time}    UTC

*** Keywords ***

Suite Precondition
    Set Radio State    ap    5g_radio_index    ${1}
    Load WiFi    ap
    Sleep    5
    ${ret}    Get Radio State    ap    5g_radio_index
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
    #Set Regulatory Domain    ${dut}    5g_radio_index    ${reg_domain}
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
    #Check Regulatory Domain    ${dut}    2g_radio_index    ${reg_domain}
    ${ret}    Get Password    ${dut}    ${index}
    Should Be Equal    ${ret}    ${password}
    # Remove All Wifi Connections    ap_wlan_client_1
    Make Client To Default State    ap_wlan_client_1
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
    Wait Until Keyword Succeeds    90    3    Connect Client To Ssid  ${client}  ${ssid}   ${password}
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
TC001 Verify Configure System Time Zone
       [Tags]    HFCL_SYSTEM
       Set Time Zone    ${dut}    ${system_index}    ${zone_time}
       Load System    ${dut}
       Sleep    5
       ${ret}    Get Time Zone    ${dut}    ${system_index}
       Should Be Equal    ${ret}    ${zone_time}
