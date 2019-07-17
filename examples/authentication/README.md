OKD - Authentication
====================

OKD suport a lot of authentication methods such as LDAP, HTPasswd, Keystone and so on.
By default OKD will grant access to any user and any password because **AllowAllPasswordIdentityProvider** is probably enabled.

HTPasswd
--------

Just to simplify and create the simplest secure authentication, login through ssh in [okd.example.com:8443](okd.example.com:8443) and create an **htpasswd** file with an user and a password:

    htpasswd -bc /etc/origin/master/htpasswd okd pass123

Verify if the password match the user you choose:

    htpasswd -v /etc/origin/master/htpasswd okd

Now, go to the **master-config.yml** in */etc/origin/master/master-config.yaml* and change the only **identityProvider**:

    ...
      identityProviders:
      - challenge: true
        login: true
        mappingMethod: claim
        name: allow_all
        provider:
          apiVersion: v1
          kind: AllowAllPasswordIdentityProvider
    ...
      - name: htpasswd
        challenge: true 
        login: true 
        mappingMethod: claim 
        provider:
          apiVersion: v1
          kind: HTPasswdPasswordIdentityProvider
          file: /etc/origin/master/htpasswd 

Restar the master api and controllers to apply the new configuration:

    /usr/local/bin/master-restart api
    /usr/local/bin/master-restart controllers

Try login trough the **webconsole** or **cli** and after that you can see the user you created with:

    oc get user
    oc get identity
