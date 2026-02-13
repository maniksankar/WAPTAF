*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        This Suite Setup

*** Variables  ***
${5G_CHANNEL}    ${48}
${5G_HTMODE}    VHT80
${5G_BANDWIDTH}    ${80}
${2G_Ssid}  sanity_2g  
${5G_Ssid}  santiy_5g
${6G_Ssid}  sanity_6g
${5G_Encryption}  psk2+ccmp
${5G_Password}  zilo@123
${SSID}  ssid_valid

*** Keywords ***
This Suite Setup
    Set Radio State   ap   2g_radio_index   ${1}
    Set Radio State   ap   5g_radio_index   ${1}
    Set Radio State   ap   6g_radio_index   ${1}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Radio State    ap    2.4g_radio_index
    Should Be Equal    ${ret}    ${1}
    ${ret}    Get Radio State    ap    5g_radio_index
    Should Be Equal    ${ret}    ${1}
    ${ret}    Get Radio State    ap    6g_radio_index
    Should Be Equal    ${ret}    ${1}
    Set Client Radio State   ap_wlan_client_1  ${1}
    Sleep  3
    ${ret}  Get Client Radio State   ap_wlan_client_1
    Should Be Equal As Integers    ${1}    ${ret}

*** Test Cases ***
Verify WIFI Clients are getting connected in all the WLAN Interfaces
    [Tags]  Sanity
    Set Ssid    ap    2g_radio_index    ${2G_Ssid}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Ssid    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_Ssid}
    Check Ssid    ap    2g_radio_index    ${2G_Ssid}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}
        
Verify WIFI Clients are getting IP address from all the WLAN Interfaces.
    [Tags]  Sanity
    ${ret}    Get Client Ipv4    ap_wlan_client_1
    Log To Console    AP_WLAN_CLIENT_1 IPV4 address : ${ret}

Changing SSID to 2.4GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Ssid    ap    2g_radio_index    ${2G_Ssid_Change}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Ssid    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_Ssid}
    Check Ssid    ap    2g_radio_index    ${2G_Ssid}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing SSID to 5GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Ssid    ap    5g_radio_index    ${5G_Ssid}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Ssid    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Ssid}
    Check Ssid    ap    5g_radio_index    ${5G_Ssid}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing SSID to 6GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Ssid    ap    6g_radio_index    ${6G_Ssid}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Ssid    ap    6g_radio_index
    Should Be Equal    ${ret}    ${6G_Ssid}
    Check Ssid    ap    6g_radio_index    ${6G_Ssid}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing Channel to 2.4GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Channel    ap    2g_radio_index    ${2G_CHANNEL}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Channel    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_CHANNEL}
    Check Channel    ap    2g_radio_index    ${2G_CHANNEL}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}
    
Changing Channel to 5GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Channel    ap    5g_radio_index    ${5G_CHANNEL}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Channel    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_CHANNEL}
    Check Channel    ap    5g_radio_index    ${5G_CHANNEL}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing Channel to 6GHz radio and verify with a WiFi Client
    [Tags]  Sanity
    Set Channel    ap    6g_radio_index    ${6G_CHANNEL}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Channel    ap    6g_radio_index
    Should Be Equal    ${ret}    ${6G_CHANNEL}
    Check Channel    ap    6g_radio_index    ${6G_CHANNEL}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing Channel band Width to 2.4GHz radio and verify with a WiFi Client
    [Tags]  
    Set Bandwidth    ap    2g_radio_index    ${2G_HTMODE}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Bandwidth    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_HTMODE}
    Check Bandwidth    ap    2g_radio_index    ${2G_BANDWIDTH}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing Channel band Width to 5GHz radio and verify with a WiFi Client
    [Tags]
    Set Bandwidth    ap    5g_radio_index    ${5G_HTMODE}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Bandwidth    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_HTMODE}
    Check Bandwidth    ap    5g_radio_index    ${5G_BANDWIDTH}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Changing Channel band Width to 6GHz radio and verify with a WiFi Client
    [Tags]
    Set Bandwidth    ap    6g_radio_index    ${6G_HTMODE}
    Load Wifi    ap
    Sleep    3
    ${ret}    Get Bandwidth    ap    6g_radio_index
    Should Be Equal    ${ret}    ${6G_HTMODE}
    Check Bandwidth    ap    6g_radio_index    ${6G_BANDWIDTH}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Verify STA association to 2.4GHz channels in open authentication
    [Tags]  Sanity
    Set Encryption    ap    2g_radio_index    ${2G_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_Encryption}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Verify STA association to 5GHz channels in open authentication
    [Tags]  Sanity
    Set Encryption    ap    5g_radio_index    ${5G_Open_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Open_Encryption}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Change Encryption (WPA2+WPA3) method of 2.4GHz Interface and verify with WiFi Client
    [Tags]  Sanity
    Set Encryption    ap    2g_radio_index    ${2G_Secure_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    2g_radio_index
    Should Be Equal    ${ret}    ${2G_Secure_Encryption}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Change Encryption (WPA2+WPA3) method of 5GHz Interface and verify with WiFi Client 
    [Tags]  Sanity
    Set Encryption    ap    5g_radio_index    ${5G_Secure_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    5g_radio_index
    Should Be Equal    ${ret}    ${5G_Secure_Encryption}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}

Change Encryption (WPA2+WPA3) method of 6GHz Interface and verify with WiFi Client 
    [Tags]  Sanity
    Set Encryption    ap    6g_radio_index    ${6G_Secure_Encryption}
    Load Wifi    ap
    Sleep  3
    ${ret}    Get Encryption    ap    6g_radio_index
    Should Be Equal    ${ret}    ${6G_Secure_Encryption}
    Check Ap Ssid Visibility  ap_wlan_client_1  ${SSID}
    Connect Client To Ssid  ap_wlan_client_1  ${SSID}   ${PASSWORD}
    sleep  60
    ${ret}  Get Client Connected Ssid  ap_wlan_client_1
    Should Be Equal  ${SSID}  ${ret}
