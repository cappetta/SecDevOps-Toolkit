<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 6 - Using AWS KMS</h1>

<p><strong>Overview</strong></p>

<p>In this lab, you will:</p>
<ul>
<li>Configure AWS KMS to create your own master keys</li>
<li>Encrypt EBS volumes and S3 data using KMS</li>
<li>Verify the behavior of S3 cross-region replication on server-side encrypted objects</li>
</ul>
<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Configure KMS</li>
<li>Encrypt EBS volumes using AWS KMS</li>
<li>Encrypt S3 data using KMS</li>
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

<p>This lab requires approximately <strong>70 minutes</strong> to complete.</p>



<h2 id="step1">Accessing the AWS Management Console</h2>
<ul>
<li><p>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</p></li>
<li><p>Click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
</ul>
<p><i class="fas fa-exclamation-triangle"></i> Please do not change the Region during this lab.</p>

<h2 id="step2">Task 1: Working With KMS Master Keys</h2>

<p>In this section, you will configure AWS KMS in your environment. You will create and manage your KMS master key.</p>

<h3>Task 1.1: Enable CloudTrail Logging</h3>

<p>In this task, you will:</p>
<ul>
<li>Enable CloudTrail logs in your environment so you can capture details about all the API calls. Though this is not required to use KMS, enabling CloudTrail will help you in keeping track of the usage of your KMS keys.</li>
<li>Configure CloudTrail to send events to CloudWatch.</li>
</ul><ol start="1">
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>CloudTrail</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Trails</strong>.</p></li>
<li><p>In the list of trails, click the trail name that belongs to your region.</p></li>
</ol>
<p><strong>Note:</strong> You can find your region from then navigation bar of your AWS console page.</p>
<ol start="4">
<li>Click the pencil icon <i class="fas fa-pencil-alt"></i> beside <strong>Storage location</strong> to edit the S3 bucket settings.</li>
</ol>
<p><strong>Note:</strong> CloudTrail is automatically enabled as part of the lab setup. You are going to change the S3 bucket location, so the logs are captured to your own bucket.</p>
<ol start="5">
<li><p>For <strong>Create a new S3 bucket</strong>, click the <strong>Yes</strong> option.</p></li>
<li><p>For <strong>S3 bucket</strong>, replace the existing bucket name with <input readonly="" class="copyable-inline-input" size="41" type="text" value="myapilogs-<your initials>-<random number>"></p></li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="15" type="text" value="<your initials>"> with your initials and <input readonly="" class="copyable-inline-input" size="15" type="text" value="<random number>"> with a random number of your choosing.</p>
<ol start="7">
<li><p>Click <strong>Save</strong>.</p></li>
<li><p>Under <strong>CloudWatch Logs</strong> menu item, click <strong>Configure</strong>.</p></li>
<li><p>For <strong>New or existing log group</strong>, enter <input readonly="" class="copyable-inline-input" size="16" type="text" value="MyCloudTrailLogs"> and then click <strong>Continue</strong>.</p></li>
<li><p>Click <strong>Allow</strong> to create the role that will be assumed by CloudTrail to deliver CloudTrail events to CloudWatch.</p></li>
</ol>
<p>You have successfully enabled CloudTrail logging and configured CloudTrail to send events to CloudWatch.</p>

<h3>Task 1.2: Create KMS master key</h3>

<p>In this task, you will create your KMS master key. You will use this key in later labs to encrypt your data.</p>
<ol start="11">
<li><p>On the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>On the <strong>EC2 Dashboard</strong> page, make a note of the region used by your instances. You can find this information arround the <strong>Availability Zone Status</strong> column.</p></li>
<li><p>On the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Encryption keys</strong>.</p></li>
<li><p>If you get a welcome page, click <strong>Get Started Now</strong>.</p></li>
</ol>
<p><i class="fas fa-comment"></i> If you do not see the welcome page, proceed to the next step.</p>
<ol start="16">
<li><p>Next to <strong>Region</strong>, select the region that is being used by your EC2 instances that you noted above.</p></li>
<li><p>Click <strong>Create key</strong>.</p></li>
<li><p>On the <strong>Create Alias and Description</strong> page, use the following:</p></li>
</ol><ul>
<li>
<strong>Alias (required):</strong> <input readonly="" class="copyable-inline-input" size="10" type="text" value="PCIdatakey">
</li>
<li>
<strong>Description:</strong> <input readonly="" class="copyable-inline-input" size="36" type="text" value="KMS key used for encrypting PCI data">
</li>
</ul><ol start="19">
<li><p>Click <strong>Next Step</strong>.</p></li>
<li><p>For <strong>Add Tags</strong>, click <strong>Next Step</strong>.</p></li>
<li><p>On the <strong>Define Key Administrative Permissions</strong> page, select <i class="far fa-check-square"></i> <strong>awsstudent</strong>.</p></li>
</ol>
<p><strong>Note:</strong> "awsstudent" is the default student account created in the lab environment. You are currently logged in as "awsstudent".</p>
<ol start="22">
<li><p>Click <strong>Next Step</strong>.</p></li>
<li><p>On the <strong>Define Key Usage Permissions</strong> page, select <i class="far fa-check-square"></i> <strong>awsstudent</strong>.</p></li>
<li><p>Click <strong>Next Step</strong>.</p></li>
<li><p>Review the key policy and then click <strong>Finish</strong> to create the key.</p></li>
</ol>
<p>You have now successfully created a KMS master key and identified your user account as both the key administrator and user for the key.</p>

<h3>Task 1.3: Enable KMS master key rotation</h3>

<p>In this lab, you will enable rotation for your KMS master key.</p>
<ol start="26">
<li><p>In the left navigation pane, click <strong>Encryption keys</strong>.</p></li>
<li><p>Next to <strong>Region</strong>, select the same region as your KMS master key.</p></li>
<li><p>Click <strong>PCIdatakey</strong> (click on the name link).</p></li>
<li><p>Scroll down to the <strong>Key Rotation</strong> section and select <i class="far fa-check-square"></i> <strong>Rotate this key every year</strong>.</p></li>
<li><p>Click <strong>Save Changes</strong>.</p></li>
<li><p>On the key details page, scroll all the way up and in the upper right corner of the page, click <strong>Back to Encryption Keys</strong>.</p></li>
</ol>
<p>You have now successfully enabled yearly rotation for your KMS master key.</p>

<h2 id="step3">Task 2: Encrypt EBS Volumes Using KMS</h2>

<p>In this section, you will use your KMS master key to encrypt EBS volumes.</p>

<h3>Task 2.1: Encrypt EBS volume</h3>

<p>In this task, you will encrypt an EBS volume using your KMS master key.</p>
<ol start="32">
<li><p>On the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Volumes</strong>.</p></li>
<li><p>Click <strong>Create Volume</strong>.</p></li>
<li><p>In the <strong>Create Volume</strong> dialog box, for <strong>Size (GiB)</strong>, enter <input readonly="" class="copyable-inline-input" size="1" type="text" value="1"></p></li>
<li><p>Select the <strong>Encrypt this volume</strong> check box.</p></li>
<li><p>For <strong>Master Key</strong>, click <strong>PCIdatakey</strong>.</p></li>
</ol>
<p>By default, an EBS key is automatically generated and used for encrypting your EBS volumes.</p>
<ol start="38">
<li>Click <strong>Create Volume</strong>, then click <strong>Close</strong>.</li>
</ol>
<p>The encrypted volume will be created. Your master key is used to encrypt/decrypt this volume.</p>
<ol start="39">
<li>Select the encrypted volume to view the details of the volume. You may have to refresh the screen to see the volume.</li>
</ol>
<h2 id="step4">Task 3: Encrypting Amazon S3 Data Using KMS</h2>

<p>In this section, you will encrypt your Amazon S3 data using your KMS master key. This method of encryption is referred to as Amazon S3 Server Side Encryption using KMS managed keys (SSE-KMS).</p>

<p>In a previous lab, you encrypted your S3 data using S3 managed keys (SSE-S3).</p>

<h3>Task 3.1: Encrypt Amazon S3 Data</h3>

<p>In this task, you will encrypt your data in S3 using your KMS master key.</p>
<ol start="40">
<li><p>On the <strong>Services</strong> menu, click <strong>S3</strong>.</p></li>
<li><p>Click <i class="fas fa-plus"></i><strong>Create bucket</strong>.</p></li>
<li><p>In the <strong>Create bucket</strong> dialog box, use the following:</p></li>
</ol><ul>
<li>
<strong>Bucket name</strong>: <input readonly="" class="copyable-inline-input" size="38" type="text" value="secret-<your initials>-<random number>">
</li>
<li>
<strong>Region</strong>: Choose the same region as your KMS master key.</li>
</ul>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="15" type="text" value="<your initials>"> with your initials and <input readonly="" class="copyable-inline-input" size="15" type="text" value="<random number>"> with a random number of your choosing.</p>
<ol start="43">
<li><p>Click the <strong>Create</strong> button.</p></li>
<li><p>Click the name of your <strong>secret</strong> bucket to open it.</p></li>
<li><p>Click <i class="fas fa-upload"></i><strong>Upload</strong>.</p></li>
<li><p>In the <strong>Upload</strong> dialog box, click <strong>Add files</strong>.</p></li>
<li><p>Browse to a file (picture or image) on your local system, and click <strong>Open</strong>.</p></li>
<li><p>In the <strong>Upload</strong> dialog box, click <strong>Next</strong>.</p></li>
<li><p>Review the permissions, and click <strong>Next</strong>.</p></li>
<li><p>In the <strong>Encryption</strong> section, select <strong>AWS KMS master-key</strong>.</p></li>
<li><p>For the key, select <strong>PCIdatakey</strong>.</p></li>
<li><p>Click <strong>Upload</strong>.</p></li>
</ol>
<h3>Task 3.2: Verify Encryption</h3>

<p>In this task, you will verify the SSE-KMS encryption.</p>
<ol start="53">
<li><p>Select <i class="far fa-check-square"></i> the encrypted file that you uploaded in the previous task.</p></li>
<li><p>Click <strong>Action</strong>, then click <strong>Make public</strong>.</p></li>
<li><p>Click <strong>Make public</strong>.</p></li>
<li><p>Click the file again.</p></li>
<li><p>Scroll down to the <strong>Link</strong> section.</p></li>
<li><p>Click on the URL of the file you uploaded.</p></li>
</ol>
<p>Notice that you are not be able to open the file, even though it is public, because the file is encrypted and needs to be decrypted first before you can view it.</p>
<ol start="59">
<li><p>Click the back button in your web browser.</p></li>
<li><p>Click <strong>Open</strong>.</p></li>
</ol>
<p>You are now able to see the file because S3 transparently decrypted the file using your KMS key.</p>

<h3>Task 3.3: Disable KMS Master Key</h3>

<p>In this task, you will disable your KMS master key.</p>
<ol start="61">
<li><p>On the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Encryption keys</strong>.</p></li>
<li><p>Next to <strong>Region</strong>, select the same region as your KMS master key.</p></li>
<li><p>Select <i class="far fa-check-square"></i> <strong>PCIdatakey</strong>.</p></li>
<li><p>Click <strong>Key actions</strong>, then click <strong>Disable</strong>.</p></li>
<li><p>Verify that the key <strong>Status</strong> has changed to <em>Disabled</em>. You have now disabled your KMS master key.</p></li>
</ol>
<h3>Task 3.4: Verify access to S3 data</h3>

<p>In this task, you will verify access to your S3 file now that the master key is disabled.</p>
<ol start="67">
<li><p>On the <strong>Services</strong> menu, click <strong>S3</strong>.</p></li>
<li><p>Click the <strong>secret</strong> bucket name to view its contents.</p></li>
<li><p>Click on the encrypted file that you uploaded previously, and then click <strong>Open</strong>.</p></li>
</ol>
<p>You will not be able to view the file. Notice the error code and the message. You are not able to view the file because the key is disabled.</p>

<h3>Task 3.5: Schedule KMS Master Key For Deletion</h3>

<p>In this task, you will schedule your KMS master key for deletion.</p>
<ol start="70">
<li><p>On the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Encryption keys</strong>.</p></li>
<li><p>Next to <strong>Region</strong>, select the same region as your KMS master key.</p></li>
<li><p>Select <i class="far fa-check-square"></i> <strong>PCIdatakey</strong>.</p></li>
<li><p>Click <strong>Key actions</strong>, then click <strong>Schedule key deletion</strong>.</p></li>
<li><p>In the <strong>Schedule key deletion</strong> dialog box, change the <strong>Waiting period (in days)</strong> to <strong>7</strong>.</p></li>
<li><p>Click <strong>Schedule deletion</strong>.</p></li>
</ol>
<p>In a real-world scenario, the PCIdatakey would now be scheduled to be deleted after 7 days. However in this case, our lab platform will automatically delete this resource when it deletes the entire lab environment a set time after you have completed the lab.</p>

<h3>Task 3.6: Check CloudWatch Logs for API Activity</h3>

<p>In this task, you will explore the logs of your encryption activities. Exploring the logs will give you a sense of the api logs that are produced through your encryption activities.</p>
<ol start="77">
<li><p>On the <strong>Services</strong> menu, click <strong>CloudWatch</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Logs</strong>.</p></li>
<li><p>Click the <strong>MyCloudTrailLogs</strong> Log group.</p></li>
<li><p>Click your log stream.</p></li>
<li><p>Explore the event logs based on the activities that you just performed by filtering for words such as: <input readonly="" class="copyable-inline-input" size="15" type="text" value="ENCRYPT_DECRYPT">, <input readonly="" class="copyable-inline-input" size="6" type="text" value="volume">, <input readonly="" class="copyable-inline-input" size="10" type="text" value="s3 encrypt">, <input readonly="" class="copyable-inline-input" size="3" type="text" value="kms">.</p></li>
</ol>
<h3>Task 3.7: Cross-Region Replication</h3>

<p>In this task you will setup cross-region replication for S3 and you will test replicating objects that have been encrypted with an AWS Key Management Service master key as well as an Amazon S3 service master key. This will give you experience in deciding which types of keys to use when replicating encrypted objects.</p>
<ol start="82">
<li><p>On the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>In the left navigation pane, click <strong>Encryption keys</strong>.</p></li>
<li><p>Next to Region, select the same region as your <strong>KMS master key</strong>.</p></li>
<li><p>Select <i class="far fa-check-square"></i> <strong>PCIdatakey</strong>.</p></li>
<li><p>Click <strong>Key actions</strong>, then click <strong>Cancel key deletion</strong>.</p></li>
<li><p>Select <i class="far fa-check-square"></i> <strong>PCIdatakey</strong>.</p></li>
<li><p>Under <strong>Key actions</strong>, select <strong>Enable</strong>.</p></li>
<li><p>On the <strong>Services</strong> menu, click <strong>S3</strong>.</p></li>
<li><p>Click your <strong>secret</strong> bucket.</p></li>
<li><p>Click the <strong>Properties</strong> tab.</p></li>
<li><p>Click on the <strong>Versioning</strong> section.</p></li>
<li><p>Select <i class="far fa-dot-circle"></i> <strong>Enable versioning</strong> and click <strong>Save</strong>.</p></li>
<li><p>Click the <strong>Amazon S3</strong> link at the top of the screen to return to your list of buckets.</p></li>
<li><p>Click <i class="fas fa-plus"></i> <strong>Create bucket</strong>.</p></li>
</ol><ul>
<li>For <strong>Bucket name</strong>, enter <input readonly="" class="copyable-inline-input" size="45" type="text" value="myreplication-<your initials>-<random number>">
</li>
<li>For <strong>Region</strong>, select another region that is close to your current region. (Do not use Ohio or Montreal as a destination region.)</li>
<li>For <strong>Copy settings from an existing bucket</strong>, select the <strong>secret</strong> bucket.</li>
</ul>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="15" type="text" value="<your initials>"> with your initials and <input readonly="" class="copyable-inline-input" size="15" type="text" value="<random number>"> with a random number of your choosing.</p>
<ol start="96">
<li><p>Click <strong>Create</strong>.</p></li>
<li><p>Click your <strong>secret</strong> bucket.</p></li>
<li><p>Click the <strong>Management</strong> tab.</p></li>
<li><p>Click <strong>Replication</strong>.</p></li>
<li><p>Click <i class="fas fa-plus"></i> <strong>Add rule</strong>.</p></li>
</ol>
<p>You will use the default settings, which is to replicate the whole bucket.</p>
<ol start="101">
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>For <strong>Destination bucket</strong>, select your <em>myreplication-</em> bucket.</p></li>
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>Under <strong>IAM role</strong>, select <strong>Create new role</strong>. For <strong>Rule name</strong>, type <input readonly="" class="copyable-inline-input" size="12" type="text" value="S3accessrole"></p></li>
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>Review your settings and click <strong>Save</strong>.</p></li>
<li><p>Click the <strong>Amazon S3</strong> link at the top of the screen to return to your list of buckets.</p></li>
</ol>
<p>Your new <strong>myreplication</strong> bucket should be listed.</p>
<ol start="108">
<li><p>Click your <strong>myreplication</strong> bucket.</p></li>
<li><p>Is your picture displayed in the bucket? Why or Why not?</p></li>
<li><p>Click your <strong>secret</strong> bucket.</p></li>
<li><p>Click <i class="fas fa-upload"></i> <strong>Upload</strong>.</p></li>
<li><p>Click <strong>Add files</strong>.</p></li>
<li><p>Select another picture from your computer to upload and click <strong>Open</strong>.</p></li>
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>Review the permissions and click <strong>Next</strong>.</p></li>
<li><p>In the <strong>Encryption</strong> section, select <strong>AWS KMS master-key</strong>.</p></li>
<li><p>For key, select your <strong>PCIdatakey</strong>.</p></li>
<li><p>Click <strong>Upload</strong>.</p></li>
<li><p>Once the image has been uploaded, click the name of the file.</p></li>
<li><p>Click <strong>Open</strong>.</p></li>
</ol>
<p>You should be able to open the file.</p>
<ol start="121">
<li><p>Click the <strong>Amazon S3</strong> link at the top of the screen to return to your list of buckets.</p></li>
<li><p>Click your <strong>myreplication</strong> bucket.</p></li>
<li><p>Did your image get replicated to your <strong>myreplication</strong> bucket? Why or why not?</p></li>
<li><p>Navigate back to your <strong>secret</strong> bucket.</p></li>
<li><p>Click <i class="fas fa-upload"></i> <strong>Upload</strong>.</p></li>
<li><p>Click <strong>Add files</strong>.</p></li>
<li><p>Select another picture from your computer and then click <strong>Open</strong>.</p></li>
<li><p>Click <strong>Next</strong>.</p></li>
<li><p>Review the permissions and click <strong>Next</strong>.</p></li>
<li><p>In the <strong>Encryption</strong> section, select <strong>Amazon S3 master-key</strong>.</p></li>
<li><p>Click <strong>Upload</strong>.</p></li>
<li><p>Click on the name of the new picture that you just uploaded.</p></li>
<li><p>Click <strong>Open</strong>.</p></li>
</ol>
<p>You should be able to open it.</p>
<ol start="134">
<li><p>Navigate to your <strong>myreplication</strong> bucket.</p></li>
<li><p>Did the picture that you just uploading get replicated to the other region? Why or why not?</p></li>
<li><p>Click on the new picture that you just uploaded and then open it.</p></li>
<li><p>Were you able to open the picture?</p></li>
</ol>
<p>For more information on cross-region replication, visit: <a href="http://docs.aws.amazon.com/AmazonS3/latest/dev/crr-what-is-isnot-replicated.html" target="_blank">http://docs.aws.amazon.com/AmazonS3/latest/dev/crr-what-is-isnot-replicated.html</a></p>



<h2 id="step5">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>

</div>
