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

import { config } from "./config.js";

const msalConfig = {
  auth: {
      clientId: config.clientId,
      authority: `https://login.microsoftonline.com/${config.tenantId}`,
      redirectUri: 'http://localhost:8080/blank.html'
  }
};

const msalInstance = new msal.PublicClientApplication(msalConfig);

const data = {
  loginResponse: null,
  tokenResponse: null
}

window.authenticateWithAad = async function() {
  console.log("Authenticating with AAD")
  try {
      data.loginResponse = await msalInstance.loginPopup({})
  } catch (err) {
      console.error(err)
  }
}

window.acquireTokenFromAad = async function() {
  console.log("Acquiring token from AAD")
  try {
      data.tokenResponse = await msalInstance.acquireTokenPopup({
          scopes: config.scopes
      })
  } catch (err) {
      console.error(err)
  }
}

window.callApi = function() {
  console.log("Calling API")
  fetch(config.apiUrl, {
      method: "GET",
      headers: new Headers({
          'Authorization': `Bearer ${data.tokenResponse.accessToken}`
      })
  })
}
