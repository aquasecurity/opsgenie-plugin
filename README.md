# Aqua OpsGenie Plugin
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
![Image ticket](/images/imagefailed.jpg)

_Example: Unauthorized File Execution Detected_
![Runtime ticket](/images/runtimeticket.jpg)


### Implementation Requirements
- OpsGenie Account 
- OpsGenie API Key for the integration (see at https://docs.opsgenie.com/docs/api-key-management) 
- Access to Aqua's CSP Kubenetes cluster 

### Deploying the OpsGenie plugin
1. Clone the GitHub OpsGenie repository in your working environment  
```
git clone git@github.com:aquasecurity/opsgenie-plugin.git|
```
2. You can changes the default tickets language in the template files at */<repo>/lc*

3. Create a new *secret* to hold the OpsGenie API Key code
```
kubectl create secret -n <aqua namespace> generic lc-secrets --from-literal=opsgenie-apikey=<opsgenie-integration-key>
```  
4. Create a *configmap* from the local messages and configurations
```
kubectl create configmap aqua-lc-opsgenie-config -n <aqua namespace> --from-file=./lc/
```	
5. Configure OpsGenie behavior be editing the Kubernetes deployment yaml template

Copy opsgenie_deployment_template.yaml to opsgenie_deployment.yaml and change the following parameters -

Context|Field|Description
-------|-----|-----------
Cluster|*namespace*|Use Aqua's namespace
Cluster|*service account|Use Aqua's service account
Database|*INPUT_PROPERTIES_PASSWORD*|Point to Aqua's db password secret
Database|*INPUT_PROPERTIES_HOST*|Point to the Aqua's DB service
Database|*COMMON_STORAGE_PROPERTIES_HOST*|Point to Aqua's DB service
OpsGenie|*OUTPUT_PROPERTIES_ALERTRESPONDERS*|Set OpsGenie *Responders* field *(see at https://docs.opsgenie.com/docs/alert-api)*
OpsGenie|*OUTPUT_PROPERTIES_ALERTVISIBLETO*|Set OpsGenie *Visible To* field *(see at https://docs.opsgenie.com/docs/alert-api)*

6. Push the OpsGeini plug-in to the cluster :
```
kubectl create -f opsgenie_deployment.yaml
```	
### Troubleshooting and Support
To validate the integration check the logs of the plugin
```
kubectl logs aqua-lc-opsgenie-<pod-unique-code> -n aqua
```
For support and questions please contact us at - community.plugins@aquasec.com.

### Disclaimer 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
