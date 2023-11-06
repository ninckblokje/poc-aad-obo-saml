/*  
  Copyright (c) 2023, ninckblokje
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

param serviceAudience string = ''

param serviceUrl string = ''

param clientId string = ''

@secure()
param clientSecret string = ''

param clientAudience string = ''

param frontendClientId string = ''

param scope string = ''

param tenantId string = ''

resource jnbApim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: 'jnb-apim'
}

resource clientIdNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiClientId'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiClientId'
    value: clientId
  }
}

resource clientSecretNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiClientSecret'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiClientSecret'
    secret: true
    value: clientSecret
  }
}

resource clientAudienceNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiClientAudience'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiClientAudience'
    value: clientAudience
  }
}

resource scopeNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiScope'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiScope'
    value: scope
  }
}

resource tenantIdNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiTenantId'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiTenantId'
    value: tenantId
  }
}

resource serviceAudienceNV 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'httpReceiverSamlApiServiceAudience'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiServiceAudience'
    value: serviceAudience
  }
}

resource frontendClientIdNV 'Microsoft.ApiManagement/service/namedValues@2022-08-01' = {
  name: 'httpReceiverSamlApiFrontendClientId'
  parent: jnbApim
  properties: {
    displayName: 'httpReceiverSamlApiFrontendClientId'
    value: frontendClientId
  }
}

resource httpReceiverSamlApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: 'http-receiver-saml-api'
  parent: jnbApim
  properties: {
    displayName: 'HTTP Receiver SAML API'
    path: 'api/receiver/saml'
    protocols: [
      'https'
    ]
    serviceUrl: serviceUrl
    subscriptionRequired: false
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
    }
  }
}

resource httpReceiverSamlApiGet 'Microsoft.ApiManagement/service/apis/operations@2021-08-01' = {
  name: 'http-receiver-saml-api-get'
  parent: httpReceiverSamlApi
  properties: {
    displayName: 'HTTP Receiver SAML API GET'
    method: 'GET'
    urlTemplate: '/'
  }
}

resource httpReceiverSamlApiPolicy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: 'policy'
  parent: httpReceiverSamlApi
  properties: {
    value: loadTextContent('api-policy.xml', 'utf-8')
    format: 'xml'
  }
}
