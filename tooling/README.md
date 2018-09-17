# Checklist

this contains a list of things which require further reading.  checkout the repo, perform your research, and update the readme with an x in the [ ] to track your SecDevOps Research.

- [ ] Awesomeness: https://github.com/sindresorhus/awesome#security
- [ ] Testing & TDD: 
    - [ ] Gherkin / CICD:  https://blog.steamulo.com/improve-your-gitflow-with-docker-gitlab-ci-and-gherkin-60faddd39bb2
    - [ ] Cucumber: http://www.wellho.net/mouth/4382_Second-step-Cucumber-and-Gherkin-beyond-Hello-World.html
    - [ ] Terratest: https://github.com/gruntwork-io/terratest

- [ ] AWS 
    - [ ] Create Lamba functions:
        - [ ] shutting down instances
            - https://github.com/nicholasjackson/slack-bot-lex-lambda/blob/master/terraform/lambda.tf
        - [ ] Honey Lambda: https://github.com/0x4D31/honeyLambda   
        - [ ] Setting up SecDevOps bots 
            - [ ] reditbot 
            - [ ] circleci bot / deployment bot 
            - [ ] Serverless Slack Bot(s):
                - https://chatbotslife.com/write-a-serverless-slack-chat-bot-using-aws-e2d2432c380e
                - https://aws.amazon.com/blogs/aws/new-slack-integration-blueprints-for-aws-lambda/
                - https://aws.amazon.com/blogs/devops/use-slack-chatops-to-deploy-your-code-how-to-integrate-your-pipeline-in-aws-codepipeline-with-your-slack-channel/
     - [x] Cloud-Init:
            - Rerun Cloud Init 
                - Article: https://stackoverflow.com/questions/23151425/how-to-run-cloud-init-manually
                - `/usr/bin/cloud-init -d init`
            - Examples: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
            
    - [x] Inspector Security Agents:
            - [x] Simple cloud-init script to register the asset w/ the service:
                `wget https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install -P /tmp/ && /tmp/install`    
            - CICD deployment w/ boto triggered scans: https://www.we45.com/blog/how-to-amazon-inspector-with-terraform
            - Supported Regions: https://docs.aws.amazon.com/inspector/latest/userguide/inspector_supported_os_regions.html
            - Rules & Packages: 
                - ARN Rules Index: https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rules-arns.html
                - Explained: https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rule-packages.html

- [ ] CICD:
    - [ ] CICD Pipeline:                    https://dev.to/kylegalbraith/creating-a-cicd-pipeline-with-a-git-repository-in-30-seconds-using-terraform-and-aws-2424
    - [ ] Monitoring:                       https://github.com/cloudposse/terraform-aws-cloudtrail-cloudwatch-alarms 
    - [ ] Beanstalk:                        https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment
    - [ ] Slack / AWS CICD Test instances   https://dev.solita.fi/2018/08/16/easy-test-deployments-round-two.html
    - [ ] CICD w/ Docker:                   https://medium.com/soosap/continuous-deployment-w-docker-aws-and-circle-ci-82f4b14256cc
    - [ ] Rolling Deploys w/ Terraform:     https://robmorgan.id.au/posts/rolling-deploys-on-aws-using-terraform/
    - [ ] Automated Security Testing:       https://medium.com/@cossacklabs/automated-security-testing-56ee1253c1fd
    - [ ] Packer AWS AMI import example:    https://github.com/codilime/security/tree/master/ec2-kali  
    - [ ] Armor Anywhere -  
    - [ ] BurpPro w/ Jenkins -              https://www.we45.com/blog/automating-burp-with-jenkins
    - [ ] OWASP DevSecOps 
        - DevSecOps Studio: https://www.owasp.org/index.php/OWASP_DevSecOps_Studio_Project
        - https://www.teachera.io/devsecops-course/

- [ ] Offensive:
  - [ ] PACU - Open-source AWS exploitation framework 
    - https://github.com/RhinoSecurityLabs/pacu
  - [ ] Rhino Security: Cloud Goat:
        - https://github.com/RhinoSecurityLabs/cloudgoat
        

- [ ] Docker 
    - Security Tools:
        - https://techbeacon.com/10-top-open-source-tools-docker-security
    - [ ] Containers: 
        - [ ] WebGoat -
        - [ ] Glue - `docker pull owasp/glue`
        - [ ] Dependency Check - `docker pull owasp/dependency-check`
        - [ ] Security Shephard (trainer) - `docker pull owasp/security-shepherd`
        - [ ] SonarQube - `docker pull owasp/sonarqube`
        - [ ] Damn Vulnerable Web App - `docker pull vulnerables/web-dvwa`
        - [ ] Vulnerable WordPress 
            - `docker run --name vulnerablewordpress -d -p 80:80 -p 3306:3306 wpscan/vulnerablewordpress`
        - [ ] RailsGoat - `docker pull owasp/railsgoat`
        - [ ] WebGoat -
        - [ ] Metasploit Vulnerability Emulator 
            - `docker run --rm -it \
              -p 20:20 -p 21:21 -p 80:80 -p 443:443 -p 4848:4848 \
              -p 6000:6000 -p 6060:6060 -p 7000:7000 -p 7181:7181 \
              -p 7547:7547 -p 8000:8000 -p 8008:8008 -p 8020:8020 \
              -p 8080:8080 -p 8400:8400 \
              vulnerables/metasploit-vulnerability-emulator`
        


- [ ] Process Monitoring    
    - [ ] Supervisord - https://serversforhackers.com/c/monitoring-processes-with-supervisord
    
- [ ] Technical references:
    - [ ] Terraform Modules: https://docs.cloudposse.com/
    - [ ] Red Team Environment w/ DNS: https://rastamouse.me/2017/08/automated-red-team-infrastructure-deployment-with-terraform---part-1/

- [ ] Terraform 
    - [ ] Terraform-compliance (BDD): https://github.com/eerkunt/terraform-compliance
    - [ ] Kitchen Terraform: https://github.com/newcontext-oss/kitchen-terraform 
    - [ ] Modules: 
        - [x] Amazon Inspector (June 2018) 
            - https://www.we45.com/blog/how-to-amazon-inspector-with-terraform
        - [ ] Dow Jones Hammer: https://dowjones.github.io/hammer/deployment_terraform.html
        - [ ] ELK: https://github.com/admintome/terraform-aws-elk
    - [ ] Articles: 
        - [ ] Terraform aws_spot_instance_request w/ schedule check automation: https://akomljen.com/terraform-and-aws-spot-instances/
    
- [ ] Honey Pots:
    - [x] T-Pot 
        - https://github.com/dtag-dev-sec/t-pot-autoinstall
        - http://dtag-dev-sec.github.io/mediator/feature/2015/03/17/concept.html
    - [ ] HoneyTrap Framework: http://docs.honeytrap.io/docs/home/ 
    - [ ] Modern Honey Pot https://github.com/threatstream/mhn
    - [ ] Cisco ASA: https://github.com/Cymmetria/ciscoasa_honeypot


Tidbits: 
- [ ] You can't implement a solution and trust that solution works w/o issue or further monitoring needed
    - [ ] Equifax breach - configuration mgmt issues
    - [ ] Terraform solution - does not delete all researches
- [ ] Audits are a necessary evil and often very time consuming, yet returns pay dividends.  


T-Pot:
    - /opt/tpot/etc/tpot.yml