*** Settings ***
Library            zi4pitstop.lib.pitstop
Library            OperatingSystem
Suite Setup        Stop All Iperf Server In All Device


*** Variables ***
${PORT}              50001
${PROTOCOL_1}        TCP
${PROTOCOL_2}        UDP
${LOG_SERVER_1}      iperf_server_tc001.log
${LOG_CLIENT_1}      iperf_client_tc001.log
${LOG_SERVER_2}      iperf_server_tc002.log
${LOG_CLIENT_2}      iperf_client_tc002.log
${LOG_SERVER_3}      iperf_server_tc003.log
${LOG_CLIENT_3}      iperf_client_tc003.log
${LOG_SERVER_4}      iperf_server_tc004.log
${LOG_CLIENT_4}      iperf_client_tc004.log
${LOG_SERVER_5}      iperf_server_tc005.log
${LOG_CLIENT_5}      iperf_client_tc005.log
${LOG_SERVER_6}      iperf_server_tc006.log
${LOG_CLIENT_6}      iperf_client_tc006.log
${LOG_SERVER_7}      iperf_server_tc007.log
${LOG_CLIENT_7}      iperf_client_tc007.log
${LOG_SERVER_8}      iperf_server_tc008.log
${LOG_CLIENT_8}      iperf_client_tc008.log
${DUT_DEVICE}        ap
${CLIENT_DEVICE_1}   ap_lan_client_1
${CLIENT_DEVICE_2}   ap_lan_client_2
${DATA_FLOW_RECV}    Receiver
${DATA_FLOW_SEND}    Sender
${TCP_LOG}           tcp_stream.log
${UDP_LOG}           udp_stream.log
${TCP_MUL_LOG}       tcp_sum_stream.log
${UDP_MUL_LOG}       udp_sum_stream.log


*** Keywords ***
Remove Log Files From Test Pc
    ${rc} =  Run and Return RC  rm *.log
    Should Be Equal As Integers  ${rc}  0

Stop All Iperf Server In All Device
    Stop Iperf Server  ${CLIENT_DEVICE_2}
    Stop Iperf Server  ${CLIENT_DEVICE_1}

*** Test Cases ***
TC001:Verify Iperf Tcp Traffic Loss Between Lan Client1 And Lan Client2
    [Tags]   Performance
    ${server_ip}  Get Client Ipv4  ${CLIENT_DEVICE_1}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${CLIENT_DEVICE_1}  ${server_ip}  ${LOG_SERVER_1}  ${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_1}  ${LOG_CLIENT_1}  ${PORT}
    Iperf Log Should Exist  ${CLIENT_DEVICE_1}   ${LOG_SERVER_1}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_1}
    Get Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_1}   ${LOG_SERVER_1}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_1}  ${LOG_CLIENT_1}
    Remove Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_1}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_1}
    ${metrics}  Get Tcp Metrics  ${LOG_CLIENT_1}  ${DATA_FLOW_SEND}
    Log To Console  \nTCP metrics:${metrics}
    ${loss}  Get Packet Loss  ${LOG_CLIENT_1}  ${PROTOCOL_1}  ${DATA_FLOW_SEND}
    Should Be Equal As Integers  ${loss}  ${0}
    [Teardown]  Stop Iperf Server  ${CLIENT_DEVICE_1}

TC002:Verify Iperf Udp Traffic Loss Between Dut And Lan Client1
    [Tags]   Performance
    ${server_ip}  Get Dut Bridge Ipv4  ${DUT_DEVICE}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${DUT_DEVICE}  ${server_ip}  ${LOG_SERVER_2}  port=${12121}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_2}  ${LOG_CLIENT_2}  port=${12121}
    Iperf Log Should Exist  ${DUT_DEVICE}   ${LOG_SERVER_2}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_2}
    Get Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_2}   ${LOG_SERVER_2}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_2}  ${LOG_CLIENT_2}
    Remove Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_2}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_2}
    ${metrics}  Get Udp Metrics  ${LOG_CLIENT_2}  ${DATA_FLOW_SEND}
    Log To Console  \nUDP metrics:${metrics}
    [Teardown]  Stop Iperf Server  ${DUT_DEVICE}

TC003:Verify Iperf Parallel Tcp Traffic Between Lan Client1 And Lan Client2
    [Tags]   Performance
    ${server_ip}  Get Client Ipv4  ${CLIENT_DEVICE_1}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${CLIENT_DEVICE_1}  ${server_ip}  ${LOG_SERVER_3}  ${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_1}  ${LOG_CLIENT_3}  ${PORT}  mode=parallel  parallel_streams=${4}
    Iperf Log Should Exist  ${CLIENT_DEVICE_1}   ${LOG_SERVER_3}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_3}
    Get Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_3}   ${LOG_SERVER_3}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_3}  ${LOG_CLIENT_3}
    Remove Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_3}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_3}
    ${metrics}  Get Tcp Metrics  ${LOG_CLIENT_3}  ${DATA_FLOW_SEND}
    Log To Console  \nTCP metrics:${metrics}
    ${loss}  Get Packet Loss  ${LOG_CLIENT_3}  ${PROTOCOL_1}  ${DATA_FLOW_SEND}
    Should Be Equal As Integers  ${loss}  ${0}
    [Teardown]  Stop Iperf Server  ${CLIENT_DEVICE_1}

TC004:Verify Iperf Reverse Udp Traffic Loss Between Dut And Lan Client1
    [Tags]   Performance
    ${server_ip}  Get Dut Bridge Ipv4  ${DUT_DEVICE}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${DUT_DEVICE}  ${server_ip}  ${LOG_SERVER_4}  port=${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_2}  ${LOG_CLIENT_4}  ${PORT}  mode=reverse
    Iperf Log Should Exist  ${DUT_DEVICE}   ${LOG_SERVER_4}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_4}
    Get Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_4}   ${LOG_SERVER_4}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_4}  ${LOG_CLIENT_4}
    Remove Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_4}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_4}
    ${metrics}  Get Udp Metrics  ${LOG_CLIENT_4}  ${DATA_FLOW_SEND}
    Log To Console  \nUDP metrics:${metrics}
    [Teardown]  Stop Iperf Server  ${DUT_DEVICE}

TC005:Verify Iperf Windowing And Tos Of Tcp Traffic Between Lan Client1 And Lan Client2
    [Tags]   Performance
    ${server_ip}  Get Client Ipv4  ${CLIENT_DEVICE_1}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${CLIENT_DEVICE_1}  ${server_ip}  ${LOG_SERVER_5}  ${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_1}  ${LOG_CLIENT_5}  ${PORT}  tos=0x20  window_size=256K
    Iperf Log Should Exist  ${CLIENT_DEVICE_1}   ${LOG_SERVER_5}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_5}
    Get Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_5}   ${LOG_SERVER_5}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_5}  ${LOG_CLIENT_5}
    Remove Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_5}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_5}
    ${metrics}  Get Tcp Metrics  ${LOG_CLIENT_5}  ${DATA_FLOW_SEND}
    Log To Console  \nTCP metrics:${metrics}
    ${loss}  Get Packet Loss  ${LOG_CLIENT_5}  ${PROTOCOL_1}  ${DATA_FLOW_SEND}
    Should Be Equal As Integers  ${loss}  ${0}
    [Teardown]  Stop Iperf Server  ${CLIENT_DEVICE_1}

TC006:Verify Iperf Bidirectional Udp Traffic Loss Between Dut And Lan Client1
    [Tags]   Performance
    ${server_ip}  Get Dut Bridge Ipv4  ${DUT_DEVICE}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${DUT_DEVICE}  ${server_ip}  ${LOG_SERVER_6}  port=${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_2}  ${LOG_CLIENT_6}  ${PORT}  mode=bidir
    Iperf Log Should Exist  ${DUT_DEVICE}   ${LOG_SERVER_6}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_6}
    Get Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_6}   ${LOG_SERVER_6}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_6}  ${LOG_CLIENT_6}
    Remove Iperf Log  ${DUT_DEVICE}  ${LOG_SERVER_6}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_6}
    ${metrics}  Get Udp Metrics  ${LOG_CLIENT_6}  ${DATA_FLOW_SEND}   direction=transmitter
    Log To Console  \nUDP metrics:${metrics}
    ${jitter}   Get Jitter  ${LOG_CLIENT_6}  ${PROTOCOL_2}  ${DATA_FLOW_SEND}   direction=transmitter
    Log To Console  \nUDP jitter:${jitter}
    [Teardown]  Stop Iperf Server  ${DUT_DEVICE}

TC007:Verify Iperf Bidirectional Tcp Traffic Between Lan Client1 And Lan Client2
    [Tags]   Performance
    ${server_ip}  Get Client Ipv4  ${CLIENT_DEVICE_1}
    ${client_ip}  Get Client Ipv4  ${CLIENT_DEVICE_2}
    Start Iperf Server  ${CLIENT_DEVICE_1}  ${server_ip}  ${LOG_SERVER_7}  ${PORT}
    Start Iperf Client  ${CLIENT_DEVICE_2}  ${server_ip}  ${client_ip}  ${PROTOCOL_1}  ${LOG_CLIENT_7}  ${PORT}  mode=bidir
    Iperf Log Should Exist  ${CLIENT_DEVICE_1}   ${LOG_SERVER_7}
    Iperf Log Should Exist  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_7}
    Get Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_7}   ${LOG_SERVER_7}
    Get Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_7}  ${LOG_CLIENT_7}
    Remove Iperf Log  ${CLIENT_DEVICE_1}  ${LOG_SERVER_7}
    Remove Iperf Log  ${CLIENT_DEVICE_2}  ${LOG_CLIENT_7}
    ${metrics}  Get Tcp Metrics  ${LOG_CLIENT_7}  ${DATA_FLOW_SEND}  direction=receiver
    Log To Console  \nTCP metrics:${metrics}
    ${loss}  Get Packet Loss  ${LOG_CLIENT_7}  ${PROTOCOL_1}  ${DATA_FLOW_SEND}  direction=transmitter
    Should Be Equal As Integers  ${loss}  ${0}
    [Teardown]  Stop Iperf Server  ${CLIENT_DEVICE_1}
