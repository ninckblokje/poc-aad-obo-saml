# poc-aad-obo-saml

This is a proof of concept for requesting a SAML token in Azure API Management. The SAML token is then used as a bearer token (specified in [RFC 7522](https://datatracker.ietf.org/doc/rfc7522/)). For this to work the Azure On-Behalf-Of flow is used, which takes an access token (from a user principle) and transforms it to a SAML token (see [SAML assertions obtained with an OAuth2.0 OBO flow](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-on-behalf-of-flow#saml-assertions-obtained-with-an-oauth20-obo-flow)).

The Azure On-Behalf-Of flow is implemented in an [Azure API Management policy](bicep/api-policy.xml).

This proof of concept consists of two parts:
1. Frontend application with Javascript
   - To login a user
   - To request an access token for the user
   - To call an API in Azure API Management
1. API configuration (using Bicep) for Azure API Management
    - See [my-azure-env](https://github.com/ninckblokje/my-azure-env/) for the Azure API Management definition

Two app registrations are required in Azure AD:
1. For a fictive backend
   - With a scope called `Scope.Dummy`
1. For this client and Azure API Management
   - Configured as SPA with a redirect URL to: http://localhost:8080/blank.html
   - With a secret (for Azure API Management)
   - With a scope called `Scope.Dummy`
   - With permissions to call the scope `Scope.Dummy` on the previous app registration as delegate

To run this proof of concept:
1. Run `npm install`
1. Create a file called `config.js` in the `dist` folder (see [config.js.example](dist/config.js.example) for an example)
1. Create a file called `http-receiver-saml-api.params` in the `bicep` folder (see [http-receiver-saml-api.params.json.example](bicep/http-receiver-saml-api.params.json.example) for an example)
1. Run `New-AzResourceGroupDeployment -TemplateFile .\bicep\http-receiver-saml-api.bicep -TemplateParameterFile .\bicep\http-receiver-saml-api.params.json -ResourceGroupName speeltuin-jnb -Confirm`
1. Run `npm run serve`
1. Open http://localhost:8080 and click the buttons
1. The backend service receives a custom header (called `Test`) with the first 40 characters of the BASE64URL encoded SAML token

As backend service [http-receiver](https://github.com/ninckblokje/http-receiver) was used.
