<div class="js-markdown-instructions lab-content__markdown markdown-lab-instructions no-select" id="markdown-lab-instructions">

<h1>Lab 7 - Using AWS Service Catalog</h1>

<p><strong>Overview</strong></p>

<p>Security can be an operational burden if not done in an automated and reproducible manner. Regulated workloads have different settings that need to be configured to meet compliance requirements. Ideally, product owners should be able to launch apps when they need them, and security administrators should ensure that the compliance standards are met and the underlying resources for a product are safe. AWS CloudFormation allows for reproducibility, but fails to protect against a product owner from making changes to the template. With AWS Service Catalog, security administrators can author a CloudFormation template and grant permissions to allow an end user to only launch the template, without giving the end user, access to all the underlying resources. You can thus centrally manage catalogs of AWS services and products and achieve consistent governance and meet your compliance requirements.</p>

<p>As a part of the lab set up, you are provided with an AWS IAM user called ServiceCatalogAppUser which acts as the end user for Service Catalog, a Service Catalog portfolio called Account Provisioning with a product, Base-Networking, and IAM roles needed to launch products.</p>

<p>In this lab, you will:</p>
<ul>
<li>Sign in as the end user, ServiceCatalogAppUser. This user has only end user permissions for AWS Service Catalog. The IAM user ServiceCatalogAppUser can only launch a product from a portfolio and does not have permissions to any other AWS services. This restricts the access to underlying AWS resources created by the CloudFormation template of a product.</li>
<li>Launch the product, Base-Networking, provided in the Account Provisioning portfolio. This product creates the networking infrastructure needed for your apps.</li>
<li>Sign in as awsstudent IAM user to create a portfolio and add products to the portfolio. The awsstudent IAM user acts as an administrator for Service Catalog and has full permissions for Service Catalog.</li>
<li>Launch products from the new portfolio signed in as the ServiceCatalogAppUser.</li>
</ul>
<p><strong>Objectives</strong></p>

<p>After completing this lab, you will be able to:</p>
<ul>
<li>Create a portfolio in Service Catalog</li>
<li>Create and add products to your portfolio</li>
<li>Add launch constraints to your products</li>
<li>Launch your products using Service Catalog</li>
</ul>
<p><strong>Duration</strong></p>

<p>This lab requires approximately <strong>90 minutes</strong> to complete.</p>

<h2 id="step1">Task 1: Sign In to the AWS Management Console as the ServiceCatalogAppUser IAM User</h2>

<p><i class="fas fa-exclamation-triangle"></i> These sign-in instructions are different to normal because you will login as <em>ServiceCatalogAppUser</em>.</p>
<ol start="1">
<li><p>Click <span style="background-color:#34A853;font-weight:bold;font-size:90%;color:white;border-radius:2px;padding-left:10px;padding-right:10px;padding-top:3px;padding-bottom:3px;">Start Lab</span> to launch the lab.</p></li>
<li><p>Open a browser and paste the <strong>EndUserSignPage</strong> URL shown to the left of the instructions you are currently reading.</p></li>
<li><p>Sign in to the AWS Management Console using the following steps:</p></li>
</ol><ul>
<li>For <strong>Account ID or alias</strong>, paste the AWS Account number shown to the left of the instructions you are currently reading.</li>
<li>For <strong>IAM user name</strong>, type: <input readonly="" class="copyable-inline-input" size="21" type="text" value="ServiceCatalogAppUser">
</li>
<li>For <strong>Password</strong>, paste the <strong>EndUserPassword</strong> shown to the left of these instructions.</li>
<li>Click <strong>Sign In</strong>.</li>
</ul>
<p>You are now signed in to the AWS Management Console as the <strong>ServiceCatalogAppUser</strong> end user.</p>

<h2 id="step2">Task 2: Launch a Product from the Account Provisioning Portfolio</h2>

<p>In this section, you will launch the Base-Networking product from the Account Provisioning portfolio. The Account Provisioning portfolio and the Base-Networking product were created as part of the lab set up. The Base-Networking product provisions the networking infrastructure such as the VPC, internet gateway, subnets and route table. The networking infrastructure will be used by the game apps you will install in a subsequent section of this lab.</p>
<ol start="4">
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Service Catalog</strong> to open the Service Catalog dashboard.</p></li>
<li><p>In the left side navigation menu, click <strong>Products list</strong>. You should see the <em>Base-Networking</em> product in the products list.</p></li>
</ol>
<p><strong>Important:</strong> If you don’t see the Base-Networking product, verify that the region displayed on the top, right-hand corner of your console is the same as the region shown to the left of the instructions you are currently reading.</p>
<ol start="6">
<li><p>Click the hyperlink for <strong>Base-Networking</strong> to open the product details. You should see the details of the Base-Networking product. Observe that the Base-Networking product belongs to the <em>Account Provisioning</em> portfolio.</p></li>
<li><p>To deploy the Base-Networking product, click <strong>LAUNCH PRODUCT</strong>.</p></li>
<li><p>On the <strong>Launch - Base-Networking</strong> page, for <strong>Name</strong>, type <input readonly="" class="copyable-inline-input" size="15" type="text" value="Base-Networking"></p></li>
<li><p>For <strong>Version</strong>, select the <strong>Base-Networking-1</strong> version by clicking the radio button.</p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>On the <strong>Parameters</strong> page, keep the default values for the parameters and click <strong>NEXT</strong>.</p></li>
<li><p>Skip the <strong>TagOptions</strong> page and click <strong>NEXT</strong>.</p></li>
<li><p>Skip the <strong>Notifications</strong> page and click <strong>NEXT</strong>.</p></li>
<li><p>On the <strong>Review</strong> page, scroll down and click <strong>LAUNCH</strong>.</p></li>
</ol>
<p>This will deploy the CloudFormation template and provision the resources specified in the Base-Networking template. In the <strong>Events</strong> section, observe that the <strong>Status</strong> is shown as <strong>In Progress</strong>. It will take 4-5 minutes for the stack to finish deploying.</p>

<p><i class="fas fa-comment"></i> You can ignore the warning <em>You are not authorized to perform that action</em>.</p>
<ol start="15">
<li>Click the <i class="fas fa-sync"></i> refresh button in the <strong>Events</strong> section. In a few minutes, you will notice that the Status has changed to <strong>Succeeded</strong>. In the <strong>Outputs</strong> section, observe the AWS resources that were created as a part of the Base-Networking product.</li>
</ol>
<p>You have successfully launched a product to deploy the networking infrastructure for the game apps.</p>

<h2 id="step3">Task 3: Create a portfolio and add products</h2>

<p>In this section, you will create a portfolio for game apps. Within the portfolio, you will create two products with CloudFormation templates for deploying the SkiFree and AlgesEscapade game apps. You will be provided with the CloudFormation templates, App1-SkiFree.template and App2-AlgesEscapade.template, for the game apps. The App1.yaml and App2.yaml templates contain the AWS resources needed to install the SkiFree and AlgesEscapade apps on an Amazon EC2 instance. Then you will launch each of the products and deploy the game apps.</p>

<p>To create a portfolio and add products in Service Catalog, you need full permissions to Service Catalog. But ServiceCatalogAppUser (the IAM user that you are currently signed in as), only has end user permissions. So IAM user ServiceCatalogAppUser will not be able to create a new portfolio and add products to the portfolio. You will need to sign in to the AWS Management Console as <em>awsstudent</em> to create a new portfolio and add products.</p>
<ol start="16">
<li>Open a different browser window and to go to the sign in page of the AWS Management console using the <strong>EndUserSignPage</strong> shown to the left of these instructions.</li>
</ol>
<p><strong>Important</strong> Make sure the browser is different from the one you were using when signed as the ServiceCatalogAppUser. For example, if you used Chrome to sign in as the ServiceCatalogAppUser, make sure you either use Firefox or use the incognito mode in Chrome for the awsstudent IAM user. This will allow you to remain signed in as both ServiceCatalogAppUser and awsstudent user in two different browser windows.</p>
<ol start="17">
<li>Sign in to the AWS Management Console using the following steps:</li>
</ol><ul>
<li>For <strong>Account ID or alias</strong>, paste the AWS Account number shown to the left of the instructions you are currently reading.</li>
<li>For <strong>IAM user name</strong>, type: <input readonly="" class="copyable-inline-input" size="10" type="text" value="awsstudent">
</li>
<li>For <strong>Password</strong>, paste the <strong>Password</strong> shown to the left of these instructions. Make sure to use the password for awsstudent.</li>
<li>Click <strong>Sign In</strong>.</li>
</ul><ol start="18">
<li><p>Confirm that you are now signed in as the <strong>awsstudent</strong> user and the AWS region is same as the one for the ServiceCatalogAppUser.</p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Service Catalog</strong> to open the Service Catalog dashboard.</p></li>
<li><p>In the left side navigation menu, under <strong>Admin</strong>, click <strong>Portfolios list</strong>.</p></li>
<li><p>To create a portfolio, click <strong>CREATE PORTFOLIO</strong>.</p></li>
<li><p>For <strong>Portfolio name</strong>, type <input readonly="" class="copyable-inline-input" size="8" type="text" value="GameApps"></p></li>
<li><p>For <strong>Description</strong>, type <input readonly="" class="copyable-inline-input" size="12" type="text" value="Sample games"></p></li>
<li><p>For <strong>Owner</strong>, type <input readonly="" class="copyable-inline-input" size="13" type="text" value="Game Dev Team"></p></li>
<li><p>Click <strong>CREATE</strong>. You should see the <strong>GameApps</strong> portfolio in the portfolios list.</p></li>
<li><p>To create a product, under <strong>Admin</strong>, click <strong>Products list</strong> in the left side navigation menu.</p></li>
<li><p>Click <strong>UPLOAD NEW PRODUCT</strong>.</p></li>
<li><p>On the <strong>Upload new product</strong> page, for <strong>Product name</strong>, type <input readonly="" class="copyable-inline-input" size="7" type="text" value="SkiFree"></p></li>
<li><p>For <strong>Description</strong>, type <input readonly="" class="copyable-inline-input" size="42" type="text" value="Run away from monsters and don't hit trees"></p></li>
<li><p>For <strong>Provided by</strong>, type <input readonly="" class="copyable-inline-input" size="17" type="text" value="The game dev team"></p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>For <strong>Email contact</strong>, type <input readonly="" class="copyable-inline-input" size="17" type="text" value="games@example.com"></p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>Download <a href="https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-SISECO/v2.3.0/lab-7-servicecatalog/scripts/App1-SkiFree.template" target="_blank">App1-SkiFree.template</a> for deploying the SkiFree game app.</p></li>
<li><p>For <strong>Select template</strong>, choose the <strong>Upload a template file</strong> option.</p></li>
<li><p>Click <strong>Choose File</strong> or <strong>Browse</strong> and browse to the location where you just downloaded the CloudFormation template for the SkiFree game app and select it.</p></li>
<li><p>For <strong>Version title</strong>, type <input readonly="" class="copyable-inline-input" size="12" type="text" value="SkiFree-v1.0"></p></li>
<li><p>For <strong>Description</strong>, type <input readonly="" class="copyable-inline-input" size="42" type="text" value="Run away from monsters and don't hit trees"></p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>On the <strong>Review</strong> page, click <strong>CREATE</strong>. You should see the <strong>SkiFree</strong> product in the products list. If you don't see the product, click the refresh button.</p></li>
<li><p>Now you will create a second product for a game called AlgesEscapade using the details below. If you need step-by-step instructions, you may refer to the instructions you just followed above to create the SkiFree product. Make sure to use the details below to create the second product.</p></li>
</ol>
<p><strong>Important</strong> Make sure you choose the CloudFormation template for AlgesEscapade when creating the product.</p>
<ul>
<li>CloudFormation template: Download <a href="https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-SISECO/v2.3.0/lab-7-servicecatalog/scripts/App2-AlgesEscapade.template" target="_blank">App2-AlgesEscapade.template</a> for deploying AlgesEscapade and choose this template.</li>
<li>Product name: <input readonly="" class="copyable-inline-input" size="13" type="text" value="AlgesEscapade">
</li>
<li>Description: <input readonly="" class="copyable-inline-input" size="22" type="text" value="Get Alge down the pipe">
</li>
<li>Provided by: <input readonly="" class="copyable-inline-input" size="13" type="text" value="Game Dev Team">
</li>
<li>Email contact: <input readonly="" class="copyable-inline-input" size="17" type="text" value="games@example.com">
</li>
<li>Version title: <input readonly="" class="copyable-inline-input" size="18" type="text" value="AlgesEscapade-v1.0">
</li>
</ul><ol start="42">
<li><p>You should now see two products, SkiFree and AlgesEscapade, in the products list. You may have wait a few seconds and refresh the page, to see the products.</p></li>
<li><p>To add the products to the GamesApp portfolio, click <strong>Portfolios list</strong> in the left side navigation menu.</p></li>
<li><p>Click the <strong>GameApps</strong> hyperlink. The GamesApp portfolio should open up with its details.</p></li>
<li><p>In the <strong>Products</strong> section, click <strong>ADD PRODUCT</strong>. You should see a list of products.</p></li>
<li><p>Select the <strong>SkiFree</strong> product by clicking the radio button next to it.</p></li>
<li><p>Click <strong>ADD PRODUCT TO PORTFOLIO</strong>. You should see a success message banner at the top.</p></li>
<li><p>Again, click <strong>ADD PRODUCT</strong> to add the <strong>AlgesEscapade</strong> product.</p></li>
<li><p>Select the <strong>AlgesEscapade</strong> product by clicking the radio button next to it.</p></li>
<li><p>Click <strong>ADD PRODUCT TO PORTFOLIO</strong>. You should see a success message banner at the top.</p></li>
</ol>
<p>You should now see both the products added to the GamesApp portfolio. You may have to click <i class="fas fa-sync"></i> refresh to see the products in the <strong>Products</strong> section.</p>

<p>You have successfully created SkiFree and AlgesEscapade products and added them to the GamesApp portfolio.</p>

<h2 id="step4">Task 4: Add Launch Constraints</h2>

<p>In this section, you will add a launch constraint to each of the products you created in the previous task. The launch constraint specifies the IAM role that Service Catalog assumes when an end user launches a product.</p>
<ol start="51">
<li><p>Make sure that you are still signed in as the <strong>awsstudent</strong> IAM user.</p></li>
<li><p>Open the <strong>GamesApp</strong> portfolio, if you are not there already.</p></li>
<li><p>Scroll down to the <strong>Constraints</strong> section and expand the section.</p></li>
<li><p>Click <strong>ADD CONSTRAINTS</strong>.</p></li>
<li><p>On the <strong>Select product and type</strong> pop up screen, for <strong>Product</strong>, select <strong>AlgesEscapade</strong>.</p></li>
<li><p>For <strong>Constraint type</strong>, select <strong>Launch</strong>.</p></li>
<li><p>Click <strong>CONTINUE</strong>.</p></li>
<li><p>For <strong>IAM role</strong>, type <input readonly="" class="copyable-inline-input" size="14" type="text" value="GameLaunchRole"> and select the IAM role that appears.</p></li>
<li><p>Click <strong>SUBMIT</strong>. You should see a success banner in the Constraints section.</p></li>
<li><p>You will now add a constraint for the SkiFree product in a similar manner. You may refer to the step-by-step instructions you just followed to add a constraint. Use the details below to add a constraint for the SkiFree product.</p></li>
</ol><ul>
<li>Product: SkiFree</li>
<li>Constraint type: Launch</li>
<li>IAM role: Type <input readonly="" class="copyable-inline-input" size="14" type="text" value="GameLaunchRole"> and select the IAM role that appears.</li>
</ul>
<p>You have successfully added launch constraints for your products.</p>

<h2 id="step5">Task 5: Add Access to ServiceCatalogAppUser</h2>

<p>In this section, you will add access to the ServiceCatalogAppUser IAM user so that ServiceCatalogAppUser can access the GamesApp portfolio and the products in the portfolio.</p>
<ol start="61">
<li><p>On the <strong>Portfolio: GameApps</strong> page, scroll down to the <strong>Users, groups and roles</strong> section and expand it.</p></li>
<li><p>Click <strong>ADD USER, GROUP OR ROLE</strong>.</p></li>
<li><p>Click the <strong>Users</strong> tab.</p></li>
<li><p>Check the checkbox for <strong>ServiceCatalogAppUser</strong>.</p></li>
<li><p>Click <strong>ADD ACCESS</strong> at the bottom. You should see a success banner message.</p></li>
</ol>
<p>You have successfully added access to the ServiceCatalogAppUser IAM user. The GamesApp portfolio and the products in the portfolio are now accessible to the end user, ServiceCatalogAppUser. It is now time to deploy the products!</p>

<h2 id="step6">Task 6: Launch the Products</h2>

<p>In this section, you will sign in again as the end user, ServiceCatalogAppUser and launch the SkiFree and AlgesEscapade products. Then you will test the deployed products.</p>
<ol start="66">
<li><p>Go to the browser window where you had signed in as ServiceCatalogAppUser to the AWS Management Console in Task 1.</p></li>
<li><p>Confirm that you are signed in as the ServiceCatalogAppUser user.</p></li>
<li><p>In the <strong>AWS Management Console</strong>, on the <strong>Services</strong> menu, click <strong>Service Catalog</strong> to open the Service Catalog dashboard.</p></li>
<li><p>In the left side navigation menu, click <strong>Products list</strong>. You should see the newly added products, AlgesEscapade and SkiFree, in the list.</p></li>
<li><p>Click the <strong>AlgesEscapade</strong> hyperlink.</p></li>
<li><p>Click <strong>LAUNCH PRODUCT</strong>.</p></li>
<li><p>For <strong>Name</strong>, type <input readonly="" class="copyable-inline-input" size="13" type="text" value="AlgesEscapade"></p></li>
<li><p>For <strong>Version</strong>, select the radio button for <strong>AlgesEscapade-v1.0</strong>.</p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>On the <strong>Parameters</strong> page, for <strong>KeyName</strong>, select the key pair that appears in the drop down list.</p></li>
<li><p>Click <strong>NEXT</strong>.</p></li>
<li><p>Skip the <strong>TagOptions</strong> page and click <strong>NEXT</strong>.</p></li>
<li><p>Skip the <strong>Notifications</strong> page and click <strong>NEXT</strong>.</p></li>
<li><p>On the <strong>Review</strong> page, click <strong>LAUNCH</strong>. You should see that the Status is <strong>In Progress</strong>.</p></li>
<li><p>It takes about 4-5 minutes for the app to get deployed. You may need to click the refresh button in the <strong>Events</strong> section to see the updated status. In the meantime, you may proceed to jump ahead 4 steps to launch the SkiFree product.</p></li>
<li><p>Once the Status changes to <strong>Succeeded</strong>, you should see the output of the stack in the <strong>Outputs</strong> section.</p></li>
<li><p>In the <strong>Outputs</strong> section, copy the value of <strong>App1DNS</strong> under the <strong>Value</strong> column. This is the DNS name of the Amazon Elastic Load Balancer that sits in front of the app server for the AlgesEscapade app.</p></li>
<li><p>Open a browser tab and paste the <strong>App1DNS</strong> value you just copied and hit ENTER. You should see the AlgesEscapade game. Feel free to try the game.</p></li>
<li><p>Following similar steps as above, launch the <strong>SkiFree</strong> product using the details below.</p></li>
</ol><ul>
<li>Name: Type <input readonly="" class="copyable-inline-input" size="7" type="text" value="SkiFree">
</li>
<li>Version: Select SkiFree-v1.0</li>
<li>KeyName: Select the key pair that appears in the drop down list</li>
</ul><ol start="85">
<li><p>It takes about 4-5 minutes for the app to get deployed. You may need to click the refresh button in the <strong>Events</strong> section to see the updated status.</p></li>
<li><p>Once the Status changes to <strong>Succeeded</strong>, you should see the output of the stack in the <strong>Outputs</strong> section.</p></li>
<li><p>In the <strong>Outputs</strong> section, copy the value of <strong>App2DNS</strong> under the <strong>Value</strong> column. This is the DNS name of the Amazon Elastic Load Balancer that sits in front of the app server for the SkiFree app.</p></li>
<li><p>Open a browser tab and paste the <strong>App2DNS</strong> value you just copied and hit ENTER. You should see the SkiFree game. Feel free to try the game.</p></li>
</ol>
<h2 id="step7">Lab Complete</h2>

<p><i class="icon-flag-checkered"></i> Congratulations! You have completed the lab.</p>

<p>Click <span style=""><strong>End Lab</strong></span> at the top of this page to clean up your lab environment.</p>

</div>