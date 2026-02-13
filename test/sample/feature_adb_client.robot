*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        This Suite Setup


*** Variables  ***
${5G_CHANNEL}      ${48}
${5G_HTMODE}       VHT80
${5G_BANDWIDTH}    ${80}
${5G_STANDARD}     11axn
${5G_TXPOWER}      ${25}
${5G_REG}          DE
${SSID}            ssid_valid
${PASSWORD}        zilo@123


*** Keywords ***
This Suite Setup
    Set Radio State   ap   5g_radio_index   ${1}
    Set Channel    ap    5g_radio_index    ${5G_CHANNEL}
    Set Bandwidth    ap    5g_radio_index    ${5G_HTMODE}
    Set Radio Standard   ap   5g_radio_index   ${5G_STANDARD}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}
    # Check Channel    ap    5g_radio_index    ${5G_CHANNEL}
    # Check Bandwidth    ap    5g_radio_index    ${5G_BANDWIDTH}
    # ${ret}    Get Radio Standard    ap    5g_radio_index
    # Should Be Equal    ${ret}    ${5G_STANDARD}

*** Test Cases ***
Test Case Client Os
    [Tags]    clientos   adb
    ${ret}    Get Client Os    ap_wlan_client_4
    Log To Console    AP_WLAN_CLIENT_4 : ${ret}

Test Case Get Client Ipv4 Address
    [Tags]    Getipv4    adb
    ${ret}    Get Client Ipv4    ap_wlan_client_4
    Log To Console    AP_WLAN_CLIENT_4 IPV4 address : ${ret}

Test Case Client Radio State
    [Tags]   Radiostate   adb
    Set Client Radio State   ap_wlan_client_4  ${0}
    Sleep  3
    ${ret}  Get Client Radio State   ap_wlan_client_4
    Should Be Equal As Integers    ${0}    ${ret}
    Set Client Radio State   ap_wlan_client_4  ${1}
    Sleep  3
    ${ret}  Get Client Radio State   ap_wlan_client_4
    Should Be Equal As Integers    ${1}    ${ret}

Test Case Client Interface State
    [Tags]   Interfacestate   adb
    Set Client Radio State   ap_wlan_client_4  ${1}
    Sleep  3
    Set Client Interface State   ap_wlan_client_4  ${0}
    Sleep  3
    ${ret}  Get Client Interface State   ap_wlan_client_4
    Should Be Equal As Integers    ${0}    ${ret}
    Set Client Interface State   ap_wlan_client_4  ${1}
    Sleep  30
    ${ret}  Get Client Interface State   ap_wlan_client_4
    Should Be Equal As Integers    ${1}    ${ret}

Test Case Get Client Ssid Availability
    [Tags]  ssidavailability   adb
    Set Client Radio State   ap_wlan_client_4  ${1}
    Sleep  3
    ${ret}  Get Client Radio State   ap_wlan_client_4
    Should Be Equal As Integers    ${1}    ${ret}
    Check Ap Ssid Visibility  ap_wlan_client_4  ${SSID}
    ${ret}  Get Ap Bssid Visibility  ap_wlan_client_4  ${SSID}
    Should Not Be Empty  ${ret}
    Log To Console  \nBSSID:${ret}

Test Case Connect Client To Ssid
    [Tags]  connectssid   adb
    Set Client Radio State   ap_wlan_client_4  ${1}
    Sleep  3
    ${ret}  Get Client Radio State   ap_wlan_client_4
    Should Be Equal As Integers    ${1}    ${ret}
    Check Ap Ssid Visibility  ap_wlan_client_4  ${SSID}
    Remove All Wifi Connections  ap_wlan_client_4
    sleep  1
    Connect Client To Ssid  ap_wlan_client_4  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_4
    Should Be Equal  ${SSID}  ${ret}
    ${ret}  Get Client Channel  ap_wlan_client_4
    Log To Console  \nConnected Channel: ${ret}\n
    ${ret}  Get Client Bandwidth  ap_wlan_client_4
    Log To Console  \nConnected bandwidth: ${ret}\n
    ${ret}  Get Client Encryption  ap_wlan_client_4
    Log To Console  \nConnected encryption: ${ret}\n
    ${ret}  Get Client Frequency  ap_wlan_client_4
    Log To Console  \nConnected Frequency: ${ret}\n
    ${ret}  Get Client Rssi  ap_wlan_client_4
    Log To Console  \nConnected RSSI: ${ret}\n
    Disconnect Wifi Client  ap_wlan_client_4
