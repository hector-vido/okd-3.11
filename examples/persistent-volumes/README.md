OKD - Volumes
=============

Volumes is a way that containers can share data between pods. Persistent Volumes is the way that pods can share volumes between another pods or even clusters.

Once you had provisioned your OKD cluster, you can go to the **storage** machine and create some NFS mount points:

```
mkdir -p /volumes/v{1,2,3,4,5}
chmod 0700 /volumes/v{1,2,3,4,5}
chown nfsnobody: /volumes/v{1,2,3,4,5}

cat > /etc/exports <<EOF
/volumes/v1 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v2 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v3 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v4 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v5 27.11.90.0/255.255.255.0(rw,all_squash)
EOF

exportfs -a
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
```

#### Read and Write

To allow write from a pod to a NFS volume, you need to remove a SELinux protection in every node:

    setsebool -P virt_use_nfs 1

PersistentVolume
----------------

Once the volumes as exposed from storage server, you can create a PersistentVolume with the NFS type to deploy a volume in your cluster to your developers:

**nfs-pv.yml**

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-mysql
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  nfs:
    server: 27.11.90.40
    path: "/volumes/v1"
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-cache
spec:
  capacity:
    storage: 512Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 27.11.90.40
    path: "/volumes/v2"
```

To see these two **PersistentVolumes* execute the following command:

	oc get pv

PersistentVolumeClaim
---------------------

To request a volume, a developer need to create a **PersistentVolumeClaim** object that matches the PersistentVolumes available in the cluster:

**cache-pvc.yml**
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cache
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 512Mi
```

Wait some seconds and list the **PersistentVolumeClaim**. Notice that **nfs-cache** is now attached to it:

	oc get pvc

Mount the Volume
----------------

For a simple demonstration, you can attach this volume to a simple alpine pod:

**alpine-pod.yml**
```
apiVersion: v1
kind: Pod
metadata:
  name: alpine
spec:
  containers:
  - image: alpine
    name: alpine
    tty: true
    stdin: true
    volumeMounts:
    - name: cached-data
      mountPath: /var/cached-data
  volumes:
  - name: cached-data
    persistentVolumeClaim:
      claimName: cache
```
