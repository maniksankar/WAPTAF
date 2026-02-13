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

${vap_index}     vap_index
${radio}    wifi0
${vap_name}  Vap2
${vap_ssid_5g}  OpenWrt_vap_5g

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
TC001 Verify Configure Standard in 5GHZ Radio
       [Tags]    HFCL_5G
       Set Radio Standard    ${dut}    ${index}    ${standard}
       Load Wifi    ${dut}
       Sleep    5
       ${ret}    Get Radio Standard    ${dut}    ${index}
       Should Be Equal    ${ret}    ${standard}

TC002 Verify Configure Radio Type in 5GHZZ Radio
       [Tags]    HFCL_5G  
       Set Radio Type    ${dut}    ${index}    qcawificfg80211
       Load WiFi    ${dut}
       ${ret}    Get Radio Type    ${dut}     ${index}
       Should Be Equal    ${ret}    qcawificfg80211

TC003 Verify Configure Bandwidth 20 in 5GHZ Radio
       [Tags]    HFCL_5G
       Set Bandwidth    ${dut}    ${index}    HT20
       Load Wifi    ${dut}
       Sleep    3
       ${ret}    Get Bandwidth    ${dut}    ${index}
       Should Be Equal    ${ret}    HT20
       Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${index}    20

TC004 Verify Configure Channel 36 in 5GHZZ Radio
       [Tags]    HFCL_5G    
       Set Channel    ${dut}    ${index}    ${channel}
       Load WiFi    ${dut}
       Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${index}    ${channel}
              
TC005 Verify Configure Txpower 20 in 5GHZ Radio
       [Tags]    HFCL_5G    
       Set Txpower    ${dut}    ${index}    ${20}
       Load Wifi    ${dut}
       ${ret}    Get Txpower    ${dut}    ${index}
       Should Be Equal    ${ret}    ${20}
       Wait Until Keyword Succeeds    60    5    Check Txpower    ${dut}    ${index}    ${20}

TC006 Verify Configure Enable WiFi0 Radio in 5GHZ Radio
       [Tags]    HFCL_5G
       Set Radio State    ${dut}    ${index}    ${1}
       Load WiFi    ${dut}
       Sleep    5
       ${ret}    Get Radio State    ${dut}    ${index}
       Should Be Equal    ${ret}    ${1}       

TC007 Verify Configure wifi interface device name is assigned to 5GHZ Radio
       [Tags]    HFCL_5G    
       Set Wifi Iface Device    ${dut}    ${index}    wifi0
       Load Wifi    ${dut}
       Sleep    5 
       ${ret}    Get Wifi Iface Device    ${dut}    ${index} 
       Should Be Equal    ${ret}    wifi0
       
TC008 Verify Configure wifi network is assigned to 5GHZ Radio
      [Tags]    HFCL_5G        
      Set Wifi Iface Network    ${dut}    ${index}    lan
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Wifi Iface Network    ${dut}   ${index}
      Should Be Equal    ${ret}    lan      

TC009 Verify Configure Mode is assigned to 5GHZ Radio
      [Tags]    HFCL_5G    
      Set Wifi Iface Mode   ${dut}    ${index}    ${mode}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Wifi Iface Mode    ${dut}   ${index}
      Should Be Equal    ${ret}    ${mode}
      

TC010 Verify Configure Wifi SSID is assigned to 5GHZ Radio
      [Tags]    HFCL_5G    
      Set Ssid    ${dut}    ${index}    ${ssid}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Ssid    ${dut}    ${index}
      Should Be Equal    ${ret}    ${ssid}
      Wait Until Keyword Succeeds    30    3    Check Ssid    ${dut}    ${index}    ${ssid}

TC011 Verify Configure WiFi Encryption is assigned to 5GHZ Radio
      [Tags]    HFCL_5G    
      Set Encryption    ${dut}    ${index}    ${secured_ap}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Encryption    ${dut}    ${index}
      Should Be Equal    ${ret}    ${secured_ap}

TC012 Verify Configure WiFi key is assigned to 5GHZ Radio
      [Tags]    HFCL_5G    
      Set Password    ${dut}    ${index}    ${password}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Password    ${dut}    ${index}
      Should Be Equal    ${ret}    ${password}

TC013 Verify Configure Wifi Interface Isolated to 5GHZ Radio
      [Tags]    HFCL_5G    
      Set Isolate    ${dut}    ${index}    ${Isolate}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Isolate    ${dut}    ${index}
      Should Be Equal    ${ret}     ${Isolate}

TC014 Set country code by using UCI 
      [Tags]    HFCL_5G     
      Set Country Regulatory Domain    ${dut}    ${index}    US
      Load WiFi    ${dut}
      sleep    5
      ${ret}    Get Regulatory Domain    ${dut}    ${index}
      Should Be Equal    ${ret}    US   

TC015 Set country code by using UCI 
      [Tags]    HFCL_5G     
      Set Country Regulatory Domain    ${dut}    ${index}    auto
      Load WiFi    ${dut}
      sleep    5
      ${ret}    Get Regulatory Domain    ${dut}    ${index}
      Should Be Equal    ${ret}    auto 

TC016 Verify 5GHZ Vap Creation
       [Tags]    HFCL_2G    PITSTOP
       Add Wifi Interface    ${dut}  
       Set Vap Name    ${dut}    ${vap_index}     ${vap_name}
       Set Vap Device    ${dut}    ${vap_index}     wifi0
       Set Wifi Iface Network     ${dut}    ${vap_index}     lan
       Set Encryption    ${dut}    ${vap_index}    ${secured_ap}
       Set Password    ${dut}    ${vap_index}    ${password}
       Set Ssid    ${dut}    ${vap_index}    ${vap_ssid_5g}
       Set Wifi Iface Mode    ${dut}    ${vap_index}    ${mode} 
       Set Isolate    ${dut}    ${vap_index}    ${Isolate}
       Set Interface State    ${dut}    ${vap_index}    ${1}
       Load WiFi    ${dut}
       Sleep    5
       ${ret}    Get Vap Name    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${vap_name} 
       ${ret}    Get Vap Device    ${dut}    ${vap_index}
       Should Be Equal    ${ret}   wifi0
       ${ret}    Get Wifi Iface Network    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    lan
       ${ret}    Get Encryption    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${secured_ap}
       ${ret}    Get Password    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${password}
       ${ret}    Get Ssid    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${vap_ssid_5g}
       ${ret}    Get Isolate    ${dut}    ${vap_index}
       Should Be Equal    ${ret}     ${Isolate}
       ${ret}    Get Interface State    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${1}
       Wait Until Keyword Succeeds    60    5    Check Vap Ssid    ${dut}    ${vap_index}    ${vap_ssid_5g}
       ${ret}    Get Wifi Iface Mode   ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${mode} 
       Wait Until Keyword Succeeds    30    3    check Vap Mode    ${dut}   ${vap_ssid_5g}    ${mode}
       ${ret}    delete_wifi_interface    ${dut}    ${vap_name} 
       Should Be Empty    ${ret}
