# v2.1.3

* Fixed misnamed ROLE_ARN to POLICY_ARN in IRSA demo.  No functional changes.

# v2.1.2

* Added an OPTIONAL ASCP demo under "bonus" - For Module 8 Storage
* Moved Karpenter demo to the bonus directory as "demo-karpenter" (Previously was 98-karpenter folder)

# v2.1.1 

* Added details to the README.md about using the karpenter optional demo.

# v2.1.0

* Added a Karpenter demo in 98-karpenter folder.  See README.md for details.
* jq is now considered a required pre-requisite (Pre-installed on Cloud9)

# v2.0.9

* Fixed minor comments and suggestions

# v2.0.8

* Minor demo step and shell script comment updates. 

# v2.0.7

* You can now install in multiple regions (if desired). There should be no global name conflicts (IAM, etc.)
* There should be no naming conflicts with EKS Workshop
* Various minor improvements

# v2.0.6

* Improved rollout restart demo by using more pod replicas
* Check for missing region when running uninstall.sh

# v2.0.5

* Flow improvements
* Fixed path for full uninstall command

# v2.0.4

* Added fix-blank-session.sh to PATH for easy execution when needed
* Added bad session_token example in the fix-blank-session.sh comments 
* Added README.md comments on statically named resources 

# v2.0.3

Added changelog

# v2.0.0

First official version that will be used for the Running Containers on EKS v2.0 Delivery Launch Pad and TTT Sessions.

Major changes since earlier versions:
* Added bonus material
* Changed region to us-west-2 (as us-east-1)
* All demo steps tested