<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 3 - Web server log analysis using EC2, Kinesis Firehose, S3, and Athena</h1>

<p><strong>Overview</strong></p>

<p>Logs contain a lot of information about what is happening in your environment. They are extremely useful to track sources of a problem, or to find a sequence of an event that just transpired.  They can be used to gain a pulse of your environment to confirm that everything is healthy.  But finding meaningful log entries out of all the tens or hundreds of GB of logging information can be challenging.</p>

<p>In this lab, you will analyze logs of a web server set up on an Amazon EC2 instance. You will install an Amazon Kinesis agent to stream the logs from the EC2 instance to Kinesis Firehose. Kinesis Firehose will publish the logs to an Amazon S3 bucket. Then you will use AWS Glue to crawl the logs in the S3 bucket and infer a schema from the logs. Then you will use the schema to build a table in Amazon Athena and query the table to analyze the logs.</p>

<p>As a part of the lab set up, the following resources are provided to you for help in executing this lab: an EC2 instance with a sample PHP application running on an Apache web server, a Kinesis Firehose delivery stream which will stream logs from the web server, an S3 bucket to which Kinesis Firehose streams the logs, and an  IAM service role for Glue so that Glue has access to crawl the S3 bucket.</p>

<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Install a Kinesis Firehose agent on an EC2 instance</li>
<li>Capture logs from a web server and stream the logs to S3 using Kinesis Firehose delivery stream.</li>
<li>Use AWS Glue to create a crawler to infer schema and create a table from the log data in S3.</li>
<li>Use Amazon Athena to analyze and query meaningful information from the logs.</li>
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

<p>This lab will require approximately <strong>60 minutes</strong> to complete.</p>

<h2 id="step1">Start the Lab</h2>
<ul>
<li>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</li>
</ul>
<h2 id="step2">Task 1:  Install and Set Up Kinesis Agent on Web Server EC2 Instance</h2>

<p>In this task, you will install a Kinesis agent on an EC2 instance running an Apache web server.  You will configure the Kinesis agent to stream logs to a Kinesis Firehose. Kinesis Firehose will push the logs to an S3 bucket.  </p>

<h3>Connect to the EC2 instance running an Apache web server</h3>
<ol start="1">
<li><p>Copy and paste the value of <strong>PublicIP</strong> shown to the left of these instructions. The <strong>PublicIP</strong> is the IP address of the EC2 instance running an Apache web server.</p></li>
<li><p>Using the <strong>PublicIP</strong> you just copied, establish an SSH Connection to the EC2 instance running an Apache web server.</p></li>
</ol>
<p>For detailed instructions to establish an SSH connection, <a href="#ssh-instructions">click here</a> to jump to the Appendix section at the end of this guide.</p>

<p><a id="ssh-after"></a></p>

<h3>Install and set up Kinesis agent</h3>
<ol start="3">
<li>In your SSH terminal, run the command below to install the Kinesis agent on the EC2 instance. If prompted, answer <strong>y</strong> to accept the installation of dependencies.</li>
</ol><pre class="highlight shell"><code>sudo yum install -y aws-kinesis-agent
</code><button class="button button--copy js-copy-button-0"><i class="fa fa-clipboard"></i></button></pre><ol start="4">
<li>To configure the Kinesis Firehose delivery stream in the configuration file, edit the Kinesis agent configuration file by running the command below.</li>
</ol><pre class="highlight shell"><code>sudo nano /etc/aws-kinesis/agent.json  
</code><button class="button button--copy js-copy-button-1"><i class="fa fa-clipboard"></i></button></pre><ol start="5">
<li><p>In the left section of the Qwiklabs page, make a note of the Kinesis Firehose delivery stream shown in <strong>DeliveryStream</strong> and the AWS region shown in <strong>Region</strong>. You will need the delivery stream and the AWS region in the next step.</p></li>
<li><p><strong>Completely replace</strong> the contents of the Kinesis agent configuration file, <input readonly="" class="copyable-inline-input" size="27" type="text" value="/etc/aws-kinesis/agent.json">, you just opened in nano, with the JSON shown below.</p></li>
</ol>
<p><strong>Important:</strong> Replace <strong>&lt;AWSRegion&gt;</strong>, found at two locations in the JSON below, with the AWS region you noted in the previous step. Replace <strong>&lt;DeliveryStream&gt;</strong> in the JSON below, with the name of your Kinesis Firehose delivery stream you noted in the previous step. Make sure to keep the quotes for the delivery stream.   </p>
<pre class="highlight json"><code><span class="p">{</span><span class="w">
  </span><span class="s2">"cloudwatch.endpoint"</span><span class="p">:</span><span class="w"> </span><span class="s2">"monitoring.&lt;AWSRegion&gt;.amazonaws.com"</span><span class="p">,</span><span class="w">
  </span><span class="s2">"cloudwatch.emitMetrics"</span><span class="p">:</span><span class="w"> </span><span class="kc">true</span><span class="p">,</span><span class="w">
  </span><span class="s2">"firehose.endpoint"</span><span class="p">:</span><span class="w"> </span><span class="s2">"firehose.&lt;AWSRegion&gt;.amazonaws.com"</span><span class="p">,</span><span class="w">
  </span><span class="s2">"flows"</span><span class="p">:</span><span class="w"> </span><span class="p">[</span><span class="w">
    </span><span class="p">{</span><span class="w">
      </span><span class="s2">"filePattern"</span><span class="p">:</span><span class="w"> </span><span class="s2">"/var/log/httpd/access_log"</span><span class="p">,</span><span class="w">
      </span><span class="s2">"deliveryStream"</span><span class="p">:</span><span class="w"> </span><span class="s2">"&lt;DeliveryStream&gt;"</span><span class="w">
    </span><span class="p">}</span><span class="w">
  </span><span class="p">]</span><span class="w">
</span><span class="p">}</span><span class="w">
</span></code><button class="button button--copy js-copy-button-2"><i class="fa fa-clipboard"></i></button></pre><ol start="7">
<li><p>Save the file (press CTRL+O and then ENTER) and then exit the editor (press CTRL+X).</p></li>
<li><p>Start the Kinesis agent manually by running the command below.  </p></li>
</ol><pre class="highlight shell"><code>sudo service aws-kinesis-agent start  
</code><button class="button button--copy js-copy-button-3"><i class="fa fa-clipboard"></i></button></pre><ol start="9">
<li>To monitor the contents of the Apache access log file, run the command below.</li>
</ol><pre class="highlight shell"><code>tail -f /var/log/httpd/access_log  
</code><button class="button button--copy js-copy-button-4"><i class="fa fa-clipboard"></i></button></pre>
<p>The command above monitors the access_log file and there won't be any output from this command at this point. Once there is activity on the web server, you will start seeing log entries in the terminal. Keep the terminal running to continue monitoring the access_log file.</p>
<ol start="10">
<li><p>In the left section of the Qwiklabs page, copy the URL shown in <strong>WebsiteURL</strong>. This is the URL of the sample PHP application running on the EC2 instance.</p></li>
<li><p>Open a new tab in your web browser and paste the URL you just copied and hit <em>ENTER</em>. You should see a sample PHP web site.  </p></li>
<li><p>Over the next few minutes, refresh the web page a number of times. By doing so, you are generating logs in the web server access_log file. You may find these logs at <input readonly="" class="copyable-inline-input" size="25" type="text" value="/var/log/httpd/access_log">.</p></li>
<li><p>To the left of the instructions you are currently reading, click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>S3</strong> to open the S3 dashboard.  </p></li>
<li><p>Click the S3 bucket with name similar to: <em>qls-118660-04ce016a7c58701b-s3bucket-xxxxxxxxx</em>.  This is the bucket where the Kinesis agent streams the access logs found on the EC2 instance.</p></li>
<li><p>Keep clicking the sub folders within each folder to get to the lowest level in the hierarchy. The folder structure in the S3 bucket is similar to: <input readonly="" class="copyable-inline-input" size="26" type="text" value="logs / 2018 / 07 / 03 / 16">.
If the bucket is empty, wait for a few minutes and then refresh the browser tab.   </p></li>
<li><p>When you get to the lowest level in the hierarchy, select an object in the bucket by clicking the checkbox next to the object.</p></li>
<li><p>Click <strong>Download</strong> to download a log file. Open the downloaded object in a text editor. You should see one or more of the log entries. These are the log entries logged on the web server in the <input readonly="" class="copyable-inline-input" size="25" type="text" value="/var/log/httpd/access_log"> file.  </p></li>
</ol>
<h2 id="step3">Task 2:  Analysis of logs using Amazon Athena and AWS Glue</h2>

<p>In this task you will use Amazon Athena to analyze the Apache web server access log information captured in the S3 bucket.  Amazon Athena will use AWS Glue to crawl the S3 bucket and define the schema of the log data. Then Athena will create a table out of the schema. You will then use a number of different queries to analyze the access logs.  </p>
<ol start="20">
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>AWS Glue</strong> to go to the AWS Glue dashboard.
Note: If you see "Upgrade to AWS Glue Data Catalog" banner, follow the instructions to upgrade. Once the upgrade is complete return to the current step.</p></li>
<li><p>On the Glue dashboard, click <strong>Get started</strong>.
Note: If you see the "Add crawler" page instead for <strong>Get started</strong>, click the close icon at the top to exit out of the page.</p></li>
<li><p>In the left side pane, click <strong>Crawlers</strong>.</p></li>
<li><p>To create a new crawler to crawl the logs in the S3 bucket, click <strong>Add crawler</strong>.</p></li>
<li><p>For <strong>Crawler name</strong>, type <input readonly="" class="copyable-inline-input" size="10" type="text" value="logcrawler">  </p></li>
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>For <strong>Choose a data store</strong>, select <strong>S3</strong>.</p></li>
<li><p>For <strong>Crawl data in</strong>, keep the default selection, <strong>Specified path in my account</strong>.</p></li>
<li><p>For <strong>Include path</strong>, click the folder icon to select the S3 bucket with the log data.</p></li>
<li><p>Click the <strong>+</strong> icon next to the S3 bucket name. The S3 bucket name is similar to: <em>qls-118660-04ce016a7c58701b-s3bucket-xxxxxxxxx</em>.</p></li>
<li><p>Click the radio button for the <strong>logs</strong> folder.</p></li>
<li><p>Click <strong>Select</strong> at the bottom of the splash screen. The crawler is now configured to crawl the <strong>logs</strong> folder to infer the schema from the log data.  </p></li>
<li><p>Click <strong>Next</strong>.  </p></li>
<li><p>Skip the <strong>Add another data store</strong> page and click <strong>Next</strong>.</p></li>
<li><p>On the <strong>Choose an IAM role</strong> page, select the <strong>Choose an existing IAM role</strong> option.</p></li>
<li><p>From the <strong>IAM role</strong> drop down menu, select the role similar to: <em>qls-118660-XXXXXXXXXXXX-GlueServiceRole-XXXXXXXXX</em>.</p></li>
<li><p>Click <strong>Next</strong>.  </p></li>
<li><p>On the <strong>Create a schedule for this crawler</strong> page, keep the default selection and click <strong>Next</strong>.  </p></li>
<li><p>On the <strong>Configure the crawler's output</strong> page, click <strong>Add database</strong> button.  </p></li>
<li><p>In the pop up window, for <strong>Database name</strong>, type <input readonly="" class="copyable-inline-input" size="12" type="text" value="logsdatabase"></p></li>
<li><p>Click <strong>Create</strong>.
Note: If an error occurs because the database already exists, cancel the pop up window by clicking <strong>X</strong> on the pop window.  Make sure the <strong>Database</strong> field on the <strong>Configure the crawler's output</strong> page contains <input readonly="" class="copyable-inline-input" size="12" type="text" value="logsdatabase">, if not enter <input readonly="" class="copyable-inline-input" size="12" type="text" value="logsdatabase">.</p></li>
<li><p>On the <strong>Configure the crawler's output</strong> page, click <strong>Next</strong>.  </p></li>
<li><p>Review the information and click <strong>Finish</strong>. You should see a success message banner at the top. Your crawler has been successfully created.</p></li>
<li><p>On the <strong>Crawlers</strong> page, select the checkbox for the <strong>logcrawler</strong> crawler.  </p></li>
<li><p>Click <strong>Run crawler</strong>. The status of the crawler changes to <strong>Starting</strong>.</p></li>
<li><p>Wait for the crawler to finish running.  This may take a couple of minutes. When the crawler finishes running, it's status changes to <strong>Ready</strong>.</p></li>
<li><p>When the crawler has finished running, you will see a success banner message at the top. Click the <strong>logsdatabase</strong> database name in the success message on the banner.  This will take you to the AWS Glue Tables page and you should see a table called <strong>logs</strong> in the <strong>logsdatabase</strong>.  </p></li>
<li><p>Click the hyperlink for the <strong>logs</strong> table in the tables list.  </p></li>
<li><p>The page displays the schema created by AWS Glue when it crawled the data in the S3 bucket.  This schema will be used by Amazon Athena to create an external table.  Review the information displayed.  </p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Athena</strong>.
Note: If prompted, click <strong>Get Started</strong>.</p></li>
<li><p>Select the <strong>Query Editor</strong> tab, if not already selected.  </p></li>
<li><p>In the left side pane, for <strong>Database</strong>, select the <strong>logsdatabase</strong> database in the dropdown.  If necessary, refresh the database list.  </p></li>
<li><p>Click <strong>logs (Partitioned)</strong> in the <strong>Tables</strong> section in the left side pane. You should see the schema for the logs table.  </p></li>
<li><p>Click the vertical elipses next to the  <strong>logs (Partitioned)</strong> table name. Refer to the screenshot below.  </p></li>
</ol>
<p><img src="https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-SISECO/v2.3.0/lab-3-logs/instructions/en_us/images/verticalelipses.jpg" alt=""></p>
<ol start="54">
<li>Select <strong>Preview table</strong>.  The SQL statement <input readonly="" class="copyable-inline-input" size="45" type="text" value="SELECT * FROM &quot;logsdatabase&quot;.&quot;logs&quot; limit 10;"> is automatically placed in the query editor pane and run. Note how the database and table are referenced in the query statement : <input readonly="" class="copyable-inline-input" size="21" type="text" value="&quot;logsdatabase&quot;.&quot;logs&quot;">. The results are displayed in the <strong>Results</strong> pane below.  Review the results.</li>
</ol>
<p>You can now easily query and analyze the <strong>logs</strong> table to get meaningful information from the log entries created on the web server.</p>

<h2 id="step4">Task 3:  Challenge</h2>

<p>In this task, you are challenged to write some queries to further analyze the <strong>logs</strong> table created in the previous task. Feel free to try the challenges below, before viewing the answers to those challenges.</p>

<h3>1. Count log entries</h3>

<p>Write and execute a query to count the number of log entries (rows in the table). To view the answer to this challenge, <a href="#countlogentries-answer">click here.</a></p>

<p><a id="challenge-2"></a></p>

<h3>2. Count Unique Client IP addresses</h3>

<p>Write and execute a query to count the number of unique client IP addresses (clientip) found in the logs. To view the answer to this challenge, <a href="#countuniqueclientip-answer">click here.</a></p>

<p><a id="challenge-3"></a></p>

<h3>3. Count Unique Agents</h3>

<p>Write and execute a query to count the number of unique agents (agent), such as web browsers, found in the logs.  To view the answer to this challenge, <a href="#countuniqueagents-answer">click here.</a></p>

<p><a id="challenge-4"></a></p>

<h3>4. Count Unique Agents by ClientIP</h3>

<p>Write and execute a query to count the number of unique agents (agent), such as web browsers, grouped by unique client IP addresses (clientip) found in the logs.  To view the answer to this challenge, <a href="#countuniqueagentsbyip-answer">click here.</a></p>

<p><a id="countlogentries-answer"></a></p>

<h3>1. Answer - Count Log Entries</h3>

<p>Write and execute a query to count the number of log entries (rows in the table).  </p>
<pre class="highlight sql"><code><span class="k">SELECT</span> <span class="k">COUNT</span><span class="p">(</span><span class="n">clientip</span><span class="p">)</span> <span class="k">FROM</span> <span class="nv">"logsdatabase"</span><span class="p">.</span><span class="nv">"logs"</span><span class="p">;</span>  
</code><button class="button button--copy js-copy-button-5"><i class="fa fa-clipboard"></i></button></pre>
<p><a href="#challenge-2">Click here to go back to the next challenge.</a></p>

<p><a id="countuniqueclientip-answer"></a></p>

<h3>2. Answer - Count Unique Client IP addresses</h3>

<p>Write and execute a query to count the number of unique client IP addresses (clientip) found in the logs.  </p>
<pre class="highlight sql"><code><span class="k">SELECT</span> <span class="n">clientip</span><span class="p">,</span>
  <span class="k">COUNT</span><span class="p">(</span><span class="o">*</span><span class="p">)</span> <span class="n">clientip</span>
<span class="k">FROM</span> <span class="nv">"logsdatabase"</span><span class="p">.</span><span class="nv">"logs"</span>
<span class="k">GROUP</span> <span class="k">BY</span> <span class="n">clientip</span><span class="p">;</span>  
</code><button class="button button--copy js-copy-button-6"><i class="fa fa-clipboard"></i></button></pre>
<p><a href="#challenge-3">Click here to go back to the next challenge.</a></p>

<p><a id="countuniqueagents-answer"></a></p>

<h3>3. Answer - Count Unique Agents</h3>

<p>Write and execute a query to count the number of unique agents (agent), such as web browsers, found in the logs.  </p>
<pre class="highlight sql"><code><span class="k">SELECT</span> <span class="n">agent</span><span class="p">,</span>
  <span class="k">COUNT</span><span class="p">(</span><span class="o">*</span><span class="p">)</span> <span class="n">agent</span>
<span class="k">FROM</span> <span class="nv">"logsdatabase"</span><span class="p">.</span><span class="nv">"logs"</span>
<span class="k">GROUP</span> <span class="k">BY</span> <span class="n">agent</span><span class="p">;</span>  
</code><button class="button button--copy js-copy-button-7"><i class="fa fa-clipboard"></i></button></pre>
<p><a href="#challenge-4">Click here to go back to the next challenge.</a></p>

<p><a id="countuniqueagentsbyip-answer"></a></p>

<h3>4. Answer - Count Unique Agents by ClientIP</h3>

<p>Write and execute a query to count the number of unique agents (agent), such as web browsers, grouped by unique client IP addresses (clientip) found in the logs.  </p>
<pre class="highlight sql"><code><span class="k">SELECT</span> <span class="n">clientip</span><span class="p">,</span>
  <span class="n">agent</span><span class="p">,</span>
  <span class="k">COUNT</span><span class="p">(</span><span class="o">*</span><span class="p">)</span> <span class="n">agent</span>
<span class="k">FROM</span> <span class="nv">"logsdatabase"</span><span class="p">.</span><span class="nv">"logs"</span>
<span class="k">GROUP</span> <span class="k">BY</span> <span class="n">clientip</span><span class="p">,</span> <span class="n">agent</span>
<span class="k">ORDER</span> <span class="k">BY</span> <span class="n">clientip</span><span class="p">;</span>  
</code><button class="button button--copy js-copy-button-8"><i class="fa fa-clipboard"></i></button></pre>


<h2 id="step5">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>



<p><a id="ssh-instructions"></a></p>

<h2 id="step6">Appendix</h2>

<p>Access to a Linux EC2 instance requires a secure connection using an SSH client. The following directions walk you through the process of connecting to your Amazon Linux EC2 instance.</p>

<h3>
<i class="fab fa-windows"></i> Windows Users: Using SSH to connect</h3>

<p><i class="fas fa-comment"></i> These instructions are for Windows users only.</p>

<p>If you are using Mac or Linux, <a href="#ssh-MACLinux">skip to the next section</a>.</p>
<ol start="55">
<li><p>To the left of the instructions you are currently reading, click <span style="color:blue;"><i class="fas fa-download"></i></span> <strong>Download PPK</strong>.</p></li>
<li><p>Save the file to the directory of your choice.</p></li>
</ol>
<p>You will use PuTTY to SSH to Amazon EC2 instances.</p>

<p>If you do not have PuTTY installed on your computer, <a href="https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe">download it here</a>.</p>
<ol start="57">
<li><p>Open PuTTY.exe</p></li>
<li><p>Configure the PuTTY to not timeout:</p></li>
</ol><ul>
<li>Click <strong>Connection</strong>
</li>
<li>Set <strong>Seconds between keepalives</strong> to <input readonly="" class="copyable-inline-input" size="2" type="text" value="30">
</li>
</ul>
<p>This allows you to keep the PuTTY session open for a longer period of time.</p>
<ol start="59">
<li>Configure your PuTTY session:</li>
</ol><ul>
<li>Click <strong>Session</strong>.</li>
<li>
<strong>Host Name (or IP address):</strong> Copy and paste the value of <strong>PublicIP</strong> shown to the left of these instructions.</li>
<li>In the <strong>Connection</strong> list, expand <i class="far fa-plus-square"></i> <strong>SSH</strong>.</li>
<li>Click <strong>Auth</strong> (don't expand it).</li>
<li>Click <strong>Browse</strong>.</li>
<li>Browse to and select the PPK file that you downloaded.</li>
<li>Click <strong>Open</strong> to select it.</li>
<li>Click <strong>Open</strong>.</li>
</ul><ol start="60">
<li><p>Click <strong>Yes</strong>, to trust the host and connect to it.</p></li>
<li><p>When prompted <strong>login as</strong>, enter: <input readonly="" class="copyable-inline-input" size="8" type="text" value="ec2-user"></p></li>
</ol>
<p>This will connect to your EC2 instance.</p>
<ol start="62">
<li><a href="#ssh-after">Windows Users: Click here to go back to the next step in task 1.</a></li>
</ol>
<p><a id="ssh-MACLinux"></a></p>

<h3>Mac <i class="fab fa-apple"></i> and Linux <i class="fab fa-linux"></i> Users</h3>

<p>These instructions are for Mac/Linux users only. If you are a Windows user and have already established an SSH connection, <a href="#ssh-after">click here to go back to the next step in task 1.</a></p>
<ol start="63">
<li><p>To the left of the instructions you are currently reading, click <span style="color:blue;"><i class="fas fa-download"></i></span> <strong>Download PEM</strong>.</p></li>
<li><p>Save the file to the directory of your choice.</p></li>
<li><p>Copy this command to a text editor:</p></li>
</ol><pre class="highlight plaintext"><code>chmod 400 KEYPAIR.pem

ssh -i KEYPAIR.pem ec2-user@PublicIP
</code><button class="button button--copy js-copy-button-9"><i class="fa fa-clipboard"></i></button></pre><ol start="66">
<li><p>Replace <em>KEYPAIR.pem</em> with the path to the PEM file you downloaded.</p></li>
<li><p>Replace <em>PublicIP</em> with the value of PublicIP shown to the left side of these instructions.</p></li>
<li><p>Paste the updated command into the terminal window and run it.</p></li>
<li><p>Type <input readonly="" class="copyable-inline-input" size="3" type="text" value="yes"> when prompted to allow a first connection to this remote SSH server.</p></li>
</ol>
<p>Because you are using a key pair for authentication, you will not be prompted for a password.</p>

<p><a href="#ssh-after">Click here to go back to the next step in task 1.</a></p>

</div>