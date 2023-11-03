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