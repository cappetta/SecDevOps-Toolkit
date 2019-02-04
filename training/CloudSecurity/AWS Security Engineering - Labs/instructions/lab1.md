<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 1 - Cross-Account Authentication</h1>

<p><strong>Overview</strong></p>

<p>This lab will demonstrate how to delegate access to resources that are in different AWS accounts. In this way, you can share resources in one account with users in a different account. There is no need to create individual IAM users in each account, nor will users have to sign out of one account and sign into another. This could be a great way to help manage a small team of people who would need access to a small number of accounts. The concepts introduced in this lab act as a starting point for managing cross account access, and can be extended to decrease operational overhead as the number of users and accounts grow with the addition of federation.</p>

<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Create IAM roles that allow you to delegate access across AWS Accounts</li>
<li>Switch between roles using either the AWS console or the AWS CLI in order to access resources within a different AWS account</li>
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

<p>This lab will take approximately 30 minutes to complete.</p>



<h2 id="step1">Accessing the AWS Management Console</h2>
<ul>
<li><p>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</p></li>
<li><p>Click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
</ul>
<p><i class="fas fa-exclamation-triangle"></i> Please do not change the Region during this lab.</p>

<h2 id="step2">Before you begin</h2>

<p>In order to complete this lab, you will need access to two AWS accounts. The easiest way to accomplish this is to partner up with another student. You and your partner will be completing the following steps simultaneously, each in your own account. So, take a minute to find a person near you to work with throughout this lab.</p>

<h2 id="step3">Task 1: Create a cross-account role</h2>

<p>First, you will use the AWS Management Console to establish trust with your partner's account. You do this by creating an IAM role and specifying a permissions policy that allows trusted users to access your account.</p>
<ol start="1">
<li>
<p>Exchange <strong>account numbers</strong> with your partner.</p>

<p><strong>Note:</strong> You and your partner must be using different account numbers, otherwise you will not be able to successfully complete this lab. If you happen to pick a partner with the same account number, you will need to find another partner.</p>
</li>
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Roles</strong>.</p></li>
<li><p>Click the <strong>Create role</strong> button.</p></li>
<li><p>In the <strong>Select type of trusted entity</strong> section, click on <strong>Another AWS account</strong>.</p></li>
<li><p>In the <strong>Specify accounts that can use this role</strong> section, enter your partner's account number for <strong>Account ID</strong>.</p></li>
<li><p>Click on the <strong>Next: Permissions</strong> button.</p></li>
<li>
<p>In the <strong>Attach permissions policies</strong> section, select the <input readonly="" class="copyable-inline-input" size="13" type="text" value="SecurityAudit"> policy.</p>

<p><strong>Note:</strong> You may want to use the filter option to search for <input readonly="" class="copyable-inline-input" size="13" type="text" value="SecurityAudit"> in order to quickly locate the policy.</p>
</li>
<li><p>Take a moment to view the SecurityAudit policy. What are the allowed actions that this policy facilitates? Discuss this with your lab partner if possible.</p></li>
<li><p>Click on the <strong>Next: Tags</strong> button.</p></li>
<li><p>Click on the <strong>Next: Review</strong> button.</p></li>
<li><p>In the <strong>Review</strong> section, enter <input readonly="" class="copyable-inline-input" size="19" type="text" value="RemoteSecurityAudit"> for <strong>Role name</strong>.</p></li>
<li><p>Click on the <strong>Create role</strong> button.</p></li>
<li>
<p>Once the role <strong>RemoteSecurityAudit</strong> has been created, click on it to view it's details.</p>

<p><strong>Note:</strong> You may want to use the filter option to search for <input readonly="" class="copyable-inline-input" size="19" type="text" value="RemoteSecurityAudit"> in order to quickly locate the role.</p>
</li>
<li>
<p>In the <strong>Summary</strong> section, click on the <strong>Trust relationships</strong> tab.</p>

<p>Observe that your partner's account is a trusted entity. Only a trusted account will be allowed to assume this role.</p>
</li>
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Instances</strong>.</p></li>
<li>
<p>Edit the name of the <strong>JumpServer</strong> instance by hovering your mouse cursor over the name and clicking on the pencil icon that appears.</p>

<p>Change the name of your instance to be <input readonly="" class="copyable-inline-input" size="20" type="text" value="JumpServer-YOUR_NAME"> where you replace <input readonly="" class="copyable-inline-input" size="9" type="text" value="YOUR_NAME"> with your first name. You will use this custom-named server later to prove that you have successfully switched accounts.</p>

<p>Wait for your partner to finish Task 1 before proceeding to Task 2.</p>
</li>
</ol>
<h2 id="step4">Task 2: Assume the role from the console</h2>

<p>Now that you and your partner have created cross-account roles, it is time to test them out. In this task, you will use the AWS Management console to sign into each other's account.</p>
<ol start="19">
<li><p>In the AWS Management Console, click on your login name (awsstudent) in the title bar and click <strong>Switch Role</strong>.</p></li>
<li><p>In the <strong>Account</strong> field, enter your partner's account number.</p></li>
<li><p>In the <strong>Role</strong> field, enter <input readonly="" class="copyable-inline-input" size="19" type="text" value="RemoteSecurityAudit"></p></li>
<li>
<p>Click the <strong>Switch Role</strong> button.</p>

<p>You have now switched roles. Instead of seeing <strong>awsstudent</strong> in the title bar, you should see <strong>RemoteSecurityAudit</strong> instead.</p>
</li>
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li>
<p>In the navigation pane, click <strong>Instances</strong>.</p>

<p>You should see the <strong>JumpServer</strong> instance, but this time it should have your partner's name instead of your own.</p>

<p>Go ahead and navigate around in your partner's account if you wish. The role you are using is limited to read-only access, so attempting to create or change anything should result in an authentication error.</p>

<p>Once you are done exploring, it is time to switch back to your original account.</p>
</li>
<li>
<p>In the AWS Management Console, click on your login name (RemoteSecurityAudit) in the title bar and click <strong>Back to awsstudent</strong>.</p>

<p>Wait for your partner to finish Task 2 before proceeding to Task 3.</p>

<p>So now you can access another AWS account by using the management console. But what if you need cross-account access for an automated task? For the next task, you will learn how to access your partner's account using the AWS CLI.</p>
</li>
</ol>
<h2 id="step5">Task 3: Create a policy to allow switching roles</h2>

<p>Lets explore another way to access a second account. AWS resources like EC2 instances are able to assume a role as well. The instance will handle the key rotation several times per day. To setup this up, you are going to create another IAM policy, and attach that to a new role with a trust policy to the EC2 service.</p>
<ol start="26">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Policies</strong>.</p></li>
<li><p>Click the <strong>Create policy</strong> button.</p></li>
<li>
<p>In the <strong>Create policy</strong> section, click on the JSON tab and paste the following policy into the box:</p>

<p><strong>Note:</strong> Make sure to either delete or to overwrite the default generated empty policy.</p>
</li>
</ol><pre class="highlight plaintext"><code>{
            "Version": "2012-10-17",
            "Statement": [{
                    "Sid": "VisualEditor0",
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Resource": "arn:aws:iam::*:role/RemoteSecurityAudit"
                }
            ]
}
</code><button class="button button--copy js-copy-button-0"><i class="fa fa-clipboard"></i></button></pre>
<p>This policy will allow for the EC2 instance to assume the role RemoteSecurityAudit in any account. If you changed the *
to the account number of your partners lab account, you could further scope down this permissions.</p>
<ol start="30">
<li><p>Click the <strong>Review policy</strong> button.</p></li>
<li><p>On the <strong>Create policy</strong> page, in the <strong>Name</strong> field enter <input readonly="" class="copyable-inline-input" size="19" type="text" value="CLIAssumeRolePolicy"></p></li>
<li><p>Click the <strong>Create policy</strong> button.</p></li>
</ol>
<h2 id="step6">Task 4: Create a role for your EC2 instance</h2>

<p>You are now going to create the role, and attach the policy you created in the last task.</p>
<ol start="33">
<li><p>In the navigation pane, click <strong>Roles</strong>.</p></li>
<li><p>Click the <strong>Create role</strong> button.</p></li>
<li><p>In the <strong>Choose the service that will use this role</strong> section, click on <strong>EC2</strong>.</p></li>
<li><p>Click on the <strong>Next: Permissions</strong> button.</p></li>
<li>
<p>In the <strong>Attach permissions policies</strong> section, select the <input readonly="" class="copyable-inline-input" size="19" type="text" value="CLIAssumeRolePolicy"> policy.</p>

<p><strong>Note:</strong> You may want to use the filter option to search for <input readonly="" class="copyable-inline-input" size="19" type="text" value="CLIAssumeRolePolicy"> in order to quickly locate the role.</p>
</li>
<li><p>Click on the <strong>Next: Tags</strong> button.</p></li>
<li><p>Click on the <strong>Next: Review</strong> button.</p></li>
<li><p>In the <strong>Review</strong> section, for <strong>Role name</strong> enter <input readonly="" class="copyable-inline-input" size="13" type="text" value="CLIAssumeRole"></p></li>
<li><p>Click on the <strong>Create role</strong> button.</p></li>
</ol>
<h2 id="step7">Task 5: Attach the new role to your EC2 instance</h2>

<p>Now that the role is established and the EC2 service has access you can associate the role with individual instances.</p>
<ol start="42">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Instances</strong>.</p></li>
<li><p>Select the <strong>JumpServer</strong> EC2 instance, and click on <strong>Actions</strong>.</p></li>
<li><p>Under the <strong>Instance Settings</strong> category, click on <strong>Attach/Replace IAM Role</strong>.</p></li>
<li><p>In the <strong>Attach/Replace IAM Role</strong> section, for <strong>IAM role</strong> select <input readonly="" class="copyable-inline-input" size="13" type="text" value="CLIAssumeRole"></p></li>
<li><p>Click on the <strong>Apply</strong> button.</p></li>
<li>
<p>Click on the <strong>Close</strong> button.</p>

<p>Now that our <strong>JumpServer</strong> is configured to access the role that grants it access to <em>STS:AssumeRole</em>, you need to update the trust policy for the role in your partner's account.</p>

<p><strong>Important</strong> Your partner must have finished this step before you can proceed to the next step. If they have not associated their Jumphost with the role you will get an access denied error in later steps.</p>
</li>
<li><p>Navigate back to the IAM Service in the management console</p></li>
<li><p>In the navigation pane, click <strong>Roles</strong>.</p></li>
<li>
<p>Click on <strong>RemoteSecurityAudit</strong> to view the details of the role.</p>

<p><strong>Note:</strong> You may want to use the filter option to search for <input readonly="" class="copyable-inline-input" size="19" type="text" value="RemoteSecurityAudit"> in order to quickly locate the role.</p>
</li>
<li>
<p>In the <strong>Summary</strong> section, click on the <strong>Trust relationships</strong> tab.</p>

<p>Observe that your partner's account is a trusted entity. Lets update the trust policy to scope down access a little more then just to any one in the account.</p>
</li>
<li><p>Click on the <strong>Edit trust relationship</strong> button.</p></li>
<li><p>In the editor, update the json to look like this, replacing <input readonly="" class="copyable-inline-input" size="19" type="text" value="PARTNER_INSTANCE_ID"> and <input readonly="" class="copyable-inline-input" size="22" type="text" value="PARTNER_ACCOUNT_NUMBER"> where appropriate. This policy will allow a single instance to assume this role. <input readonly="" class="copyable-inline-input" size="19" type="text" value="PARTNER_INSTANCE_ID"> is the EC2 instance ID of JumpServer in your partners account, not the one that is running in your account.</p></li>
</ol><pre class="highlight plaintext"><code>{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": [
                    "arn:aws:sts::PARTNER_ACCOUNT_NUMBER:assumed-role/CLIAssumeRole/PARTNER_INSTANCE_ID",
                    "arn:aws:iam::PARTNER_ACCOUNT_NUMBER:root"
                    ]
                },
                "Action": "sts:AssumeRole"
            }
        ]
}
</code><button class="button button--copy js-copy-button-1"><i class="fa fa-clipboard"></i></button></pre><ol start="55">
<li>Click the <strong>Update Trust Policy</strong> button.</li>
</ol>
<h2 id="step8">Task 6: Connect to your Amazon Linux EC2 Instance</h2>

<p>You have now attached the role to your instance, this will grant the role permissions to any shell user or program running on that host. In this task, you will run a remote shell and execute AWS CLI commands against your partners account.</p>
<ol start="56">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click on <strong>Instances</strong>.</p></li>
<li>
<p>From the list of EC2 Instances, select <strong>JumpServer</strong> and note the <strong>Public DNS (IPv4)</strong> address. The Public DNS is available in the bottom pane.</p>

<p>Access to a Linux EC2 instance requires a secure connection using an SSH client. The following directions walk you through the process of connecting to your Amazon Linux EC2 instance.</p>

<p>Choose one of the following guides:</p>
</li>
</ol><pre class="highlight plaintext"><code>- Connecting from a Windows Machine
- Connecting from a macOS or Linux Machine
</code><button class="button button--copy js-copy-button-2"><i class="fa fa-clipboard"></i></button></pre>
<h3>Connecting from a Windows Machine</h3>

<p><strong>Note:</strong> Only perform the following steps if you are connecting from a Windows machine, otherwise skip ahead to "Connecting from a macOS or Linux Machine".</p>
<ol start="59">
<li><p>To the left of the instructions you are currently reading, click <i class="fas fa-download"></i> <strong>Download PPK</strong>.</p></li>
<li><p>If it is not already installed, download the <em>PuTTY.exe</em> client to a folder of your choice from the following URL: <a href="http://www.chiark.greenend.org.uk/%7Esgtatham/putty/download.html" target="_blank"><input readonly="" class="copyable-inline-input" size="63" type="text" value="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html"></a></p></li>
<li><p>Open <em>PuTTY.exe</em>.</p></li>
<li>
<p>In the <strong>Basic options for your PuTTY Session</strong> pane, for <strong>Host Name (or IP address)</strong>, type <input readonly="" class="copyable-inline-input" size="19" type="text" value="ec2-user@PUBLIC_DNS">, where <input readonly="" class="copyable-inline-input" size="10" type="text" value="PUBLIC_DNS"> is the Public DNS address of your Amazon EC2 instance that you copied earlier.</p>

<p>This will log you in to the remote server as the user <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user">, which is the default user on Amazon Linux on EC2.</p>
</li>
<li><p>In the navigation pane, click <strong>Connection</strong>.</p></li>
<li><p>Set the following options to keep your SSH connection active as you complete the lab:</p></li>
</ol><ul>
<li>For <strong>Seconds between keepalives (0 to turn off)</strong>, <strong>set the value</strong> to <input readonly="" class="copyable-inline-input" size="2" type="text" value="50">
</li>
<li>For <strong>Enable TCP keepalives (SO_KEEPALIVE option)</strong>, enable the checkbox.</li>
</ul><ol start="65">
<li><p>In the navigation pane, click <strong>Connection</strong> -&gt; <strong>SSH</strong> -&gt; <strong>Auth</strong>.</p></li>
<li><p>For <strong>Private key file for authentication</strong>, click <strong>Browse</strong>.</p></li>
<li>
<p>Select the PPK file you downloaded earlier and click <strong>Open</strong>.</p>

<p>This file is usually located in the <em>Downloads</em> folder on your PC.</p>
</li>
<li><p>Click <strong>Open</strong> to initiate the remote session.</p></li>
<li><p>PuTTY will ask whether you wish to cache the server's host key. Click <strong>Yes</strong>.</p></li>
</ol>
<p><strong>Result</strong></p>

<p>You are now connected to the <strong>JumpServer</strong>. When lab instructions in subsequent sections require a command window, continue using your SSH terminal window.</p>

<h3>Connecting from a macOS or Linux Machine</h3>

<p><strong>Note:</strong> Only perform the following steps if you are connecting from a macOS or Linux machine, otherwise skip ahead to the next task.</p>
<ol start="70">
<li><p>To the left of the instructions you are currently reading, click <i class="fas fa-download"></i> <strong>Download PEM</strong>.</p></li>
<li>
<p>Open the <strong>Terminal</strong> application.</p>

<p>Complete the remaining connection steps in the terminal window.</p>
</li>
<li><p>Change directory to the folder where the PEM file has been downloaded (i.e. <input readonly="" class="copyable-inline-input" size="14" type="text" value="cd ~/Downloads">).</p></li>
<li>
<p>Change the permissions on the PEM file using the command below.</p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="8" type="text" value="PEM_FILE"> with the name of the PEM file you downloaded.</p>
</li>
</ol><pre class="highlight plaintext"><code>chmod 400 PEM_FILE
</code><button class="button button--copy js-copy-button-3"><i class="fa fa-clipboard"></i></button></pre><ol start="74">
<li>
<p>Use the command below to log in to the remote instance as user <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user"></p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="8" type="text" value="PEM_FILE"> with the name of the PEM file you downloaded and <strong>replace</strong> <input readonly="" class="copyable-inline-input" size="10" type="text" value="PUBLIC_DNS"> with the Public DNS address of your EC2 instance.</p>
</li>
</ol><pre class="highlight plaintext"><code>ssh -i PEM_FILE ec2-user@PUBLIC_DNS
</code><button class="button button--copy js-copy-button-4"><i class="fa fa-clipboard"></i></button></pre>
<p>Upon prompt enter <em>yes</em></p>

<p><strong>Result</strong></p>

<p>You are now connected to the <strong>JumpServer</strong>. When lab instructions in subsequent sections require a command window, continue using your SSH terminal window.</p>

<h2 id="step9">Task 7: Connect to your partner's account using AWS CLI</h2>
<ol start="75">
<li>In order to configure the AWS CLI tool, run the following in your command window:</li>
</ol><pre class="highlight plaintext"><code>aws configure
</code><button class="button button--copy js-copy-button-5"><i class="fa fa-clipboard"></i></button></pre><ol start="76">
<li>Enter the following information:</li>
</ol><ul>
<li>
<strong>AWS Access Key ID:</strong> Press Enter</li>
<li>
<strong>AWS Secret Access Key:</strong> Press Enter</li>
<li>
<strong>Default region name:</strong> Enter the <strong>DefaultRegionName</strong> shown to the left of the             instructions you are currently reading</li>
<li>
<p><strong>Default output format:</strong> Press Enter</p>

<p>By not typing in a Access Key ID or a Secret Access Key, the EC2 Instance will look to the IAM role that you assigned to the EC2 instance back in Task 5. Remember that this policy was only allowing <em>STS:AssumeRole</em>.</p>
</li>
</ul><ol start="77">
<li>
<p>Use this command to assume the role your partner prepared for you in their account:</p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="22" type="text" value="PARTNER_ACCOUNT_NUMBER"> with your partner's account number before running the command.</p>
</li>
</ol><pre class="highlight plaintext"><code>aws sts assume-role --role-arn arn:aws:iam::PARTNER_ACCOUNT_NUMBER:role/RemoteSecurityAudit --role-session-name RemoteSecurityAudit
</code><button class="button button--copy js-copy-button-6"><i class="fa fa-clipboard"></i></button></pre>
<p><strong>Note:</strong> The command will produce temporary credentials (an Access Key, Secret Access Key, and Session Token) that can be used to access your partner's account.</p>

<p>You then set the shell user environment variables the temporary credential of your partner account. The CLI will select environmental variables over instance profile.</p>
<ol start="78">
<li>
<p>Set the relevant AWS environment variables to point to the credentials that’ll give you access to the other account:</p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="13" type="text" value="ACCESS_KEY_ID">, <input readonly="" class="copyable-inline-input" size="19" type="text" value="SECURITY_ACCESS_KEY"> and <input readonly="" class="copyable-inline-input" size="13" type="text" value="SESSION_TOKEN"> with the values provided from the previous step before running the commands.</p>
</li>
</ol><pre class="highlight plaintext"><code>export AWS_ACCESS_KEY_ID=ACCESS_KEY_ID
</code><button class="button button--copy js-copy-button-7"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>export AWS_SECRET_ACCESS_KEY=SECURITY_ACCESS_KEY
</code><button class="button button--copy js-copy-button-8"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>export AWS_SESSION_TOKEN=SESSION_TOKEN
</code><button class="button button--copy js-copy-button-9"><i class="fa fa-clipboard"></i></button></pre><ol start="79">
<li>Display the list of EC2 instances in the other account using this command:</li>
</ol><pre class="highlight plaintext"><code>aws ec2 describe-instances --output table --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value,InstanceId,InstanceType]'
</code><button class="button button--copy js-copy-button-10"><i class="fa fa-clipboard"></i></button></pre>
<p>The instance name should contain your partner's name. If you see the correct name, then your CLI command is returning results from the other account and your cross-account role is working!</p>



<h2 id="step10">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>

</div>