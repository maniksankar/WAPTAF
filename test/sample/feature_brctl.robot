*** Settings ***
Library    zi4pitstop.lib.pitstop

*** Variables ***
${dut}    ap

*** Test Cases ***

Verify Brctl Show Execution
    [Tags]    BRCTL    SMOKE_SANITY
    Check Brctl Show    ${dut}
