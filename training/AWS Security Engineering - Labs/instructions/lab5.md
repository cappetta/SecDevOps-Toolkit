<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 5 - Monitor and Respond with AWS Config</h1>

<p><strong>Overview</strong></p>

<p>In this lab you will setup AWS Config to monitor your Amazon S3 buckets for security violations. The company you are working for wants to ensure that no S3 buckets are publicly readable. Using CloudWatch events for the near real-time response, and to call a Lambda function if the event from Config contains a noncompliant resource.</p>

<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Setup AWS Config to monitor Amazon S3 bucket ACLs and policies for compliance violations</li>
<li>Create and configure a CloudWatch Events rule that is triggered by AWS Config and subsequently triggers a Lambda function</li>
<li>Explain how a Lambda function can be used to correct S3 bucket ACLs policies and notify your team of out-of-compliance policies</li>
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



<h2 id="step1">Before you begin</h2>

<p>Take a minute to sketch out a basic overview of what this solution’s architecture looks like. How will the services mentioned in the objectives and overview above interact to help monitor and secure your S3 buckets? You can do this with a pen and paper or on the classroom’s whiteboard. Refer back to the Module 6 slides before you proceed just to make sure your architecture is accurate.</p>

<h2 id="step2">Accessing the AWS Management Console</h2>
<ul>
<li><p>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</p></li>
<li><p>Click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
</ul>
<p><i class="fas fa-exclamation-triangle"></i> Please do not change the Region during this lab.</p>

<h2 id="step3">Reviewing your Amazon S3 access policies</h2>
<ol start="1">
<li>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>S3</strong>.</li>
</ol>
<p>You should see several Amazon S3 buckets already created for you. One bucket will be named something like <strong>privatebucket-XXXXXXXXXXXX</strong> and another bucket will be named <strong>publicbucket-XXXXXXXXXXXX</strong>. There might be other buckets as well, but these are the two you will be working with.</p>

<p>As its name implies, the <strong>publicbucket</strong> is supposed to be accessible to the general public, and it has a custom bucket tag <strong>CanBePublic</strong> set to <strong>1</strong>. The <strong>privatebucket</strong> is not supposed to have any public access, and it has a custom tag <strong>CanBePublic</strong> set to <strong>0</strong>. However, if you look under the <strong>Access</strong> column on this screen, you will see that both buckets are open to the public.</p>

<p>Your task in this lab is to build a solution that can correct these violations, as well as create a notification whenever this problem occurs. To do this, you will configure AWS Config to trigger an Amazon CloudWatch Event rule to trigger an AWS Lambda function.</p>

<h2 id="step4">Task 1: Connect to your Amazon Linux EC2 Instance</h2>

<p>In this section, you will sign in to an Amazon EC2 work instance, so that you can use the AWS Command Line Interface (CLI).</p>
<ol start="2">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Instances</strong>.</p></li>
<li><p>From the list of EC2 Instances, select <strong>Command Host</strong> and note the <strong>Public DNS (IPv4)</strong> address. The Public DNS is available in the bottom pane.</p></li>
<li><p>Establish an SSH Connection to <strong>Command Host</strong>.</p></li>
</ol>
<p>For detailed directions, scroll down to <strong>Connecting to your Amazon Linux EC2 Instance</strong> in the Appendix at the end of this guide.</p>

<h2 id="step5">Task 2: Enable AWS Config to monitor your S3 buckets</h2>
<ol start="6">
<li>First, you will need to create a configuration recorder, which is necessary to detect changes in your resource configurations and to capture these changes as configuration items. You must create a configuration recorder before AWS Config can track your resource configurations. In this lab you are only monitoring S3 buckets so you are able to scope down the resource that AWS Config is going to be monitoring for changes.</li>
</ol>
<p>Run the following command:</p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="17" type="text" value="<config-role-arn>"> with the value provided on the <strong>Connection Details</strong> section in Qwiklabs before running the command.</p>
<pre class="highlight plaintext"><code>aws configservice put-configuration-recorder --recording-group allSupported=false,includeGlobalResourceTypes=false,resourceTypes=AWS::S3::Bucket --configuration-recorder name=default,roleARN=&lt;config-role-arn&gt;
</code><button class="button button--copy js-copy-button-0"><i class="fa fa-clipboard"></i></button></pre><ol start="7">
<li>Next, create the delivery channel by running the below command. AWS Config sends notifications and updated configuration states through the delivery channel. You can manage the delivery channel to control where AWS Config sends configuration updates.In this case, you will be sending notifications to Amazon Simple Notification Service (SNS) which could be used to inform an admin via email that a bucket is out of compliance.</li>
</ol>
<p>Run the following command:</p>

<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="22" type="text" value="<config-s3-bucketname>"> and <input readonly="" class="copyable-inline-input" size="18" type="text" value="<config-sns-topic>"> with the values provided on the <strong>Connection Details</strong> section in Qwiklabs before running the command.</p>
<pre class="highlight plaintext"><code>aws configservice put-delivery-channel --delivery-channel configSnapshotDeliveryProperties={deliveryFrequency=Twelve_Hours},name=default,s3BucketName=&lt;config-s3-bucketname&gt;,snsTopicARN=&lt;config-sns-topic&gt;
</code><button class="button button--copy js-copy-button-1"><i class="fa fa-clipboard"></i></button></pre><ol start="8">
<li>Finally, start the configuration recorder by running the following command:</li>
</ol><pre class="highlight plaintext"><code>aws configservice start-configuration-recorder --configuration-recorder-name default
</code><button class="button button--copy js-copy-button-2"><i class="fa fa-clipboard"></i></button></pre>
<h2 id="step6">Task 3: Create and configure CloudWatch Events rules</h2>

<p>AWS Config will now be monitoring resources in this account, and will record if a change has been applied to them. You then want to ensure that those changes are inline with the company policy you are trying to enforce, and if not correct the policy to ensure compliance. Config will send a message to CloudWatch Events letting us know that there is a resource that is not compliant with our rule. You will create 2 rules, one to block public read access <strong>S3ProhibitPublicReadAccess</strong> and and the other to block public write access <strong>S3ProhibitPublicWriteAccess</strong>.</p>
<ol start="9">
<li>Create and open a new file named <input readonly="" class="copyable-inline-input" size="31" type="text" value="S3ProhibitPublicReadAccess.json"> using the following command:</li>
</ol><pre class="highlight plaintext"><code>nano S3ProhibitPublicReadAccess.json
</code><button class="button button--copy js-copy-button-3"><i class="fa fa-clipboard"></i></button></pre><ol start="10">
<li>You need to define a document that will identify which resource changes will trigger a Config rule. In our case it can be limited to just an S3 Bucket. You also need to call out the rule to make the evaluation if this is set up correctly according to our policy. In this case you will be using a rule that AWS have authored. Copy and paste the following configuration as the new contents of the file:</li>
</ol><pre class="highlight plaintext"><code>{
  "ConfigRuleName": "S3PublicReadProhibited",
  "Description": "Checks that your S3 buckets do not allow public read access. If an S3 bucket policy or bucket ACL allows public read access, the bucket is noncompliant.",
  "Scope": {
    "ComplianceResourceTypes": [
      "AWS::S3::Bucket"
    ]
  },
  "Source": {
    "Owner": "AWS",
    "SourceIdentifier": "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}
</code><button class="button button--copy js-copy-button-4"><i class="fa fa-clipboard"></i></button></pre><ol start="11">
<li><p>Save the file (press CTRL+O and then ENTER) and then exit the editor (press CTRL+X).</p></li>
<li><p>Create and open a new file named <input readonly="" class="copyable-inline-input" size="32" type="text" value="S3ProhibitPublicWriteAccess.json"> using the following command:</p></li>
</ol><pre class="highlight plaintext"><code>nano S3ProhibitPublicWriteAccess.json
</code><button class="button button--copy js-copy-button-5"><i class="fa fa-clipboard"></i></button></pre><ol start="13">
<li>Copy and paste the following configuration as the new contents of the file:</li>
</ol><pre class="highlight plaintext"><code>{
  "ConfigRuleName": "S3PublicWriteProhibited",
  "Description": "Checks that your S3 buckets do not allow public write access. If an S3 bucket policy or bucket ACL allows public write access, the bucket is noncompliant.",
  "Scope": {
    "ComplianceResourceTypes": [
      "AWS::S3::Bucket"
    ]
  },
  "Source": {
    "Owner": "AWS",
    "SourceIdentifier": "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
}
</code><button class="button button--copy js-copy-button-6"><i class="fa fa-clipboard"></i></button></pre><ol start="14">
<li><p>Save the file (press CTRL+O and then ENTER) and then exit the editor (press CTRL+X).</p></li>
<li><p>You can add your two new Config Rules to AWS Config by running the following commands:</p></li>
</ol><pre class="highlight plaintext"><code>aws configservice put-config-rule --config-rule file://S3ProhibitPublicReadAccess.json
</code><button class="button button--copy js-copy-button-7"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>aws configservice put-config-rule --config-rule file://S3ProhibitPublicWriteAccess.json
</code><button class="button button--copy js-copy-button-8"><i class="fa fa-clipboard"></i></button></pre><ol start="16">
<li><p>Go back to the AWS Management Console, and in the <strong>Services</strong> menu, click <strong>Config</strong>.</p></li>
<li><p>In the navigation pane, click on <strong>Rules</strong>.</p></li>
</ol>
<p>You should see the rules you just created: <strong>S3PublicReadProhibited</strong> and <strong>S3PublicWriteProhibited</strong>.</p>

<h2 id="step7">Task 4: Create a Lambda function</h2>

<p>Now that you have built the rules, you will need to create a Lambda function to do the actual work of fixing the issues and reporting any problems to SNS.</p>
<ol start="18">
<li>Using your command window, review the contents of the file <input readonly="" class="copyable-inline-input" size="18" type="text" value="lambda_function.py">.</li>
</ol>
<p>This Python code will be used for creating your new Lambda function.This Lambda function will scan all your buckets and look for the custom tag <strong>CanBePublic</strong>. If any bucket is assigned public access and does not have the tag <strong>CanBePublic</strong> set to <strong>1</strong>, the Lambda function will treat it as a policy violation. When this happens it will set the bucket ACL to private and send a message to SNS.</p>
<ol start="19">
<li>Once you have finished reviewing the code, create a zip file from the Python code by running the following:</li>
</ol><pre class="highlight plaintext"><code>zip lambda_function.zip lambda_function.py
</code><button class="button button--copy js-copy-button-9"><i class="fa fa-clipboard"></i></button></pre><ol start="20">
<li>The Lambda function is going to need to assume a role in our account to be able to describe the S3 buckets, and look at the policies and tags that are applied. The lab environment has created a role with the correct permissions and trusting policy for this function.</li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="17" type="text" value="<lambda-role-arn>"> and <input readonly="" class="copyable-inline-input" size="18" type="text" value="<config-sns-topic>"> with the value provided on the <strong>Connection Details</strong> section in Qwiklabs before running the command.</p>
<pre class="highlight plaintext"><code>aws lambda create-function --function-name RemoveS3PublicAccessDemo --runtime "python3.6" --handler lambda_function.lambda_handler --zip-file fileb://lambda_function.zip --environment Variables={TOPIC_ARN=&lt;config-sns-topic&gt;} --role &lt;lambda-role-arn&gt;
</code><button class="button button--copy js-copy-button-10"><i class="fa fa-clipboard"></i></button></pre><ol start="21">
<li><p>Once it is created, you will get a JSON response on the screen. Copy down the value returned for <strong>FunctionArn</strong>, as you will need this later.</p></li>
<li><p>Go back to the AWS Management Console, and in the <strong>Services</strong> menu, click <strong>Lambda</strong>.</p></li>
</ol>
<p>You should see the Lambda function you just created called <strong>RemoveS3PublicAccessDemo</strong>.</p>

<h2 id="step8">Task 5: Create a CloudWatch event</h2>

<p>Now that you have created a Lambda function, you need to define how that function is going to be invoked. In this case you can tie it to the managed rule you defined in the previous task.</p>
<ol start="23">
<li>Create and open a new file named <input readonly="" class="copyable-inline-input" size="27" type="text" value="CloudWatchEventPattern.json"> using the following command:</li>
</ol><pre class="highlight plaintext"><code>nano CloudWatchEventPattern.json
</code><button class="button button--copy js-copy-button-11"><i class="fa fa-clipboard"></i></button></pre><ol start="24">
<li>Copy and paste the following configuration as the new contents of the file:</li>
</ol><pre class="highlight plaintext"><code>{
  "source": [
    "aws.config"
  ],
  "detail": {
    "requestParameters": {
      "evaluations": {
        "complianceType": [
          "NON_COMPLIANT"
        ]
      }
    },
    "additionalEventData": {
      "managedRuleIdentifier": [
        "S3_BUCKET_PUBLIC_READ_PROHIBITED",
        "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
      ]
    }
  }
}
</code><button class="button button--copy js-copy-button-12"><i class="fa fa-clipboard"></i></button></pre><ol start="25">
<li><p>Save the file (press CTRL+O and then ENTER) and then exit the editor (press CTRL+X).</p></li>
<li><p>Using your command window, run the following command to create this rule:</p></li>
</ol><pre class="highlight plaintext"><code>aws events put-rule --name ConfigNonCompliantS3Event --event-pattern file://CloudWatchEventPattern.json
</code><button class="button button--copy js-copy-button-13"><i class="fa fa-clipboard"></i></button></pre><ol start="27">
<li>The previous command will return a JSON response. You will need to copy down the value of <strong>RuleArn</strong>, as you will need this later to proceed.</li>
</ol>
<p>You should now have a Lambda function and a CloudWatch event, but you still need to connect them together.</p>
<ol start="28">
<li>To add the Lambda function as a target for the rule, run the following command:</li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="21" type="text" value="<lambda-function-arn>"> with the value you copied previously, and <strong>replace</strong> <input readonly="" class="copyable-inline-input" size="18" type="text" value="<config-sns-topic>"> with the value provided on the <strong>Connection Details</strong> section in Qwiklabs before running the command.</p>
<pre class="highlight plaintext"><code>aws events put-targets --rule ConfigNonCompliantS3Event --targets "Id"="Target1","Arn"="&lt;lambda-function-arn&gt;" "Id"="Target2","Arn"="&lt;config-sns-topic&gt;"
</code><button class="button button--copy js-copy-button-14"><i class="fa fa-clipboard"></i></button></pre><ol start="29">
<li>To give the Lambda function permission to trigger from CloudWatch events, run the following command:</li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="10" type="text" value="<rule-arn>"> with the value you copied previously before running the "aws events put-rule" command.</p>
<pre class="highlight plaintext"><code>aws lambda add-permission --function-name RemoveS3PublicAccessDemo --statement-id my-scheduled-event --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn &lt;rule-arn&gt;
</code><button class="button button--copy js-copy-button-15"><i class="fa fa-clipboard"></i></button></pre>
<p>Now your CloudWatch event can properly trigger your Lambda function.</p>
<ol start="30">
<li><p>Go back to the AWS Management Console, and in the <strong>Services</strong> menu, click <strong>CloudWatch</strong>.</p></li>
<li><p>In the navigation pane, under <strong>Events</strong> click on <strong>Rules</strong>. You should see your rule called <strong>ConfigNonCompliantS3Event</strong>.</p></li>
<li><p>Click on <strong>ConfigNonCompliantS3Event</strong>, and scroll down. You should see the two targets you have defined: The Lambda function and an SNS topic. When a policy violation is detected, the Lambda function will fix the issue and a message will be pushed to SNS so that the appropriate people can be notified.</p></li>
</ol>
<h2 id="step9">Task 6: View the results</h2>
<ol start="33">
<li>Now it's finally time to put everything together. You can start scanning for issues and fixing policy violations by running the following in your command window:</li>
</ol><pre class="highlight plaintext"><code>aws configservice start-config-rules-evaluation --config-rule-names S3PublicReadProhibited S3PublicWriteProhibited
</code><button class="button button--copy js-copy-button-16"><i class="fa fa-clipboard"></i></button></pre>
<p>The Lambda function will begin to review your S3 buckets and automatically fix the problems you saw at the beginning of this lab.</p>
<ol start="34">
<li>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>S3</strong>. In a few minutes, you should see that <strong>privatebucket</strong> is no longer publicly accessible.</li>
</ol>
<h2 id="step10">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>



<h2 id="step11">Appendix</h2>

<h2 id="step12">Connecting to your Amazon Linux EC2 Instance</h2>

<p>Access to a Linux EC2 instance requires a secure connection using an SSH client. The following directions walk you through the process of connecting to your Amazon Linux EC2 instance.</p>

<p>Choose one of the following guides:</p>
<ul>
<li>Connecting from a Windows Machine</li>
<li>Connecting from a macOS or Linux Machine</li>
</ul>
<h3>Connecting from a Windows Machine</h3>
<ol start="35">
<li><p>To the left of the instructions you are currently reading, click <i class="fas fa-download"></i> <strong>Download PPK</strong>.</p></li>
<li><p>If it is not already installed, download the <em>PuTTY.exe</em> client to a folder of your choice from the following URL: <a href="http://www.chiark.greenend.org.uk/%7Esgtatham/putty/download.html" target="_blank"><input readonly="" class="copyable-inline-input" size="63" type="text" value="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html"></a></p></li>
<li><p>Open <em>PuTTY.exe</em>.</p></li>
<li><p>In the <strong>Basic options for your PuTTY Session</strong> pane, for <strong>Host Name (or IP address)</strong>, type <input readonly="" class="copyable-inline-input" size="21" type="text" value="ec2-user@<public-dns>">, where <input readonly="" class="copyable-inline-input" size="12" type="text" value="<public-dns>"> is the Public DNS address of your Amazon EC2 instance that you copied earlier.</p></li>
</ol>
<p>This will log you in to the remote server as the user <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user">, which is the default user on Amazon Linux on EC2.</p>
<ol start="39">
<li><p>In the navigation pane, click <strong>Connection</strong>.</p></li>
<li><p>Set the following options to keep your SSH connection active as you complete the lab:</p></li>
</ol><ul>
<li>For <strong>Seconds between keepalives (0 to turn off)</strong>, <strong>set the value</strong> to <input readonly="" class="copyable-inline-input" size="2" type="text" value="50">.</li>
<li>For <strong>Enable TCP keepalives (SO_KEEPALIVE option)</strong>, enable the checkbox.</li>
</ul><ol start="41">
<li><p>In the navigation pane, click <strong>Connection</strong> -&gt; <strong>SSH</strong> -&gt; <strong>Auth</strong>.</p></li>
<li><p>For <strong>Private key file for authentication</strong>, click <strong>Browse</strong>.</p></li>
<li><p>Select the PPK file you downloaded earlier and click <strong>Open</strong>.</p></li>
</ol>
<p>This file is usually located in the <em>Downloads</em> folder on your PC.</p>
<ol start="44">
<li><p>Click <strong>Open</strong> to initiate the remote session.</p></li>
<li><p>PuTTY will ask whether you wish to cache the server's host key. Click <strong>Yes</strong>.</p></li>
</ol>
<p><strong>Result</strong></p>

<p>You are now connected to <strong>Work Instance</strong>. When lab instructions in subsequent sections require a command window, continue using your SSH terminal window.</p>

<p>To continue this lab, proceed to <a href="#step5">Task 2</a>.</p>

<h3>Connecting from a macOS or Linux Machine</h3>
<ol start="46">
<li><p>To the left of the instructions you are currently reading, click <i class="fas fa-download"></i> <strong>Download PEM</strong>.</p></li>
<li><p>Open the <strong>Terminal</strong> application.</p></li>
</ol>
<p>Complete the remaining connection steps in the terminal window.</p>
<ol start="48">
<li><p>Change directory to the folder where the PEM file has been downloaded (i.e. <input readonly="" class="copyable-inline-input" size="14" type="text" value="cd ~/Downloads">).</p></li>
<li><p>Change the permissions on the PEM file using the command below.</p></li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="10" type="text" value="<pem-file>"> with the name of the PEM file you downloaded.</p>
<pre class="highlight plaintext"><code>chmod 400 &lt;pem-file&gt;
</code><button class="button button--copy js-copy-button-17"><i class="fa fa-clipboard"></i></button></pre><ol start="50">
<li>Use the command below to log in to the remote instance as user <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user">.</li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="10" type="text" value="<pem-file>"> with the name of the PEM file you downloaded and <strong>replace</strong> <input readonly="" class="copyable-inline-input" size="12" type="text" value="<public-dns>"> with the Public DNS address that you noted earlier.</p>
<pre class="highlight plaintext"><code>ssh -i &lt;pem-file&gt; ec2-user@&lt;public-dns&gt;
</code><button class="button button--copy js-copy-button-18"><i class="fa fa-clipboard"></i></button></pre>
<p><strong>Result</strong></p>

<p>You are now connected to <strong>Work Instance</strong>. When lab instructions in subsequent sections require a command window, continue using your SSH terminal window.</p>

<p>To continue this lab, proceed to <a href="#step5">Task 2</a>.</p>

</div>