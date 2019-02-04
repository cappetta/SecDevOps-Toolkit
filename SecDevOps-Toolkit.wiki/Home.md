# SecDevOps Toolkit overview
The goal is to create a repository of automation tools which can be used easily by many individuals. To gain the maximum value out of the entire solution, you should seek to master each tool and find creative ways to leverage all of the tools.  

The wiki will be used to help create a simple outline of configurations, setups, and cliff-note guides to get someone up and running quickly.

## Git Setup:
If you are actively cloning, forking, and pushing files into git then it is strongly advised that you setup the git-secrets tooling to prevent leakage of any sensitive information into your git repo.

This tooling sets up commit hooks which are executed with each commit.  The goal is simply to reject commits which contain any secret or custom defined private data.

https://github.com/awslabs/git-secrets


Useful Git-secret regexs:

  ```
  git secrets --add 'subnet-[a-z0-9]+'
  git secrets --add 'sg-[a-z0-9]+'
  git secrets --add --literal 'aws_keypair_name: "automation"'
  git secrets --add -a "subnet-xxxxxxx|sg-xxxxxxx|(xx)+|name_of_aws_keypair"
  ```


### Contents of ./.git/config
The following flags any defined subnet ids, security groups, keypair names which are defined for an AWS environment.  

The allowed pattern creates a rule to enable the yaml/manifest templates from being flagged/updated.  

```
[secrets]
	providers = git secrets --aws-provider
	patterns = [A-Z0-9]{20}
	patterns = (\"|')?(AWS|aws|Aws)?_?(SECRET|secret|Secret)?_?(ACCESS|access|Access)?_?(KEY|key|Key)(\"|')?\\s*(:|=>|=)\\s*(\"|')?[A-Za-z0-9/\\+=]{40}(\"|')?
	patterns = (\"|')?(AWS|aws|Aws)?_?(ACCOUNT|account|Account)_?(ID|id|Id)?(\"|')?\\s*(:|=>|=)\\s*(\"|')?[0-9]{4}\\-?[0-9]{4}\\-?[0-9]{4}(\"|')?
	patterns = subnet-[a-z0-9]+
	patterns = sg-[a-z0-9]+
	patterns = aws_keypair_name: \"automation\"
	allowed = subnet-xxxxxxx|sg-xxxxxxx|(xx)+|name_of_aws_keypair
```


### Testing Git-Secrets
If you have a failure when attempting to commit then you must unstage your commits by reverting your git repo to head using `git reset HEAD`, 
this will allow you to fix the files impacted and/or remove them from the scope of the commit and move forward.

#### Terraform Git-Secret Test
```
(aws)myhost:SecDevOps-Toolkit cappetta$ git add terraform/network/variables.tf
(aws)myhost:SecDevOps-Toolkit cappetta$ git commit -m "git secret test"
terraform/network/variables.tf:7:  default="IPurposelyRedactedThisInformation"
terraform/network/variables.tf:12:  default="B2+IPurposelyRedactedThisInformation"

[ERROR] Matched one or more prohibited patterns

Possible mitigations:
- Mark false positives as allowed using: git config --add secrets.allowed ...
- Mark false positives as allowed by adding regular expressions to .gitallowed at repository's root directory
- List your configured patterns: git config --get-all secrets.patterns
- List your configured allowed patterns: git config --get-all secrets.allowed
- List your configured allowed patterns in .gitallowed at repository's root directory
- Use --no-verify if this is a one-time false positive
```

#### Vagrant Git-Secret Test
```
(aws)myhost:SecDevOps-Toolkit cappetta$ git commit -m "testing yaml and gitsecrets"
vagrant/yaml/seclab.yaml:9:  subnet_id:   'subnet-redacted'
vagrant/yaml/seclab.yaml:10:  secgroup_name: 'sg-redacted'
vagrant/yaml/seclab.yaml:11:  aws_keypair_name: "automation"

[ERROR] Matched one or more prohibited patterns

Possible mitigations:
- Mark false positives as allowed using: git config --add secrets.allowed ...
- Mark false positives as allowed by adding regular expressions to .gitallowed at repository's root directory
- List your configured patterns: git config --get-all secrets.patterns
- List your configured allowed patterns: git config --get-all secrets.allowed
- List your configured allowed patterns in .gitallowed at repository's root directory
- Use --no-verify if this is a one-time false positive
```

## AWS Setup:
 The AWS Setup wiki contains information on setting up your credentials to interact with AWS via automation tooling & CLI (command line interface).  
 
 In addition this wiki shows how to create a simple isolated python environment, using virtualenv, to isolate dependencies.  This approach is most often used by developers who
 have a need to identify & isolate specific python versions & package dependencies of an application or operating environment.
  
 Once the awscli is installed you must configure it and there is a simple section outlined w/ how to setup your creds to enable CLI functionality.  You can setup multiple AWS profiles for 