# AWS Security OpsGenie Plugin
## Send Aqua's security issues to OpsGenie

> _OpsGenie Plugin is compatible with Aqua Cloud Native Security Platform 4.x_

### Description
The OpsGenie plugin extends Aqua CSP with the ability to open tickets in your OpsGenie account. The plugin is delivered as an image that should be pushed into the Aqua CSP Kubernetes cluster. Configuring the plug-in is done through the deployment yaml file. 

### Tickets types sent to OpsGenie -
Aqua opens the following security ticket types:

Context|Ticket type
----|-------
Scanning|Images that failed the security scans and are non-compliant
Scanning|Hosts that failed the security scans and are non-compliant
Assurance|Attempts to push non-complaint or unregistered images to the cluster
Runtime|Suspicious or unauthorized activity in a container
Runtime|Suspicious or unauthorized network activity at a container level

_Example: Image Failed Assurance Policy_
![CloudFormation](/images/cloudformation.jpg)

_Example: Unauthorized File Execution Detected_
![CloudFormation](/images/cloudformation.jpg)


### Implementation Requirements
- An OpsGenie Account 
- OpsGenie API Key for the integration (see at https://docs.opsgenie.com/docs/api-key-management) 
- Access to Aqua's CSP Kubenetes cluster 

### Deploying the OpsGenie plugin
1. Clone the GitHub OpsGenie repository in your working environment:  
|git@github.com:aquasecurity/opsgenie-plugin.git|

2. If you want to make changes to the ticket messages you can update the message template files at */<<epo>/lc*

3. Create a new *secret* to hold the OpsGenie API Key code
> kubectl create secret -n <<aqua namespace>> generic lc-secrets --from-literal=opsgenie-apikey=[key]
  
4. Create a *configmap* based on the local messages and configurations
> kubectl create configmap aqua-lc-opsgenie-config -n *<aua namespace>* --from-file=./lc/
	
5. Edit the OpsGenie deployment template to configure the plug-in behavior -
- Copy opsgenie_deployment_template.yaml to opsgenie_deployment.yaml and change the following parameters -
- *namespace* - use Aqua's namespace
- *service account* - use Aqua's service account
#### Database configuration 
- *INPUT_PROPERTIES_PASSWORD* - point to the correct Aqua's db password secret
- *INPUT_PROPERTIES_HOST* - point to the Aqua's DB service
- *COMMON_STORAGE_PROPERTIES_HOST* - point to Aqua's DB service
#### OpsGenie configurations
- *OUTPUT_PROPERTIES_ALERTRESPONDERS* - set opsGenie *Responders* field *(see at https://docs.opsgenie.com/docs/alert-api)*
- *OUTPUT_PROPERTIES_ALERTVISIBLETO* - set OpsGenie *Visible To* field *(see at https://docs.opsgenie.com/docs/alert-api)*

6. Push the OpsGeini plug-in to the cluster :
> kubectl create -f opsgenie_deployment.yaml
	
### Troubleshooting and Support
To validate the integration check the logs of the plugin
> kubectl logs aqua-lc-opsgenie-<pod-unique-code> -n aqua

For support and questions please contact us at - community.plugins@aquasec.com.

### Disclaimer 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
