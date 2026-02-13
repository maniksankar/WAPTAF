*** Settings ***
Library            zi4pitstop.lib.pitstop

*** Variables ***
${DEVICE}           sniffer
${PCAP_FILENAME}    mytestcapture

*** Test Cases ***
Sniffing Workflow Test
     [Tags]    st01
    [Documentation]    This test demonstrates the start, stop, and fetch of a pcap file using PacketSniffer keywords.
    
    # Step 1: Ensure device is in managed mode (if applicable via custom keyword)
    ${status}=    Set Managed Mode    ${DEVICE}
    Log    Device managed mode set: ${status}

    # Step 2: Start sniffing
    ${PCAP_PATH}=    Start Sniffing    ${DEVICE}    ${PCAP_FILENAME}
    Log    Sniffing started, output file: ${PCAP_PATH}

    # [Optional delay or action under test goes here]
    Sleep    5s

    # Step 3: Stop sniffing
    ${stop_status}=    Stop Sniffing    ${DEVICE}
    Log    Sniffing stopped: ${stop_status}

    # Step 4: Fetch the .pcap file
    Get Pcap File    ${DEVICE}    ${PCAP_PATH}
    Log    PCAP file fetched successfully from: ${PCAP_PATH}