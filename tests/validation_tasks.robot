# Demo Script to verify sanity of network

*** Settings ***
# Importing test libraries, resource files and variable files.
Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        unicon.robot.UniconRobot


# Genie Libraries to use
#${trigger_datafile}     /pyats/genie_yamls/iosxe/trigger_datafile_iosxe.yaml
#${verification_datafile}     /pyats/genie_yamls/iosxe/verification_datafile_iosxe.yaml

${trigger_datafile}     /pyats/genie_yamls/ios/trigger_datafile_ios.yaml
${verification_datafile}   /pyats/genie_yamls/ios/verification_datafile_ios.yaml

genie/libs/sdk/genie_yamls/ios/trigger_datafile_ios.yaml	

*** Test Cases ***
# Creating test cases from available keywords.

Initialize
    # Initializes the pyATS/Genie Testbed
    # pyATS Testbed can be used within pyATS/Genie
    use genie testbed "${testbed}"
    connect to devices "R1"
    connect to devices "R2"
    #connect to devices "core1"
    #connect to devices "core2"
    #connect to devices "access1"

Common Setup
  run testcase    reachability.pyats_loopback_reachability.common_setup

Capture Configuration
    execute "show running-config" on device "R1"

Ping
    run testcase     reachability.pyats_loopback_reachability.PingTestcase        device=R1
    run testcase     reachability.pyats_loopback_reachability.PingTestcase        device=R2
#   run testcase     reachability.pyats_loopback_reachability.NxosPingTestcase    device=dist1
#   run testcase     reachability.pyats_loopback_reachability.NxosPingTestcase    device=dist2

# Verify OSPF neighbor counts
Verify Ospf neighbors dist1
    verify count "6" "ospf neighbors" on device "R1"
Verify Ospf neighbors dist2
    verify count "6" "ospf neighbors" on device "R2"
#Verify Ospf neighbors core1
#    verify count "3" "ospf neighbors" on device "core1"
#Verify Ospf neighbors core2
#    verify count "3" "ospf neighbors" on device "core1"


# Verify Interfaces
Verify Interface R1
    verify count "15" "interface up" on device "R1"
Verify Interface R2
    verify count "15" "interface up" on device "R2"
#Verify Interface core1
#    verify count "5" "interface up" on device "core1"
#Verify Interface core2
#    verify count "5" "interface up" on device "core2"

Terminate
    run testcase "reachability.pyats_loopback_reachability.common_cleanup"
