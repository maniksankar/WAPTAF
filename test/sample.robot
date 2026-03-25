*** Settings ***
Library    zi4pitstop.lib.pitstop
Suite Setup   Initial Setup 

*** Variables  ***
${5G_CHANNEL}    ${48}
${5G_HTMODE}    VHT80
${5G_BANDWIDTH}    ${80}
${5G_STANDARD}    11axn
${5G_TXPOWER}    ${25}
${5G_REG}    DE
${SSID}      ssid_valid
${PASSWORD}  zilo@123

*** Keywords ***
Initial Setup
    Initialize Database    ${CONFIG_DIR}
    @{devices}  Get Testbed Devices
    FOR  ${device}  IN  @{devices}
        Connect With Device  ${device}
    END

*** Test Cases ***
Verify the interface 
    Set Interface From Database    ap    2g_radio_index
    Load Wifi    ap
    Sleep    10
    ${ret}    Get Interface    ap    2g_radio_index
    ${iface}    Read From Database    ap    wifi_ifname
    ${index}    Read From Database    ap    2g_radio_index
    Should Be Equal    ${ret}    ${iface}${index}
    Wait Until Keyword Succeeds    30    1    Check Interface    ap    2g_radio_index

