
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Webapp Certificate Renewal Failures
---

This incident type refers to a failure in the auto-renewal process of SSL/TLS certificates for Azure Webapp services. This can result in expired certificates, leading to potential security vulnerabilities and interruptions in service. The resolution involves ensuring that the SSL/TLS certificates are configured correctly for auto-renewal, updating certificate settings, and manually renewing certificates if necessary.

### Parameters
```shell
export APP_NAME="PLACEHOLDER"

export RESOURCE_GROUP="PLACEHOLDER"

export CERTIFICATE_NAME="PLACEHOLDER"

export CERTIFICATE_FILE_PATH="PLACEHOLDER"

export CERTIFICATE_PASSWORD="PLACEHOLDER"
```

## Debug

### List all enabled hostnames for the specific web app
```shell
az webapp show --name ${APP_NAME} --resource-group ${RESOURCE_GROUP} --query "hostnameSslStates"
```

### List the SSL certificates for a specific web app
```shell
az webapp config ssl list --resource-group ${RESOURCE_GROUP} --query "[].name"
```

### View detailed SSL certificate information for a specific binding
```shell
az webapp config ssl show --resource-group ${RESOURCE_GROUP} --certificate-name ${CERTIFICATE_NAME}
```

### Check the expiration date of an SSL certificate
```shell
az webapp config ssl show --resource-group ${RESOURCE_GROUP} --certificate-name ${CERTIFICATE_NAME} --query "expirationDate" --output tsv
```

### Verify that the SSL certificate is a managed certificate
```shell
az webapp config ssl show --resource-group ${RESOURCE_GROUP} --certificate-name ${CERTIFICATE_NAME} --query "type" --output tsv
```

## Repair

### Manually renew an SSL certificate
```shell
#!/bin/bash



# Set variables

PFX_PATH=${CERTIFICATE_FILE_PATH}

PFX_PASSWORD=${CERTIFICATE_PASSWORD}

APP_NAME=${APP_NAME}

RESOURCE_GROUP=${RESOURCE_GROUP}



# Upload the SSL certificate and get the thumbprint

thumbprint=$(az webapp config ssl upload --certificate-file $PFX_PATH --certificate-password $PFX_PASSWORD --name $APP_NAME --resource_group $RESOURCE_GROUP --query thumbprint --output tsv)



# Bind the uploaded SSL certificate to the webapp



az webapp config ssl bind --certificate-thumbprint $thumbprint --ssl-type SNI --name $APP_NAME --resource-group $RESOURCE_GROUP




```