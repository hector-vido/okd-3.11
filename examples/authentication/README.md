OKD - Authentication
====================

OKD suport a lot of authentication methods such as LDAP, HTPasswd and the default on AllowAll.
By default, any user and any password will grant access to the OKD cluster.

Just to simplify and don't allow these type of access, login in [https://master.okd.os:8443](https://master.okd.os:8443) and choose an username and a password.

You can see the user you created with:

    oc get user
    oc get identity

Now, go to the **master-config.yml** in */etc/origin/master/master-config.yaml* and change the **mappingMethod** from **claim** to **lookup**:

    ...
      identityProviders:
      - challenge: true
        login: true
        mappingMethod: claim
    ...
      identityProviders:
      - challenge: true
        login: true
        mappingMethod: lookup

Restar the master api and controllers to apply the new configuration:

    /usr/local/bin/master-restart api
    /usr/local/bin/master-restart controllers
