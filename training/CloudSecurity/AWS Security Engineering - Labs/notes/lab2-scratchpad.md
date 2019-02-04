

# Parse all of the inspector rules 

```
[ec2-user@ip-10-96-10-152 ~]$ for arn in $(aws inspector list-rules-packages | grep -i arn: | sed 's/[", ]//g;'); do echo "--------------" ; echo $arn; echo "--------------" ; aws inspector describe-rules-packages --rules-package-arns $arn --query  rulesPackages[*].[name,description] --output text; done
--------------
arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p
--------------
Common Vulnerabilities and Exposures	The rules in this package help verify whether the EC2 instances in your application are exposed to Common Vulnerabilities and Exposures (CVEs). Attacks can exploit unpatched vulnerabilities to compromise the confidentiality, integrity, or availability of your service or data. The CVE system provides a reference for publicly known information security vulnerabilities and exposures. For more information, see [https://cve.mitre.org/](https://cve.mitre.org/). If a particular CVE appears in one of the produced Findings at the end of a completed Inspector assessment, you can search [https://cve.mitre.org/](https://cve.mitre.org/) using the CVE's ID (for example, "CVE-2009-0021") to find detailed information about this CVE, its severity, and how to mitigate it.
--------------
arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc
--------------
CIS Operating System Security Configuration Benchmarks	The CIS Security Benchmarks program provides well-defined, un-biased and consensus-based industry best practices to help organizations assess and improve their security.

The rules in this package help establish a secure configuration posture for the following operating systems:

  -   Amazon Linux version 2015.03 (CIS benchmark v1.1.0)
  -   Windows Server 2008 R2 (CIS Benchmark for Microsoft Windows 2008 R2, v3.0.0, Level 1 Domain Controller)
  -   Windows Server 2008 R2 (CIS Benchmark for Microsoft Windows 2008 R2, v3.0.0, Level 1 Member Server Profile)
  -   Windows Server 2012 R2 (CIS Benchmark for Microsoft Windows Server 2012 R2, v2.2.0, Level 1 Member Server Profile)
  -   Windows Server 2012 R2 (CIS Benchmark for Microsoft Windows Server 2012 R2, v2.2.0, Level 1 Domain Controller Profile)
  -   Windows Server 2012 (CIS Benchmark for Microsoft Windows Server 2012 non-R2, v2.0.0, Level 1 Member Server Profile)
  -   Windows Server 2012 (CIS Benchmark for Microsoft Windows Server 2012 non-R2, v2.0.0, Level 1 Domain Controller Profile)
  -   Amazon Linux (CIS Benchmark for Amazon Linux Benchmark v2.1.0 Level 1)
  -   Amazon Linux (CIS Benchmark for Amazon Linux Benchmark v2.1.0 Level 2)
  -   CentOS Linux 7 (CIS Benchmark for CentOS Linux 7 Benchmark v2.2.0 Level 1 Server)
  -   CentOS Linux 7 (CIS Benchmark for CentOS Linux 7 Benchmark v2.2.0 Level 2 Server)
  -   CentOS Linux 7 (CIS Benchmark for CentOS Linux 7 Benchmark v2.2.0 Level 1 Workstation)
  -   CentOS Linux 7 (CIS Benchmark for CentOS Linux 7 Benchmark v2.2.0 Level 2 Workstation)
  -   Red Hat Enterprise Linux 7 (CIS Benchmark for Red Hat Enterprise Linux 7 Benchmark v2.1.1 Level 1 Server)
  -   Red Hat Enterprise Linux 7 (CIS Benchmark for Red Hat Enterprise Linux 7 Benchmark v2.1.1 Level 2 Server)
  -   Red Hat Enterprise Linux 7 (CIS Benchmark for Red Hat Enterprise Linux 7 Benchmark v2.1.1 Level 1 Workstation)
  -   Red Hat Enterprise Linux 7 (CIS Benchmark for Red Hat Enterprise Linux 7 Benchmark v2.1.1 Level 2 Workstation)
  -   Ubuntu Linux 16.04 LTS (CIS Benchmark for Ubuntu Linux 16.04 LTS Benchmark v1.1.0 Level 1 Server)
  -   Ubuntu Linux 16.04 LTS (CIS Benchmark for Ubuntu Linux 16.04 LTS Benchmark v1.1.0 Level 2 Server)
  -   Ubuntu Linux 16.04 LTS (CIS Benchmark for Ubuntu Linux 16.04 LTS Benchmark v1.1.0 Level 1 Workstation)
  -   Ubuntu Linux 16.04 LTS (CIS Benchmark for Ubuntu Linux 16.04 LTS Benchmark v1.1.0 Level 2 Workstation)
  -   CentOS Linux 6 (CIS Benchmark for CentOS Linux 6 Benchmark v2.0.2, Level 1 Server)
  -   CentOS Linux 6 (CIS Benchmark for CentOS Linux 6 Benchmark v2.0.2, Level 2 Server)
  -   CentOS Linux 6 (CIS Benchmark for CentOS Linux 6 Benchmark v2.0.2, Level 1 Workstation)
  -   CentOS Linux 6 (CIS Benchmark for CentOS Linux 6 Benchmark v2.0.2, Level 2 Workstation)
  -   Red Hat Enterprise Linux 6 (CIS Benchmark for Red Hat Enterprise Linux 6 Benchmark v2.0.2, Level 1 Server)
  -   Red Hat Enterprise Linux 6 (CIS Benchmark for Red Hat Enterprise Linux 6 Benchmark v2.0.2, Level 2 Server)
  -   Red Hat Enterprise Linux 6 (CIS Benchmark for Red Hat Enterprise Linux 6 Benchmark v2.0.2, Level 1 Workstation)
  -   Red Hat Enterprise Linux 6 (CIS Benchmark for Red Hat Enterprise Linux 6 Benchmark v2.0.2 Level 2 Workstation)
  -   Ubuntu Linux 14.04 LTS (CIS Benchmark for Ubuntu Linux 14.04 LTS Benchmark v2.0.0, Level 1 Server)
  -   Ubuntu Linux 14.04 LTS (CIS Benchmark for Ubuntu Linux 14.04 LTS Benchmark v2.0.0, Level 2 Server)
  -   Ubuntu Linux 14.04 LTS (CIS Benchmark for Ubuntu Linux 14.04 LTS Benchmark v2.0.0, Level 1 Workstation)
  -   Ubuntu Linux 14.04 LTS (CIS Benchmark for Ubuntu Linux 14.04 LTS Benchmark v2.0.0, Level 2 Workstation)

If a particular CIS benchmark appears in a finding produced by an Amazon Inspector assessment run, you can download a detailed PDF description of the benchmark from https://benchmarks.cisecurity.org/ (free registration required). The benchmark document provides detailed information about this CIS benchmark, its severity, and how to mitigate it.

--------------
arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ
--------------
Security Best Practices	The rules in this package help determine whether your systems are configured securely.
--------------
arn:aws:inspector:us-west-2:758058086616:rulespackage/0-rD1z6dpl
--------------
Network Reachability	These rules analyze the reachability of your instances over the network. Attacks can exploit your instances over the network by accessing services that are listening on open ports. These rules evaluate the security your host configuration in AWS to determine if it allows access to ports and services over the network. For reachable ports and services, the Amazon Inspector findings identify where they can be reached from, and provide guidance on how to restrict access to these ports.
--------------
arn:aws:inspector:us-west-2:758058086616:rulespackage/0-vg5GGHSD
--------------
Runtime Behavior Analysis	These rules analyze the behavior of your instances during an assessment run, and provide guidance on how to make your instances more secure.
```


creating assessment template:
```
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-resource-group --resource-group-tags key=SecurityScan,value=true
{
    "resourceGroupArn": "arn:aws:inspector:us-west-2:208610801059:resourcegroup/0-LHv6cz7S"
}
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-target --assessment-target-name GamesDevTargetGroup --resource-group-arn
usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:

  aws help
  aws <command> help
  aws <command> <subcommand> help
aws: error: argument --resource-group-arn: expected one argument
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-target --assessment-target-name GamesDevTargetGroup --resource-group-arn  arn:aws:inspector:us-west-2:208610801059:resourcegroup/0-LHv6cz7S

An error occurred (InvalidInputException) when calling the CreateAssessmentTarget operation: Create assessmentTarget - Name already exists; Name: GamesDevTargetGroup ParentOwner: 208610801059
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-target --assessment-target-name aGamesDevTargetGroup --resource-group-arn  arn:aws:inspector:us-west-2:208610801059:resourcegroup/0-LHv6cz7S
{
    "assessmentTargetArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi"
}
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-template
usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:

  aws help
  aws <command> help
  aws <command> <subcommand> help
aws: error: argument --assessment-target-arn is required
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-template^C
[ec2-user@ip-10-96-10-152 ~]$ aws inspector create-assessment-template --assessment-target-arn arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi --assessment-template-name CISCommonVulerBestPract-Short --duration-in-seconds 900 --rules-package-arns arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ
{
    "assessmentTemplateArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j"
```

Task 3 - #18 
```
[ec2-user@ip-10-96-10-152 ~]$ aws inspector preview-agents --preview-agents-arn arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j
{
    "agentPreviews": [
        {
            "kernelVersion": "4.1.10-17.31.amzn1.x86_64",
            "ipv4Address": "18.237.2.138",
            "agentHealth": "HEALTHY",
            "hostname": "ec2-18-237-2-138.us-west-2.compute.amazonaws.com",
            "agentVersion": "1.1.1098.0",
            "agentId": "i-0267fda751ceb9af9",
            "operatingSystem": "Amazon Linux AMI release 2015.09"
        },
        {
            "kernelVersion": "4.15.0-1017-aws",
            "ipv4Address": "54.203.1.152",
            "agentHealth": "HEALTHY",
            "hostname": "ec2-54-203-1-152.us-west-2.compute.amazonaws.com",
            "agentVersion": "1.1.1098.0",
            "agentId": "i-08af9a84ab2f0159a",
            "operatingSystem": "\"Ubuntu 18.04.1 LTS\""
        }
    ]
}


[ec2-user@ip-10-96-10-152 ~]$ aws inspector start-assessment-run --assessment-template-arn arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j --assessment-run-name  FirstAssessment
{
    "assessmentRunArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q"
}


[ec2-user@ip-10-96-10-152 ~]$ aws inspector describe-assessment-runs --assessment-run-arn arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q
{
    "failedItems": {},
    "assessmentRuns": [
        {
            "dataCollected": false,
            "name": "FirstAssessment",
            "userAttributesForFindings": [],
            "stateChanges": [
                {
                    "state": "CREATED",
                    "stateChangedAt": 1548388113.517
                },
                {
                    "state": "START_DATA_COLLECTION_PENDING",
                    "stateChangedAt": 1548388113.599
                },
                {
                    "state": "COLLECTING_DATA",
                    "stateChangedAt": 1548388114.568
                }
            ],
            "createdAt": 1548388113.517,
            "notifications": [],
            "state": "COLLECTING_DATA",
            "stateChangedAt": 1548388114.568,
            "durationInSeconds": 900,
            "rulesPackageArns": [
                "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p",
                "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc",
                "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ"
            ],
            "startedAt": 1548388114.568,
            "assessmentTemplateArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j",
            "arn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q"
        }
    ]
}

[ec2-user@ip-10-96-10-152 ~]$ aws inspector list-assessment-run-agents --assessment-run-arn arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q
{
    "assessmentRunAgents": [
        {
            "agentHealthCode": "RUNNING",
            "assessmentRunArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q",
            "agentId": "i-0267fda751ceb9af9",
            "agentHealth": "HEALTHY",
            "telemetryMetadata": [
                {
                    "count": 621,
                    "dataSize": 527656,
                    "messageType": "Total"
                },
                {
                    "count": 3,
                    "dataSize": 255,
                    "messageType": "InspectorTimeEventMsg"
                },
                {
                    "count": 14,
                    "dataSize": 3212,
                    "messageType": "InspectorDirectoryInfoMsg"
                },
                {
                    "count": 7,
                    "dataSize": 401080,
                    "messageType": "InspectorOvalMsg"
                },
                {
                    "count": 1,
                    "dataSize": 1584,
                    "messageType": "InspectorRetrieverCompletionStatusMsg"
                },
                {
                    "count": 1,
                    "dataSize": 2513,
                    "messageType": "InspectorListeningProcess"
                },
                {
                    "count": 1,
                    "dataSize": 2770,
                    "messageType": "InspectorAgentMsgStatsMsg"
                },
                {
                    "count": 1,
                    "dataSize": 386,
                    "messageType": "InspectorOperatingSystem"
                },
                {
                    "count": 1,
                    "dataSize": 0,
                    "messageType": "InspectorSplitMsgBegin"
                },
                {
                    "count": 1,
                    "dataSize": 0,
                    "messageType": "InspectorSplitMsgEnd"
                },
                {
                    "count": 1,
                    "dataSize": 80,
                    "messageType": "InspectorMonitoringStart"
                },
                {
                    "count": 71,
                    "dataSize": 7657,
                    "messageType": "InspectorTerminal"
                },
                {
                    "count": 27,
                    "dataSize": 5861,
                    "messageType": "InspectorUser"
                },
                {
                    "count": 44,
                    "dataSize": 3971,
                    "messageType": "InspectorGroup"
                },
                {
                    "count": 44,
                    "dataSize": 31917,
                    "messageType": "InspectorConfigurationInfo"
                },
                {
                    "count": 404,
                    "dataSize": 66370,
                    "messageType": "InspectorPackageInfo"
                }
            ]
        },
        {
            "agentHealthCode": "RUNNING",
            "assessmentRunArn": "arn:aws:inspector:us-west-2:208610801059:target/0-Xx0Chloi/template/0-HA1Gvr4j/run/0-cqQeIq9Q",
            "agentId": "i-08af9a84ab2f0159a",
            "agentHealth": "HEALTHY",
            "telemetryMetadata": [
                {
                    "count": 817,
                    "dataSize": 171320,
                    "messageType": "Total"
                },
                {
                    "count": 1,
                    "dataSize": 714,
                    "messageType": "InspectorListeningProcess"
                },
                {
                    "count": 1,
                    "dataSize": 2770,
                    "messageType": "InspectorAgentMsgStatsMsg"
                },
                {
                    "count": 1,
                    "dataSize": 366,
                    "messageType": "InspectorOperatingSystem"
                },
                {
                    "count": 1,
                    "dataSize": 80,
                    "messageType": "InspectorMonitoringStart"
                },
                {
                    "count": 4,
                    "dataSize": 340,
                    "messageType": "InspectorTimeEventMsg"
                },
                {
                    "count": 72,
                    "dataSize": 7773,
                    "messageType": "InspectorTerminal"
                },
                {
                    "count": 31,
                    "dataSize": 7096,
                    "messageType": "InspectorUser"
                },
                {
                    "count": 12,
                    "dataSize": 2742,
                    "messageType": "InspectorDirectoryInfoMsg"
                },
                {
                    "count": 56,
                    "dataSize": 5098,
                    "messageType": "InspectorGroup"
                },
                {
                    "count": 30,
                    "dataSize": 50783,
                    "messageType": "InspectorConfigurationInfo"
                },
                {
                    "count": 607,
                    "dataSize": 92005,
                    "messageType": "InspectorPackageInfo"
                },
                {
                    "count": 1,
                    "dataSize": 1553,
                    "messageType": "InspectorRetrieverCompletionStatusMsg"
                }
            ]
        }
    ]
}

```


# Task 4 - create and apply a patch baseline
```
[ec2-user@ip-10-96-10-152 ~]$ aws ssm describe-document --name "AWS-PatchInstanceWithRollback" --query "Document.[Name,Description,PlatformTypes]"
[
    "AWS-PatchInstanceWithRollback",
    "Brings EC2 Instance into compliance with standing Baseline; rolls back root Volume on failure",
    [
        "Windows",
        "Linux"
    ]
]

[ec2-user@ip-10-96-10-152 ~]$ aws ssm describe-instance-information  --query "InstanceInformationList[*]"
[
    {
        "IsLatestVersion": true,
        "ComputerName": "ip-10-96-10-169.us-west-2.compute.internal",
        "PingStatus": "Online",
        "InstanceId": "i-0267fda751ceb9af9",
        "IPAddress": "10.96.10.169",
        "ResourceType": "EC2Instance",
        "AgentVersion": "2.3.372.0",
        "PlatformVersion": "2015.09",
        "PlatformName": "Amazon Linux AMI",
        "PlatformType": "Linux",
        "LastPingDateTime": 1548388339.959
    },
    {
        "IsLatestVersion": false,
        "ComputerName": "ip-10-96-10-172",
        "PingStatus": "Online",
        "InstanceId": "i-08af9a84ab2f0159a",
        "IPAddress": "10.96.10.172",
        "ResourceType": "EC2Instance",
        "AgentVersion": "2.2.619.0",
        "PlatformVersion": "18.04",
        "PlatformName": "Ubuntu",
        "PlatformType": "Linux",
        "LastPingDateTime": 1548388539.316
    }
]
```