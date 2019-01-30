<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 2 - Using AWS Systems Manager and Amazon Inspector</h1>

<p><strong>Overview</strong></p>

<p>Patch management is an on going task. The more the servers deployed, the larger the fleet that needs to be patched. In this lab, you will use AWS Systems Manager which is a scalable tool for remote management of your fleet of Amazon EC2 instances. You will use the Systems Manager Run Command to install the Amazon Inspector agent on the fleet of instances. The agent enables EC2 instances to communicate with the Amazon Inspector service. You will use Amazon Inspector to run security assessments on your EC2 instances and then create a baseline patch using the Systems Manager Automation feature to bring your instances back to compliance.</p>

<p>As a part of the lab set up, you are provided with two EC2 instances with the Systems Manager agent already installed on them. These EC2 instances act as your fleet of instances. A third EC2 instance and CommandHost acts as a jump server for you to SSH into and remotely administer your fleet of EC2 instance.</p>

<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>  Run commands on a group of EC2 instances using AWS Systems Manager Run command</li>
<li>  Setup and run an Inspector scan</li>
<li>  Resolve findings from the Inspector Scan</li>
<li>  Enforce patch baseline to instances via AWS Systems Manager Automation</li>
</ul>
<p><strong>Prerequisites</strong></p>

<p>This lab requires:</p>
<ul>
<li>Access to a notebook computer with Wi-Fi running Microsoft Windows, Mac OS X, or Linux (Ubuntu, SuSE, or Red Hat)</li>
<li>For Microsoft Windows users: Administrator access to the computer</li>
<li>An Internet browser such as Chrome, Firefox, or IE9 (previous versions of Internet Explorer are not supported)</li>
<li>An SSH client such as PuTTY</li>
</ul>
<p><strong>Duration</strong></p>

<p>This lab will require approximately <strong>90 minutes</strong> to complete.</p>

<h2 id="step1">Start the Lab</h2>
<ul>
<li>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</li>
</ul>
<h2 id="step2">Task 1: Install Inspector Agent</h2>

<p>In this section, you will SSH into the CommandHost instance and install the Inspector agent on your fleet of EC2 instances using the Systems Manager Run command. The two EC2 instances that form your fleet are tagged as <em>SecurityScan</em> to be able to identify them easily. This will enable the EC2 instances to run security assessment scans in a subsequent section.</p>
<ol start="1">
<li>Using the <strong>CommandHost</strong> IP address found at the left side of the Qwiklabs page, establish an SSH connection to the CommandHost EC2 instance.</li>
</ol>
<p>For detailed instructions to establish an SSH connection, <a href="#ssh-instructions">click here</a> to jump to the Appendix section at the end of this guide.</p>

<p><a id="ssh-after"></a></p>
<ol start="2">
<li>Run the command below to see the instances that have the Systems Manager agent running.</li>
</ol><pre class="highlight shell"><code>aws ssm describe-instance-information  --query <span class="s2">"InstanceInformationList[*]"</span>
</code><button class="button button--copy js-copy-button-0"><i class="fa fa-clipboard"></i></button></pre>
<p>From the output, you should see that there are two instances that have the Systems Manager agent running on them. Observe the agent version, platform name, platform type etc. for the Systems Manager agent.</p>
<ol start="3">
<li>Now you will review the Systems Manager document with the commands below. In the commands below, you are redirecting the output of the command, aws ssm get-document, to a flat text file then you are using the cat command to view the contents of the document.</li>
</ol><pre class="highlight plaintext"><code>aws ssm get-document --name "AmazonInspector-ManageAWSAgent" --output text &gt; AmazonInspector-ManageAWSAgent.doc
cat AmazonInspector-ManageAWSAgent.doc | less
</code><button class="button button--copy js-copy-button-1"><i class="fa fa-clipboard"></i></button></pre>
<p>You should see the JSON format of the Systems Manager document. The document is a set of instructions telling the System Manager agent what operations to perform. In this case, you are telling the Systems Manager agent to install the inspector agent on the fleet of instances using the Systems Manager Run command feature.</p>
<ol start="4">
<li><p>Pressing the <strong>SPACE</strong> to advance quickly over the document, <strong>q</strong> to exit back to your shell prompt.</p></li>
<li><p>In the left side section of the Qwiklabs page, copy the <strong>LogBucket</strong> value.</p></li>
<li><p>To execute the Systems Manager Run command to install the Inspector agent on the EC2 instances tagged as <em>SecurityScan</em>, run the command below. Replace  <strong>&lt;LoggingBucket&gt;</strong> with the value of the <strong>LogBucket</strong> you copied in the previous step.</p></li>
</ol><pre class="highlight plaintext"><code>aws ssm send-command --targets Key=tag:SecurityScan,Values=true --document-name "AmazonInspector-ManageAWSAgent"  --output-s3-bucket-name &lt;LoggingBucket&gt; --query Command.CommandId
</code><button class="button button--copy js-copy-button-2"><i class="fa fa-clipboard"></i></button></pre><ol start="7">
<li><p>Make a note of the CommandId from the output of the previous step.</p></li>
<li><p>To see the status of the <em>send-command</em> issued in the previous step, run the command below. Replace <strong>&lt;CommandId&gt;</strong> in the command below with the CommandId you noted in the previous step.</p></li>
</ol><pre class="highlight plaintext"><code>aws ssm list-command-invocations --command-id &lt;CommandId&gt; --details --query "CommandInvocations[*].[InstanceId,DocumentName,Status]"
</code><button class="button button--copy js-copy-button-3"><i class="fa fa-clipboard"></i></button></pre>
<p>Observe that the Inspector agent has been successfully installed on both the EC2 instances.</p>

<h2 id="step3">Task 2: Set up Amazon Inspector</h2>

<p>In this section, you will set up Amazon Inspector with the target assessment group to run the security assessment scans. The target group are the two EC2 instances that form your fleet tagged as <em>SecurityScan</em>, to make it easy to identify them.</p>
<ol start="9">
<li>To create a resource group to identify the EC2 instances that need to be scanned, run the command below. In the command below, you are creating a resource group for EC2 instance that have the <strong>SecurityScan</strong> tag.</li>
</ol><pre class="highlight plaintext"><code>aws inspector create-resource-group --resource-group-tags key=SecurityScan,value=true
</code><button class="button button--copy js-copy-button-4"><i class="fa fa-clipboard"></i></button></pre><ol start="10">
<li><p>Copy the value of the <strong>ResourceGroupARN</strong> from the output of the previous command.</p></li>
<li><p>Next, you will create an assessment target. Replace <strong>ResourceGroupARN</strong> in the command below, with the resource group ARN you copied in the previous step.</p></li>
</ol>
<p>Assessment target is going to identify who is included in a scan.</p>
<pre class="highlight plaintext"><code>aws inspector create-assessment-target --assessment-target-name GamesDevTargetGroup --resource-group-arn &lt;ResourceGroupARN&gt;
</code><button class="button button--copy js-copy-button-5"><i class="fa fa-clipboard"></i></button></pre><ol start="12">
<li><p>Copy the value of the <strong>assessmentTargetArn</strong> from the output of the previous command.</p></li>
<li><p>Amazon Inspector has different rules packages that can be run. These rule packages are maintained by AWS, let take a closer look.</p></li>
</ol><pre class="highlight plaintext"><code>aws inspector list-rules-packages
</code><button class="button button--copy js-copy-button-6"><i class="fa fa-clipboard"></i></button></pre>
<p>You should see an output similar to below.</p>
<pre class="highlight plaintext"><code>{
    "rulesPackageArns": [
        "arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-9hgA516p", 
        "arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-H5hpSawc", 
        "arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-JJOtZiqQ", 
        "arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-rD1z6dpl", 
        "arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-vg5GGHSD"
    ]
}
</code><button class="button button--copy js-copy-button-7"><i class="fa fa-clipboard"></i></button></pre><ol start="14">
<li><p>Make a note of the ARN of each rule package.</p></li>
<li><p>To view the description of the rules package and to understand what each package scans for, run the command below. Run the command below for each of the ARN listed in the output of the previous command. Replace <strong>RulesPackageArns</strong> in the command below with the ARN of each of the rules package.</p></li>
</ol>
<p><strong>Note</strong> You will run the command five times for each of the five rules package.</p>
<pre class="highlight plaintext"><code>aws inspector describe-rules-packages --rules-package-arns &lt;RulesPackageArns&gt; --query  rulesPackages[*].[name,description] --output text
</code><button class="button button--copy js-copy-button-8"><i class="fa fa-clipboard"></i></button></pre>
<p><strong>Important</strong> When you run the command above for each rule, make a note of the rule package ARNs for Common Vulnerabilities and Exposures, CIS Operating System Security Configuration Benchmarks, and Security Best Practices. You will run an assessment scan based on these three rules only and not the fourth rule Network Reachability, and fifth rule Runtime Behavior Analysis.</p>

<p>Each time you run the command above, you will see description of the respective rule package like below.</p>
<pre class="highlight plaintext"><code>Network Reachability These rules analyze the reachability of your instances over the network. Attacks can exploit your instances over the network by accessing services that are listening on open ports. These rules evaluate the security your host configuration in AWS to determine if it allows access to ports and services over the network. For reachable ports and services, the Amazon Inspector findings identify where they can be reached from, and provide guidance on how to restrict access to these ports.
</code><button class="button button--copy js-copy-button-9"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>Common Vulnerabilities and Exposures    The rules in this package help verify whether the EC2 instances in your application are exposed to Common Vulnerabilities and Exposures (CVEs). Attacks can exploit unpatched vulnerabilities to compromise the confidentiality, integrity, or availability of your service or data. The CVE system provides a reference for publicly known information security vulnerabilities and exposures. For more information, see [https://cve.mitre.org/](https://cve.mitre.org/). If a particular CVE appears in one of the produced Findings at the end of a completed Inspector assessment, you can search [https://cve.mitre.org/](https://cve.mitre.org/) using the CVE's ID (for example, "CVE-2009-0021") to find detailed information about this CVE, its severity, and how to mitigate it.
</code><button class="button button--copy js-copy-button-10"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>CIS Operating System Security Configuration Benchmarks  The CIS Security Benchmarks program provides well-defined, un-biased and consensus-based industry best practices to help organizations assess and improve their security.
</code><button class="button button--copy js-copy-button-11"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>Security Best Practices The rules in this package help determine whether your systems are configured securely.
</code><button class="button button--copy js-copy-button-12"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>Runtime Behavior Analysis These rules analyze the behavior of your instances during an assessment run, and provide guidance on how to make your instances more secure.
</code><button class="button button--copy js-copy-button-13"><i class="fa fa-clipboard"></i></button></pre><ol start="16">
<li>An assessment template identifies what scan should be run, the length of time to collect telemetry data, as well as the hosts to include in the scan. To create this we can use the create-assessment-template. Replace <strong>AssessmentTargetArn</strong> in the command below with the assessment target ARN you noted earlier. Replace <strong>ThreeRulesPackageARNs</strong> with the ARNs of the following three rules package - Common Vulnerabilities and Exposures, CIS Operating System Security Configuration Benchmarks, and Security Best Practices. You made a note of these ARNs in the previous step.</li>
</ol><pre class="highlight plaintext"><code>aws inspector create-assessment-template --assessment-target-arn &lt;AssessmentTargetArn&gt; --assessment-template-name CISCommonVulerBestPract-Short --duration-in-seconds 900 --rules-package-arns &lt;ThreeRulesPackageARNs&gt;
</code><button class="button button--copy js-copy-button-14"><i class="fa fa-clipboard"></i></button></pre>
<p>After replacing the placeholder variables, the command above will look like the following. Make sure the spacing in your command is as per the sample command shown below.</p>
<pre class="highlight plaintext"><code>aws inspector create-assessment-template --assessment-target-arn arn:aws:inspector:us-west-2:603498349594:target/0-saxlCled --assessment-template-name CISCommonVulerBestPract-Short --duration-in-seconds 900 --rules-package-arns arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-9hgA516p arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-H5hpSawc arn:aws:inspector:us-west-2:xxxxxxxxx:rulespackage/0-JJOtZiqQ
</code><button class="button button--copy js-copy-button-15"><i class="fa fa-clipboard"></i></button></pre><ol start="17">
<li>Make a note of the <strong>assessmentTemplateArn</strong> from the output of the previous command.</li>
</ol>
<h2 id="step4">Task 3: Start Security Assessment Scan</h2>

<p>In this section, you will start the security assessment scan that was created in the prior task. The assessment scan runs for 15 minutes and will provide you with a report of findings.</p>
<ol start="18">
<li>When we created the assessment target you defined it via tags. Lets take a look to what host this might resolve to currently in this account.  Replace <strong>AssessmentTargetArn</strong> in the command below with the value of the <strong>assessmentTargetArn</strong> you noted earlier.</li>
</ol><pre class="highlight plaintext"><code>aws inspector preview-agents --preview-agents-arn &lt;AssessmentTargetArn&gt;
</code><button class="button button--copy js-copy-button-16"><i class="fa fa-clipboard"></i></button></pre>
<p>In the JSON output, observe that two agents are reporting the telemetry data for the assessment scan.</p>
<ol start="19">
<li>To start the assessment, run the command below. Replace <strong>AssessmentTemplateArn</strong> with the <strong>assessmentTemplateArn</strong> you noted earlier. The assessment will run for 15 minutes.</li>
</ol><pre class="highlight plaintext"><code>aws inspector start-assessment-run --assessment-template-arn &lt;AssessmentTemplateArn&gt; --assessment-run-name  FirstAssessment
</code><button class="button button--copy js-copy-button-17"><i class="fa fa-clipboard"></i></button></pre><ol start="20">
<li><p>Make a note of the <strong>assessmentRunArn</strong> from the output of the previous command.</p></li>
<li><p>To check the status of the assessment, run the command below. Replace <strong>AssessmentRunArn</strong> in the command below with the <strong>assessmentRunArn</strong> you noted in the previous step.</p></li>
</ol><pre class="highlight plaintext"><code>aws inspector describe-assessment-runs --assessment-run-arn &lt;AssessmentRunArn&gt;
</code><button class="button button--copy js-copy-button-18"><i class="fa fa-clipboard"></i></button></pre>
<p>You should see the status of the assessment as <em>COLLECTING DATA</em>.</p>
<ol start="22">
<li>To view the agents that are sending telemetry data, run the command below. Replace <strong>AssessmentRunArn</strong> in the command below with the <strong>assessmentRunArn</strong> you noted in a previous step.</li>
</ol><pre class="highlight plaintext"><code>aws inspector list-assessment-run-agents --assessment-run-arn &lt;AssessmentRunArn&gt;
</code><button class="button button--copy js-copy-button-19"><i class="fa fa-clipboard"></i></button></pre>
<p>You should see the agentHealthCode, agentHealth, telemetryMetadata etc. for each running agent in the JSON output.</p>
<ol start="23">
<li><p>To the left of the instructions you are currently reading, click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Inspector</strong> to open the Amazon Inspector dashboard.</p></li>
<li><p>To right side on the Inspector dashboard, you will see a table with the list of assessment runs. Notice that the <strong>FirstAssessment</strong> run is still in the <em>Collecting data</em> status. Wait for about 15 minutes for the run to complete.</p></li>
<li><p>Once you see the status of FirstAssessment as <strong>Analysis complete</strong>, click the <strong>FirstAssessment</strong> hyperlink to open the scan details.</p></li>
<li><p>In the left side navigation menu, click <strong>Findings</strong>. You should see a list of findings.</p></li>
<li><p>Click the expander for one of the findings in the list. Observe the details of the finding.</p></li>
<li><p>Alternatively, you can download report. In the left side navigation menu, click <strong>Assessment runs</strong>. Click <strong>Download report</strong> in the last column of the table to download the scan report. You may choose to download either the full report or only the findings in HTML or PDF format.</p></li>
</ol>
<h2 id="step5">Task 4: Create and Apply a Patch Baseline</h2>

<p>Some of the issues that may have been found in the inspector scan could be solved by patching the guest OS. A patch baseline can be defined and apply it to the fleet of EC2 instances ensuring that software is kept up to date. You will use the Systems Manager Automation feature to complete this action on each of these instances.</p>
<ol start="31">
<li>To create a run document, run the command below.</li>
</ol><pre class="highlight plaintext"><code>aws ssm describe-document --name "AWS-PatchInstanceWithRollback" --query "Document.[Name,Description,PlatformTypes]"
</code><button class="button button--copy js-copy-button-20"><i class="fa fa-clipboard"></i></button></pre>
<p>Observe the description of the document. The document brings the EC2 Instance into compliance with a baseline and rolls back to root volume on failure.</p>
<ol start="32">
<li>To get the instance ids of the EC2 instance to which you will apply the patch, run the command below.</li>
</ol><pre class="highlight plaintext"><code>aws ssm describe-instance-information  --query "InstanceInformationList[*]"
</code><button class="button button--copy js-copy-button-21"><i class="fa fa-clipboard"></i></button></pre><ol start="33">
<li><p>Make a note of the instance ids from the output of the command above. The instance id is similar to  i-017aaae189d442967.</p></li>
<li><p>To start the automation document on the first instance, run the command below. Replace <strong>InstanceId</strong> with one of the instance id you noted in the previous step. Replace <strong>LogBucket</strong> with the LogBucket name found in the left side section of the Qwiklabs page.</p></li>
</ol><pre class="highlight plaintext"><code>aws ssm start-automation-execution --document-name "AWS-PatchInstanceWithRollback" --parameters "InstanceId=&lt;InstanceId&gt;,ReportS3Bucket=&lt;LogBucket&gt;"
</code><button class="button button--copy js-copy-button-22"><i class="fa fa-clipboard"></i></button></pre><ol start="35">
<li>To start the automation document on the second instance, run the command below. Replace <strong>InstanceId</strong> with the second instance id you noted in a previous step. Replace <strong>LogBucket</strong> with the LogBucket name found in the left side section of the Qwiklabs page.</li>
</ol><pre class="highlight plaintext"><code>aws ssm start-automation-execution --document-name "AWS-PatchInstanceWithRollback" --parameters "InstanceId=&lt;InstanceId&gt;,ReportS3Bucket=&lt;LogBucket&gt;"
</code><button class="button button--copy js-copy-button-23"><i class="fa fa-clipboard"></i></button></pre><ol start="36">
<li><p>The patching of the EC2 instances will take about 10 minutes for each instance. You can view the status of the automation execution in the Systems Manager dashboard in the console.</p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Systems Manager</strong> to open the AWS Systems Manager dashboard.</p></li>
<li><p>In the left side navigation menu, under <strong>Actions</strong>, click <strong>Automation</strong>.</p></li>
<li><p>You should see the two automations running and their corresponding status as <em>In Progress</em>. After about 10 minutes, the status should change to <em>Success</em>. You may have to refresh the page to see the updated status.</p></li>
<li><p>Click the hyperlink for <strong>Execution ID</strong> to view more details of each execution. You should see a list of 10 executed steps. You may click on the hyperlink for each <strong>Step ID</strong> to view details of each step. You may also check the logs which get reported to the Amazon S3 bucket, LogBucket, found to the left of these instructions on the Qwiklabs page. In the S3 bucket, you should see a folder called <em>AWSLogs</em>. Keep clicking the sub folders until you reach the lowest level in the hierarchy and see two files with names similar to:  PatchInstanceWithRollback-34f19ae2-7902-4a5d-bcaf-cc99055e5f88.json. Download the log files and observe the contents of the log files. They should have information about the patch installations.</p></li>
</ol>
<h2 id="step6">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>



<p><a id="ssh-instructions"></a></p>

<h2 id="step7">Appendix</h2>

<p>Access to a Linux EC2 instance requires a secure connection using an SSH client. The following directions walk you through the process of connecting to your Amazon Linux EC2 instance.</p>

<h3>
<i class="fab fa-windows"></i> Windows Users: Using SSH to connect</h3>

<p><i class="fas fa-comment"></i> These instructions are for Windows users only.</p>

<p>If you are using Mac or Linux, <a href="#ssh-MACLinux">skip to the next section</a>.</p>
<ol start="41">
<li><p>To the left of the instructions you are currently reading, click <span style="color:blue;"><i class="fas fa-download"></i></span> <strong>Download PPK</strong>.</p></li>
<li><p>Save the file to the directory of your choice.</p></li>
</ol>
<p>You will use PuTTY to SSH to Amazon EC2 instances.</p>

<p>If you do not have PuTTY installed on your computer, <a href="https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe">download it here</a>.</p>
<ol start="43">
<li><p>Open PuTTY.exe</p></li>
<li><p>Configure the PuTTY to not timeout:</p></li>
</ol><ul>
<li>Click <strong>Connection</strong>
</li>
<li>Set <strong>Seconds between keepalives</strong> to <input readonly="" class="copyable-inline-input" size="2" type="text" value="30">
</li>
</ul>
<p>This allows you to keep the PuTTY session open for a longer period of time.</p>
<ol start="45">
<li>Configure your PuTTY session:</li>
</ol><ul>
<li>Click <strong>Session</strong>.</li>
<li>
<strong>Host Name (or IP address):</strong> Copy and paste the value of <strong>CommandHost</strong> shown to the left of these instructions.</li>
<li>In the <strong>Connection</strong> list, expand <i class="far fa-plus-square"></i> <strong>SSH</strong>.</li>
<li>Click <strong>Auth</strong> (don't expand it).</li>
<li>Click <strong>Browse</strong>.</li>
<li>Browse to and select the PPK file that you downloaded.</li>
<li>Click <strong>Open</strong> to select it.</li>
<li>Click <strong>Open</strong>.</li>
</ul><ol start="46">
<li><p>Click <strong>Yes</strong>, to trust the host and connect to it.</p></li>
<li><p>When prompted <strong>login as</strong>, enter: <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user"></p></li>
</ol>
<p>This will connect to your EC2 instance.</p>
<ol start="48">
<li><a href="#ssh-after">Windows Users: Click here to go back to the next step in task 1.</a></li>
</ol>
<p><a id="ssh-MACLinux"></a></p>

<h3>Mac <i class="fab fa-apple"></i> and Linux <i class="fab fa-linux"></i> Users</h3>

<p>These instructions are for Mac/Linux users only. If you are a Windows user and have already established an SSH connection, <a href="#ssh-after">click here to go back to the next step in task 1.</a></p>
<ol start="49">
<li><p>To the left of the instructions you are currently reading, click <span style="color:blue;"><i class="fas fa-download"></i></span> <strong>Download PEM</strong>.</p></li>
<li><p>Save the file to the directory of your choice.</p></li>
<li><p>Copy this command to a text editor:</p></li>
</ol><pre class="highlight plaintext"><code>chmod 400 KEYPAIR.pem

ssh -i KEYPAIR.pem ec2-user@PublicIP
</code><button class="button button--copy js-copy-button-24"><i class="fa fa-clipboard"></i></button></pre><ol start="52">
<li><p>Replace <em>KEYPAIR.pem</em> with the path to the PEM file you downloaded.</p></li>
<li><p>Replace <em>PublicIP</em> with the value of CommandHost shown to the left side of these instructions.</p></li>
<li><p>Paste the updated command into the terminal window and run it.</p></li>
<li><p>Type <input readonly="" class="copyable-inline-input" size="3" type="text" value="yes"> when prompted to allow a first connection to this remote SSH server.</p></li>
</ol>
<p>Because you are using a key pair for authentication, you will not be prompted for a password.</p>

<p><a href="#ssh-after">Click here to go back to the next step in task 1.</a></p>

</div>