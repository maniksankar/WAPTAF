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


${vap_index}     vap_index
${radio}    wifi1
${vap_name}  Vap1
${vap_ssid_2g}  OpenWrt_vap_2g
  
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

TC001 Verify Configure Standard in 2.4GHZ Radio
       [Tags]    HFCL_2G
       Set Radio Standard    ${dut}    ${index}    ${standard}
       Load Wifi    ${dut}
       ${ret}    Get Radio Standard    ${dut}    ${index}
       Should Be Equal    ${ret}    ${standard}

TC002 Verify Configure Radio Type in 2.4GHZ Radio
       [Tags]    HFCL_2G      
       Set Radio Type    ${dut}    ${index}    ${radio_type}
       Load WiFi    ${dut}
       Sleep    5
       ${ret}    Get Radio Type    ${dut}     ${index}
       Should Be Equal    ${ret}    ${radio_type}
              

TC003 Verify Configure Bandwidth 20 in 5GHZ Radio
       [Tags]    HFCL_2G
       Set Bandwidth    ${dut}    ${index}    20
       Load Wifi    ${dut}
       Sleep    3
       ${ret}    Get Bandwidth    ${dut}    ${index}
       Should Be Equal    ${ret}    20
       Wait Until Keyword Succeeds    30    3    Check Bandwidth    ${dut}    ${index}    20

TC004 Verify Configure Channel 6 in 2.4GHz Radio
       [Tags]    HFCL_2G
       Set Channel    ${dut}    ${index}    ${6}
       Load WiFi    ${dut}
       Wait Until Keyword Succeeds    30    3    Check Channel    ${dut}    ${index}    ${6}
              
TC005 Verify Configure Txpower 20 in 2.4GHZ Radio
       [Tags]    HFCL_2G    
       Set Txpower    ${dut}    ${index}    ${20}
       Load Wifi    ${dut}
       ${ret}    Get Txpower    ${dut}    ${index}
       Should Be Equal    ${ret}    ${20}
       Wait Until Keyword Succeeds    60    5    Check Txpower    ${dut}    ${index}    ${20}

TC006 Set country code by using UCI
      [Tags]    HFCL_2G
      Set Country Regulatory Domain    ${dut}    ${index}    auto    
      Load WiFi    ${dut}
      sleep    5
      ${ret}    Get Regulatory Domain    ${dut}    ${index}
      Should Be Equal    ${ret}    auto

TC007 Set country code by using UCI
      [Tags]    HFCL_2G
      Set Country Regulatory Domain    ${dut}    ${index}    US
      Load WiFi    ${dut}
      sleep    5
      ${ret}    Get Regulatory Domain    ${dut}    ${index}
      Should Be Equal    ${ret}    US

TC008 Verify Configure Enable WiFi1 Radio in 2.4GHZ
       [Tags]    HFCL_2G
       Set Radio State    ${dut}    ${index}    ${1}
       Load WiFi    ${dut}
       ${ret}    Get Radio State    ${dut}    ${index}
       Should Be Equal    ${ret}    ${1}       

TC009 Verify Configure wifi interface device name is assigned to 2.4GHZ Radio
       [Tags]    HFCL_2G    
       Set Wifi Iface Device    ${dut}    ${index}    ${radio} 
       Load Wifi    ${dut}
       ${ret}    Get Wifi Iface Device    ${dut}    ${index} 
       Should Be Equal    ${ret}    ${radio} 
       
TC010 Verify Configure wifi network is assigned to 2.4GHZ Radio
      [Tags]    HFCL_2G        
      Set Wifi Iface Network    ${dut}    ${index}    lan
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Wifi Iface Network    ${dut}   ${index}
      Should Be Equal    ${ret}    lan      

TC011 Verify Configure Mode is assigned to 2.4GHZ Radio
      [Tags]    HFCL_2G    
      Set Wifi Iface Mode   ${dut}    ${index}    ${mode}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Wifi Iface Mode    ${dut}   ${index}
      Should Be Equal    ${ret}    ${mode}
      

TC012 Verify Configure Wifi SSID is assigned to 2.4GHZ Radio
      [Tags]    HFCL_2G    
      Set Ssid    ${dut}    ${index}    ${ssid}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Ssid    ${dut}    ${index}
      Should Be Equal    ${ret}    ${ssid}
      Wait Until Keyword Succeeds    60    5    Check Ssid    ${dut}    ${index}    ${ssid}

TC013 Verify Configure WiFi Encryption is assigned to 2.4GHZ Radio
      [Tags]    HFCL_2G    
      Set Encryption    ${dut}    ${index}    ${secured_ap}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Encryption    ${dut}    ${index}
      Should Be Equal    ${ret}    ${secured_ap}

TC014 Verify Configure WiFi key is assigned to 2.4GHZ Radio
      [Tags]    HFCL_2G    
      Set Password    ${dut}    ${index}    ${password}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Password    ${dut}    ${index}
      Should Be Equal    ${ret}    ${password}

TC015 Verify Configure Wifi Interface Isolated to 2.4GHZ Radio
      [Tags]    HFCL_2G    
      Set Isolate    ${dut}    ${index}    ${Isolate}
      Load WiFi    ${dut}
      Sleep    5
      ${ret}    Get Isolate    ${dut}    ${index}
      Should Be Equal    ${ret}     ${Isolate}

TC016 Verify 2.4GHZ Vap Creation
       [Tags]    HFCL_2G    
       Add Wifi Interface    ${dut}  
       Set Vap Name    ${dut}    ${vap_index}     ${vap_name}
       Set Vap Device    ${dut}    ${vap_index}     wifi1
       Set Wifi Iface Network     ${dut}    ${vap_index}     lan
       Set Encryption    ${dut}    ${vap_index}    ${secured_ap}
       Set Password    ${dut}    ${vap_index}    ${password}
       Set Ssid    ${dut}    ${vap_index}    ${vap_ssid_2g}
       Set Wifi Iface Mode    ${dut}    ${vap_index}    ${mode} 
       Set Isolate    ${dut}    ${vap_index}    ${Isolate}
       Set Interface State    ${dut}    ${vap_index}    ${1}
       Load WiFi    ${dut}
       Sleep    5
       ${ret}    Get Vap Name    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${vap_name} 
       ${ret}    Get Vap Device    ${dut}    ${vap_index}
       Should Be Equal    ${ret}   wifi1
       ${ret}    Get Wifi Iface Network    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    lan
       ${ret}    Get Encryption    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${secured_ap}
       ${ret}    Get Password    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${password}
       ${ret}    Get Ssid    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${vap_ssid_2g}
       ${ret}    Get Isolate    ${dut}    ${vap_index}
       Should Be Equal    ${ret}     ${Isolate}
       ${ret}    Get Interface State    ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${1}
       Wait Until Keyword Succeeds    60    5    Check Vap Ssid    ${dut}    ${vap_index}    ${vap_ssid_2g}
       ${ret}    Get Wifi Iface Mode   ${dut}    ${vap_index}
       Should Be Equal    ${ret}    ${mode} 
       Wait Until Keyword Succeeds    30    3    check Vap Mode    ${dut}    ${vap_ssid_2g}    ${mode}
       ${ret}    delete_wifi_interface    ${dut}    ${vap_name} 
       Should Be Empty    ${ret}  
       




       




