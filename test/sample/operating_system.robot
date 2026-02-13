*** Settings *** 
Library          zi4pitstop.lib.pitstop

*** Variables ***
${dut}    ap

*** Test Cases ***
Verify openwrt-OS version
    [Tags]    Openwrt
    Check Openwrt Version    ${dut}

Verify Openwrt - DISTRIB_RELEASE
    [Tags]    Openwrt
    Check OS Release    ${dut}

Verify Openwrt - DISTRIB_ARCH
    [Tags]    Openwrt
    Check Kernel Version    ${dut}

