<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 4 - AWS Federated Authentication with AD FS</h1>

<p><strong>Overview</strong></p>

<p>With AWS IAM, you can create AWS users and use permissions to allow and deny their access to AWS resources.  However, you can also grant federated access to users in your existing identity systems, thus leveraging all your passwords, policies, roles and groups.</p>

<p>This guide will walk you through the creation a federation setup using Microsoft Active Directory.</p>

<p><strong>AD FS Federated Authentication Process</strong></p>

<p>Here is the process a user will follow to authenticate to AWS using Active Directory and AD FS:</p>
<ul>
<li><p>A corporate user accesses the corporate Active Directory Federation Services portal sign-in page and provides Active Directory authentication credentials.</p></li>
<li><p>AD FS authenticates the user against Active Directory.</p></li>
<li><p>Active Directory returns the user’s information, including AD group membership information.</p></li>
<li><p>AD FS dynamically builds ARNs by using Active Directory group memberships for the IAM roles and user attributes for the AWS account IDs, and sends a signed assertion to the users browser with a redirect to post the assertion to AWS STS.</p></li>
<li><p>Temporary credentials are returned using STS AssumeRoleWithSAML.</p></li>
<li><p>The user is authenticated and provided access to the AWS management console.</p></li>
</ul>
<p><img src="https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-SISECO/v2.3.0/lab-4-federation/instructions/en_us/images/auth_process.png" alt=""></p>

<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Create new users and groups in Microsoft Active Directory Federation Services</li>
<li>Enable federated access to the AWS Management Console using an existing Microsoft AD server</li>
<li>Create new roles in IAM and map those to your federated users</li>
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

<p>This lab will take approximately 1 hour to complete.</p>



<h2 id="step1">Accessing the AWS Management Console</h2>

<h2 id="step2">Accessing the AWS Management Console</h2>
<ul>
<li><p>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</p></li>
<li><p>Click <span style="background-color:#F9AB00;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Open Console</span></p></li>
<li><p>Sign in to the AWS Management Console using the credentials shown to the left of these instructions.</p></li>
</ul>
<p><i class="fas fa-exclamation-triangle"></i> Please do not change the Region during this lab.</p>

<h2 id="step3">Task 1: Connect to your Windows  Instance</h2>
<ol start="1">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click on <strong>Instances</strong>.</p></li>
<li><p>From the list of EC2 Instances in the AWS Management Console, select <strong>LabADFS</strong> and copy the Public DNS of the machine.</p></li>
<li>
<p>Establish a Remote Desktop Connection to <strong>LabADFS Dev Instance</strong> using the following information:</p>
<ul>
<li>
<strong>Connection name</strong>: <input readonly="" class="copyable-inline-input" size="20" type="text" value="WINDOWS Dev Instance">
</li>
<li>
<strong>PC Name</strong>: Enter the LabADFS public ip</li>
<li>
<strong>User name</strong>: <input readonly="" class="copyable-inline-input" size="19" type="text" value="mydomain\Stackadmin">
</li>
<li>
<strong>Password</strong>: <input readonly="" class="copyable-inline-input" size="17" type="text" value="12#soupBUBBLEblue">
</li>
</ul>
</li>
</ol>
<p>If you need detailed directions, scroll down to <a href="#step8">Connecting to your Microsoft Windows EC2 Instance</a> in the Appendix at the end of this guide.</p>

<h2 id="step4">Task 2: Configure IIS</h2>

<p>In this lab, Windows IIS will host a login page to simulate the typical enterprise experience when logging into the AWS Management Console in a federated environment.</p>

<h3>Task 2.1: Create a Self-signed certificate</h3>

<p>In order to create a secure login page, you first need to create a certificate.</p>
<ol start="5">
<li><p>Click on the <strong>Start button</strong>.</p></li>
<li><p>Click on the search icon (top right corner)</p></li>
<li><p>Start typing <input readonly="" class="copyable-inline-input" size="4" type="text" value="inet">.</p></li>
<li><p>Click on the <strong>IIS Manager</strong> icon that appears on the list.</p></li>
<li><p>Under <strong>Connections</strong> in the left-hand side, click on the hostname.  It should look similar to: <strong>WIN-xxxxxx</strong>.</p></li>
<li><p>You may get a pop-up asking to get started with "Microsoft Web Platform".  If so, check <strong>Do not show this message</strong> and click <strong>No</strong>.</p></li>
<li><p>In the <strong>Features View</strong> section, double-click on <strong>Server Certificates</strong>.</p></li>
<li><p>In the <strong>Actions panel</strong> on the right-hand side, click on <strong>Create Self-Signed Certificate...</strong></p></li>
<li><p>For <strong>Specify a friendly name for the certificate</strong>, enter <input readonly="" class="copyable-inline-input" size="8" type="text" value="adfscert">.</p></li>
<li><p>Click <strong>OK</strong>.</p></li>
</ol>
<p>You should now see the certificate listed under <strong>Server Certificates</strong>.</p>

<p><strong>Note:</strong> Do not close the IIS manager. You will need it for the next step.</p>

<h3>Task 2.2: Update bindings to enable HTTPS</h3>

<p>Now that you have created a certificate, you can enable HTTPS to make your login webpage secure.</p>
<ol start="15">
<li><p>In the <strong>Connections</strong> panel on the left-hand side, expand the level under the Hostname.  It should look similar to <strong>WIN-xxxxxx</strong>.</p></li>
<li><p>Expand the <strong>Sites</strong> folder.</p></li>
<li><p>Click on <strong>Default Web Site</strong>.</p></li>
<li><p>In the <strong>Actions</strong> panel on the right, click on <strong>Bindings</strong>.</p></li>
<li><p>In the <strong>Site Bindings</strong> window, click on the <strong>Add...</strong> button.</p></li>
<li><p>For <strong>Type</strong> select <strong>https</strong>.</p></li>
<li><p>Under <strong>SSL Certificate</strong>, select the <strong>adfscert</strong> certificate from the drop-down.</p></li>
<li><p>Click the <strong>OK</strong> button.</p></li>
<li><p>Click the <strong>Close</strong> button.</p></li>
<li><p><strong>Close</strong> IIS manager window.</p></li>
</ol>
<h2 id="step5">Task 3: Set up Active Directory</h2>

<p>An Active Directory has already been set up for you.  However, it is currently empty.  In order to log in, you will need to create some users and groups.</p>

<h3>Task 3.1: Create the AD groups</h3>

<p>First, create the two groups.</p>
<ol start="25">
<li><p>Open the <strong>Windows PowerShell</strong> by clicking the icon on the task bar at the bottom of the screen.</p></li>
<li><p>Run the following PowerShell commands:</p></li>
</ol><pre class="highlight plaintext"><code>New-ADGroup AWS-Production -GroupScope Global -GroupCategory Security
</code><button class="button button--copy js-copy-button-0"><i class="fa fa-clipboard"></i></button></pre><pre class="highlight plaintext"><code>New-ADGroup AWS-Dev -GroupScope Global -GroupCategory Security
</code><button class="button button--copy js-copy-button-1"><i class="fa fa-clipboard"></i></button></pre>
<p>The <strong>AWS-Production</strong> group will eventually grant its members permission to make changes on the EC2 console.  The <strong>AWS-Dev</strong> group will eventually grant its members permission to make changes on the CloudBuild screen.</p>

<h3>Task 3.2: Create the AD users</h3>

<p>Next, create some users.</p>
<ol start="27">
<li>Create the user <strong>Bob</strong> by running the following command:</li>
</ol><pre class="highlight plaintext"><code>New-ADUser -Name Bob -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString 'Qw1kl@bs' -AsPlainText -Force) -EmailAddress 'bob@mydomain.local' -Enabled $true -UserPrincipalName bob@mydomain.local
</code><button class="button button--copy js-copy-button-2"><i class="fa fa-clipboard"></i></button></pre><ol start="28">
<li>Add the user <strong>Bob</strong> to ADFS-Dev:</li>
</ol><pre class="highlight plaintext"><code>Add-ADGroupMember -Identity AWS-Dev -Members bob
</code><button class="button button--copy js-copy-button-3"><i class="fa fa-clipboard"></i></button></pre><ol start="29">
<li>Add the user <strong>Bob</strong> to ADFS-Production:</li>
</ol><pre class="highlight plaintext"><code>Add-ADGroupMember -Identity AWS-Production -Members bob
</code><button class="button button--copy js-copy-button-4"><i class="fa fa-clipboard"></i></button></pre>
<p>You now have a new user "Bob" who is a member of both the <strong>AWS-Dev</strong> and <strong>AWS-Production</strong> groups.</p>
<ol start="30">
<li>Create the <strong>ADFSSVC service account</strong>:</li>
</ol><pre class="highlight plaintext"><code>New-ADUser -Name ADFSSVC -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString 'munLv6SotedrANiSegut' -AsPlainText -Force) -Enabled $true -UserPrincipalName adfssvc@mydomain.local -Description 'created AD FS service account'
</code><button class="button button--copy js-copy-button-5"><i class="fa fa-clipboard"></i></button></pre>
<p>This is the service account that will be used by AD FS to authenticate against the domain.</p>
<ol start="31">
<li>You can now close PowerShell.</li>
</ol>
<h3>Task 3.4: Configure the AD FS server</h3>

<p>Now that you have created the certificate, the groups, and the users, you need to add them to the AD FS server.</p>
<ol start="32">
<li><p>Click on <strong>Start Menu</strong>.</p></li>
<li><p>Click on <strong>Server Manager</strong> icon.</p></li>
<li><p>At the top, click on the <strong>Notifications</strong> icon, that has a warning icon.</p></li>
<li><p>On the <strong>Post-deployment Configuration pop-up</strong>, click on <strong>Configure the federation service on this server.</strong>.</p></li>
<li><p>Select: <strong>Create the first federation server in a federation farm</strong>.</p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Ensure that the account listed is <strong>mydomain\Stackadmin</strong> and click the <strong>Next</strong> button.</p></li>
<li><p>For <strong>SSL Certificate</strong>, select the certificate you created previously.  It should look similar to <strong>WIN-xxxxxx</strong>.</p></li>
<li><p>For Federation Service Display Name, enter: <input readonly="" class="copyable-inline-input" size="9" type="text" value="Lab AD FS"></p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>You may see a <strong>Group Managed Service accounts are not available...</strong> banner.  Dismiss it by clicking on the <strong>X</strong> button.</p></li>
<li><p>Click on gray <strong>Select</strong> button.</p></li>
<li><p>In the <strong>Select user or service account</strong>, in the <strong>Enter object name...</strong> field, type: <input readonly="" class="copyable-inline-input" size="7" type="text" value="adfssvc"></p></li>
<li><p>Click on the <strong>Check names</strong> button.</p></li>
</ol>
<p>This should result in the check returning: ADFSSVC (<a href="mailto:adfssvc@mydomain.local" target="_blank">adfssvc@mydomain.local</a>).</p>
<ol start="46">
<li><p>Click the <strong>OK</strong> button.</p></li>
<li><p>Make sure <strong>Use an existing domain user account or group Managed Service Account</strong> is checked.  For the <strong>Account Password</strong>, enter: <input readonly="" class="copyable-inline-input" size="20" type="text" value="munLv6SotedrANiSegut"></p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Make sure the <strong>Create a database on this server using Windows Internal Database</strong> is selected.</p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Review your settings and then click the <strong>Next</strong> button.</p></li>
<li><p>Click the <strong>Configure</strong> button.</p></li>
</ol>
<h3>Task 3.5: Resolve the error</h3>

<p>At this point, you will likely get an error that says "An error occurred during the attempt to set the SPN for the specified service account..." This is a known issue and can be resolved as follows:</p>
<ol start="53">
<li><p>Click on the <strong>Close</strong> button.</p></li>
<li><p>Open the <strong>Windows PowerShell</strong> by clicking the icon on the task bar at the bottom of the screen.</p></li>
<li><p>Paste the following command:</p></li>
</ol><pre class="highlight plaintext"><code>setspn -a host/localhost adfssvc
</code><button class="button button--copy js-copy-button-6"><i class="fa fa-clipboard"></i></button></pre>
<p>This should result in the following success message:</p>
<pre class="highlight plaintext"><code>Checking domain DC=mydomain,DC=local
Registering ServicePrincipalNames for CN=ADFSSVC,CN=Users,DC=mydomain,DC=local
        host/localhost
Updated object
</code><button class="button button--copy js-copy-button-7"><i class="fa fa-clipboard"></i></button></pre>
<h3>Task 3.6: Obtain the SAML Metadata</h3>

<p>In order to establish the Windows machine as a trusted Identity Provider, you need to get configuration information from it.  This information is stored in file called <strong>FederationMetadata.xml</strong>.</p>
<ol start="56">
<li>Open a web browser on your <strong>local computer</strong>.</li>
</ol>
<p><strong>Note:</strong> Do not open a browser in your RDP session.</p>
<ol start="57">
<li>Navigate to: <input readonly="" class="copyable-inline-input" size="77" type="text" value="https://<LabADFS public ip>/FederationMetadata/2007-06/FederationMetadata.xml">
</li>
</ol>
<p><strong>Note:</strong> Replace <input readonly="" class="copyable-inline-input" size="19" type="text" value="<LabADFS public ip>"> with the Public IP you previously made a copy of.</p>
<ol start="58">
<li>You will likely get an error message similar to "Your connection is not secure" or "Your connection is not private". This is because you are using a self-signed certificate, and should not be a cause for alarm.</li>
</ol>
<p>Depending on the browser, you may need to click on <strong>Advanced</strong> to proceed for Chrome, <strong>Add an exception</strong> for Firefox, or <strong>Continue to this website (not recommended)</strong> for IE.</p>
<ol start="59">
<li>Save the <strong>FederationMetadata.xml</strong> file locally on your machine.  You will need this file later to proceed.</li>
</ol>
<p><strong>Note:</strong> Do not attempt to copy and paste the content manually.</p>

<h3>Task 3.7: Create an Identity Provider</h3>

<p>Now that you have the <strong>FederationMetadata.xml</strong> file, you can import it to AWS and establish the Windows machine as a trusted Identity Provider.</p>
<ol start="60">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>IAM</strong>.</p></li>
<li><p>On the left-hand side, select <strong>Identity providers</strong>.</p></li>
<li><p>Click on <strong>Create Provider</strong>.</p></li>
<li><p>For <strong>Provider Type</strong>, click on <strong>Choose a provider type</strong>.</p></li>
<li><p>Choose <strong>SAML</strong>.</p></li>
<li><p>For the <strong>Provider Name</strong> enter: <input readonly="" class="copyable-inline-input" size="7" type="text" value="LabSAML"></p></li>
<li><p>Click on <strong>Choose File</strong> and select the <strong>FederationMetadata.xml</strong> you previously saved.</p></li>
<li><p>Click on the <strong>Next Step</strong> button.</p></li>
<li><p>Verify the information and click the <strong>Create</strong> button.</p></li>
<li><p>Click on the Provider and copy down the ARN. You will use this information later.</p></li>
</ol>
<p>Next, create IAM roles that match up to your AD groups and assign them the desired level of permissions.</p>

<h3>Task 3.8: Create the ADFS-Production role</h3>
<ol start="70">
<li><p>In the <strong>IAM Console</strong>, on the left-hand side, click on <strong>Roles</strong>.</p></li>
<li><p>Click on <strong>Create role</strong>.</p></li>
<li><p>Under <strong>Select type of trusted entity</strong>, select <strong>SAML 2.0 federation</strong>.</p></li>
<li><p>For SAML provider, choose <strong>LabSAML</strong>.</p></li>
<li><p>Select the <strong>Allow programmatic and AWS Management Console access</strong> radio button.</p></li>
<li><p>Click the <strong>Next: Permissions</strong> button.</p></li>
<li><p>In the search bar, type <input readonly="" class="copyable-inline-input" size="19" type="text" value="AmazonEC2FullAccess"></p></li>
</ol>
<p>This set of permissions will give you access to view and make changes to AWS EC2 console.</p>
<ol start="77">
<li><p>Select <strong>AmazonEC2FullAccess</strong> from the list.</p></li>
<li><p>Click the <strong>Next: Tags</strong> button.</p></li>
<li><p>Click the <strong>Next: Review</strong> button.</p></li>
<li><p>For Role name, enter <input readonly="" class="copyable-inline-input" size="15" type="text" value="ADFS-Production"></p></li>
<li><p>For Role description, enter <input readonly="" class="copyable-inline-input" size="25" type="text" value="Lab AD FS role Production"></p></li>
<li><p>Click the <strong>Create role</strong> button.</p></li>
</ol>
<h3>Task 3.9: Create the ADFS-Dev Role</h3>
<ol start="83">
<li><p>Click on the <strong>Create role</strong> button.</p></li>
<li><p>Under <strong>Select Type of Trusted identity</strong>, select <strong>SAML 2.0 federation</strong>.</p></li>
<li><p>For SAML provider, choose <strong>LabSAML</strong>.</p></li>
<li><p>Select the <strong>Allow programmatic and AWS Management Console access</strong> radio button.</p></li>
<li><p>Click the <strong>Next: Permissions</strong> button.</p></li>
<li><p>For Permissions in the search bar, type <input readonly="" class="copyable-inline-input" size="23" type="text" value="AWSCodeBuildAdminAccess"></p></li>
</ol>
<p>This set of permissions will give you access to view and make changes to AWS CloudBuild console.</p>
<ol start="89">
<li><p>Select <strong>AWSCodeBuildAdminAccess</strong>.</p></li>
<li><p>Click the <strong>Next: Tags</strong> button.</p></li>
<li><p>Click the <strong>Next: Review</strong> button.</p></li>
<li><p>For the <strong>Role name</strong>, enter <input readonly="" class="copyable-inline-input" size="8" type="text" value="ADFS-Dev"></p></li>
<li><p>For the <strong>Role description</strong>, enter <input readonly="" class="copyable-inline-input" size="18" type="text" value="Lab AD FS role Dev"></p></li>
<li><p>Click the <strong>Create role</strong>.</p></li>
</ol>
<h3>Task 3.10: Configure AWS as a Trusted Relying party</h3>

<p>AWS Management Console creates a <strong>saml-metadata.xml</strong> file that needs to be imported to AD FS to add AWS as a Trusted Relying Party.</p>
<ol start="95">
<li><p>Open your RDP console.</p></li>
<li><p>Click on <strong>Start Button</strong>.</p></li>
<li><p>Click on <strong>Administrative Tools</strong>.</p></li>
<li><p>Double click on <strong>AD FS Management</strong>.</p></li>
</ol>
<p><strong>Note:</strong> If prompted, in the User Account Control dialog box, click <strong>Yes</strong>.</p>
<ol start="99">
<li>On the right-hand side, click <strong>Add Relying Party Trust...</strong>.</li>
</ol>
<p>This will open the <strong>Add Relying Trust Wizard</strong>.</p>
<ol start="100">
<li><p>Click on the <strong>Start</strong> button.</p></li>
<li><p>Choose the <strong>Import data about the relating party published online</strong> radio button.</p></li>
<li><p>Copy and paste the following into the field: <input readonly="" class="copyable-inline-input" size="54" type="text" value="https://signin.aws.amazon.com/static/saml-metadata.xml"></p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>For the <strong>Display name</strong>, enter <input readonly="" class="copyable-inline-input" size="19" type="text" value="Amazon Web Services"></p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Ensure that <strong>I do not want to configure multi-factor authentication settings for this relying party trust at this time</strong> is selected, and then click the <strong>Next</strong> button.</p></li>
<li><p>Ensure the <strong>Permit all users to access this relying party</strong> radio button is selected.</p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Click the <strong>Next</strong> button again.</p></li>
<li><p>Ensure <strong>Open the Edit Claim Rules dialog for this relying party trust when the wizard closes</strong> checkbox is selected.</p></li>
<li><p>Click <strong>Close</strong>.</p></li>
</ol>
<h2 id="step6">Task 4: Configure the Claim Rules</h2>

<p>Claim Rules modify the SAML authentication response to include specific information needed by AWS to determine which role the user is logging into.  In this case, you will be sending the user's name, e-mail address, and their allowed roles.</p>

<h3>Task 4.1: Configure Claim Rule 1:</h3>
<ol start="112">
<li><p>Ensure the window reads <strong>Edit Claim Rules for Amazon Web Services</strong>.</p></li>
<li><p>Under the <strong>Issuance Transform Rules</strong> tab, click <strong>Add Rule</strong> button.</p></li>
<li><p>In the <strong>Claim rule template</strong> drop-down list, choose <strong>Transform an Incoming Claim</strong> from the dropdown.</p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>Enter the following values:</p></li>
</ol><ul>
<li>Claim rule name: <input readonly="" class="copyable-inline-input" size="6" type="text" value="NameId">
</li>
<li>Incoming claim type: <input readonly="" class="copyable-inline-input" size="20" type="text" value="Windows account name">
</li>
<li>Outgoing claim type: <input readonly="" class="copyable-inline-input" size="7" type="text" value="Name ID">
</li>
<li>Outgoing name ID format: <input readonly="" class="copyable-inline-input" size="21" type="text" value="Persistent Identifier">
</li>
</ul><ol start="117">
<li><p>Select <strong>Pass through all claim values</strong> radio button.</p></li>
<li><p>Click the <strong>Finish</strong> button.</p></li>
</ol>
<p><strong>Note:</strong> Do not close the <strong>Edit Claim Rules window</strong>.</p>

<h3>Task 4.2: Configure Claim Rule 2</h3>
<ol start="119">
<li><p>Under the <strong>Issuance Transform Rules</strong> tab, click <strong>Add Rule</strong> button.</p></li>
<li><p>Choose <strong>Send LDAP attributes as Claims</strong> and click the <strong>Next</strong> button.</p></li>
<li><p>Enter the following values:</p></li>
</ol><ul>
<li>Claim rule name: <input readonly="" class="copyable-inline-input" size="15" type="text" value="RoleSessionName">
</li>
<li>Attribute store: <input readonly="" class="copyable-inline-input" size="16" type="text" value="Active Directory">
</li>
<li>LDAP Attribute: <input readonly="" class="copyable-inline-input" size="16" type="text" value="E-Mail-Addresses">
</li>
<li>Outgoing Claim type: <input readonly="" class="copyable-inline-input" size="54" type="text" value="https://aws.amazon.com/SAML/Attributes/RoleSessionName">
</li>
</ul><ol start="122">
<li>Click the <strong>Finish</strong> button.</li>
</ol>
<h3>Task 4.3: Configure Claim Rule 3</h3>
<ol start="123">
<li><p>Click the <strong>Add Rule</strong> button.</p></li>
<li><p>In the <strong>Claim rule template</strong> drop-down list, select <strong>Send Claims Using a Custom Rule</strong> and click the <strong>Next</strong> button.</p></li>
<li><p>For Claim rule name, enter <input readonly="" class="copyable-inline-input" size="13" type="text" value="Get AD Groups"></p></li>
<li><p>In the Custom rule field, copy and paste the following:</p></li>
</ol><pre class="highlight plaintext"><code>c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"] =&gt; add(store = "Active Directory", types = ("http://temp/variable"), query = ";tokenGroups;{0}", param = c.Value);
</code><button class="button button--copy js-copy-button-8"><i class="fa fa-clipboard"></i></button></pre><ol start="127">
<li>Click the <strong>Finish</strong> button.</li>
</ol>
<h3>Task 4.4: Configure Claim Rule 4</h3>
<ol start="128">
<li><p>Click the <strong>Add Rule</strong> button.</p></li>
<li><p>Select <strong>Send Claims Using a Custom Rule</strong>.</p></li>
<li><p>Click the <strong>Next</strong> button.</p></li>
<li><p>For <strong>Claim rule name</strong>, enter <input readonly="" class="copyable-inline-input" size="5" type="text" value="Roles"></p></li>
<li><p>In the following script replace the <input readonly="" class="copyable-inline-input" size="22" type="text" value="<ARN of SAML provider>"> and <input readonly="" class="copyable-inline-input" size="12" type="text" value="<Account ID>"> with the corresponding values from the ARN's copied in previous steps:</p></li>
</ol>
<p><strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="22" type="text" value="<ARN of SAML provider>"> with the value you copied in a previous step.
<strong>Replace</strong> <input readonly="" class="copyable-inline-input" size="12" type="text" value="<Account ID>"> value provided on the <strong>Connection Details</strong> section in Qwiklabs.</p>
<pre class="highlight plaintext"><code>c:[Type == "http://temp/variable", Value =~ "(?i)^AWS-"]
 =&gt; issue(Type = "https://aws.amazon.com/SAML/Attributes/Role", Value = RegExReplace(c.Value, "AWS-", "&lt;ARN of SAML provider&gt;,arn:aws:iam::&lt;Account ID&gt;:role/ADFS-"));
</code><button class="button button--copy js-copy-button-9"><i class="fa fa-clipboard"></i></button></pre><ol start="133">
<li><p>Click the <strong>Finish</strong> button.</p></li>
<li><p>Click the <strong>Apply</strong> button.</p></li>
<li><p>Close the <strong>Claim Rules</strong> window.</p></li>
</ol>
<h2 id="step7">Task 5: Testing</h2>
<ol start="136">
<li>In your web browser on your local machine, navigate to the following URL: <input readonly="" class="copyable-inline-input" size="60" type="text" value="https://<LabADFS public ipp>/adfs/ls/IdpInitiatedSignOn.aspx">
</li>
</ol>
<p>You should see the AD FS sign on page.</p>
<ol start="137">
<li><p>Select <strong>Sign in to one of the following sites</strong>.</p></li>
<li><p>Click the <strong>Sign In</strong> button.</p></li>
<li><p>Enter in the following credentials:</p></li>
</ol>
<p>Email: <input readonly="" class="copyable-inline-input" size="18" type="text" value="bob@mydomain.local">
Password: <input readonly="" class="copyable-inline-input" size="8" type="text" value="Qw1kl@bs"></p>
<ol start="140">
<li><p>Click <strong>Sign in</strong>.</p></li>
<li><p>You should see <strong>ADFS-Production</strong> and <strong>ADFS-Dev</strong> roles on the list.</p></li>
<li><p>Select <strong>ADFS-Production</strong> as the role that user <strong>Bob</strong> will assume.</p></li>
<li><p>Click the <strong>Sign in</strong> button.</p></li>
</ol>
<p>This will open up the AWS console.</p>
<ol start="144">
<li>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>CloudFormation</strong>.</li>
</ol>
<p>This will result in an <strong>Error</strong> message that says it is "Unable to list data..."</p>
<ol start="145">
<li><p>In the AWS Management Console, under the <strong>Services</strong> menu, click <strong>EC2</strong>.</p></li>
<li><p>In the navigation pane, click <strong>Instances</strong>.</p></li>
</ol>
<p>You should be able to view the running EC2 instances though.</p>
<ol start="147">
<li><p>Sign out of the AWS Console.</p></li>
<li><p>In your web browser on your local machine, navigate to the following URL: <input readonly="" class="copyable-inline-input" size="59" type="text" value="https://<LabADFS public ip>/adfs/ls/IdpInitiatedSignOn.aspx"></p></li>
<li><p>Sign in again, but this time pick the <strong>ADFS-Dev</strong>.</p></li>
<li><p>Repeat your steps visiting the CodeBuild console and the EC2 console and note the differences in permissions for this role.</p></li>
<li><p>Sign out of the AWS Console.</p></li>
</ol>


<h2 id="step8">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>



<h2 id="step9">Appendix</h2>

<h2 id="step10">Connecting to your Microsoft Windows EC2 Instance</h2>

<p>Access to a Microsoft Windows EC2 instance requires a secure connection using an RDP client. The following directions walk you through the process of connecting to your Windows EC2 instance.</p>

<p>Choose one of the following guides:</p>
<ul>
<li>Connecting from a Windows Machine</li>
<li>Connecting from a macOS Machine</li>
</ul>
<h3>Connecting from a Windows Machine</h3>
<ol start="152">
<li>Open the Remote Desktop Connection application on your computer.</li>
</ol><ul>
<li>On Windows 7, click the <strong>Start</strong> icon, and in the <strong>Search programs and files</strong> textbox, type <input readonly="" class="copyable-inline-input" size="25" type="text" value="Remote Desktop Connection">. Click on the application when it appears in the <strong>Programs</strong> list.</li>
<li>On Windows 8, activate the Charms menu by moving the cursor into the lower right corner of the screen, and click the <strong>Search</strong> icon. Type in <input readonly="" class="copyable-inline-input" size="25" type="text" value="Remote Desktop Connection">. Click the application when it appears in the <em>Programs</em> list.</li>
<li>On Windows 10, click the <strong>Start</strong> icon, and click the <strong>Search</strong> icon. Type in <input readonly="" class="copyable-inline-input" size="25" type="text" value="Remote Desktop Connection">. Click the application when it appears in the <em>Programs</em> list.</li>
</ul><ol start="153">
<li><p>In Remote Desktop Connection, in the <strong>Computer</strong> field, paste the Public DNS address of your Windows instance that you copied.</p></li>
<li><p>Click <strong>Connect</strong>.</p></li>
<li><p>Remote Desktop Connection will prompt you with a Login dialog asking for your username and password. By default, the application will use your current Windows username and domain. To change this, click <strong>Use another account</strong>.</p></li>
</ol>
<p><strong>Note:</strong> On Windows 10, click <strong>More Choices</strong> before selecting <strong>Use a different account</strong>.</p>
<ol start="156">
<li>For your login credentials, use the following values:</li>
</ol><ul>
<li>
<strong>User name</strong>: <input readonly="" class="copyable-inline-input" size="19" type="text" value="mydomain\Stackadmin">
</li>
<li>
<strong>Password</strong>: <input readonly="" class="copyable-inline-input" size="17" type="text" value="12#soupBUBBLEblue">
</li>
</ul><ol start="157">
<li>To connect to your instance, click <strong>OK</strong>. If you receive a prompt that the certificate used to verify the connection was not a known, trusted root certificate, click <strong>Yes</strong>.</li>
</ol>
<p><strong>Result</strong></p>

<p>Your connection to your remote instance should start momentarily. When lab instructions in subsequent sections require a command window, open or use a PowerShell window.</p>

<p>To continue this lab, proceed to <a href="#step2">Task 2</a>.</p>

<h3>Connecting from a macOS Machine</h3>
<ol start="158">
<li>Install Microsoft Remote Desktop if it is not already installed.</li>
</ol><ul>
<li>From the Dock, launch <strong>App store</strong>.</li>
<li>Search for the following string: <input readonly="" class="copyable-inline-input" size="24" type="text" value="Microsoft Remote Desktop">
</li>
<li>Click <strong>Install</strong>.</li>
</ul><ol start="159">
<li><p>To open <strong>Microsoft Remote Desktop</strong>, on the Dock, click <strong>Launchpad</strong>. Then click <strong>Microsoft Remote Desktop</strong>.</p></li>
<li><p>To create a new connection, click <strong>New</strong>.</p></li>
</ol>
<p>Use the following values:</p>
<ul>
<li>
<strong>Connection name</strong>: <input readonly="" class="copyable-inline-input" size="20" type="text" value="WINDOWS Dev Instance">
</li>
<li>
<strong>PC Name</strong>: Paste in the Public DNS address of your Windows Server instance.</li>
<li>
<strong>User name</strong>: <input readonly="" class="copyable-inline-input" size="19" type="text" value="mydomain\Stackadmin">
</li>
<li>
<strong>Password</strong>: <input readonly="" class="copyable-inline-input" size="17" type="text" value="12#soupBUBBLEblue">
</li>
</ul><ol start="161">
<li><p>Close the <em>Edit Remote Desktops</em> window by clicking on the button on the top left corner.</p></li>
<li><p>In the <strong>Microsoft Remote Desktop</strong> window, select the connection titled <strong>WINDOWS Dev Instance</strong> and click <strong>Start</strong>.</p></li>
<li><p>In the <strong>Verify Certificate</strong> dialog, click <strong>Continue</strong> to complete the connection.</p></li>
</ol>
<p><strong>Result</strong></p>

<p>Your connection to your remote instance should start momentarily. When lab instructions in subsequent sections require a command window, open or use a PowerShell window.</p>

<p>To continue this lab, proceed to <a href="#step2">Task 2</a>.</p>

</div>