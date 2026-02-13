*** Settings *** 
Library          zi4pitstop.lib.pitstop

*** Variables ***
${dut}    ap

*** Test Cases ***
Verify openwrt-OS version
    [Tags]    OPENWRT    SMOKE_SANITY
    Check Openwrt Version    ${dut}

Verify Openwrt - DISTRIB_RELEASE
    [Tags]    OPENWRT    SMOKE_SANITY
    Check OS Release    ${dut}

Verify Openwrt - DISTRIB_ARCH
    [Tags]    OPENWRT    SMOKE_SANITY
    Check Kernel Version    ${dut}

