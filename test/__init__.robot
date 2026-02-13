*** Settings ***
Library            zi4pitstop.lib.pitstop
Suite Setup        This Suite Setup
Suite Teardown     Close All Connections

*** Keywords ***
This Suite Setup
    Initialize Database    ${CONFIG_DIR}
    @{devices}  Get Testbed Devices
    FOR  ${device}  IN  @{devices}
        Connect With Device  ${device}
    END

Close All Connections
    #Close Connection    ap
    #Close Connection    ap_lan_client_1
    #Close Connection    ap_wlan_client_1
    @{devices}  Get Testbed Devices
    FOR  ${device}  IN  @{devices}
        Close Connection  ${device}
    END
