OKD - Volumes
=============

Volumes is a way that containers can share data between pods. Persistent Volumes is the way that pods can share volumes between another pods or even clusters.

Once you had provisioned your OKD cluster, you can go to the **storage** machine and create some NFS mount points:

    mkdir -p /volumes/v{1,2,3,4,5}
    cat > /etc/exports <<EOF
    /volumes/v1 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check)
    /volumes/v2 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check)
    /volumes/v3 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check)
    /volumes/v4 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check)
    /volumes/v5 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check)
    EOF
    exportfs -a
    systemctl start nfs-server
    systemctl enable nfs-server

#### Read and Write

To allow write from a pod to a NFS volume, you need to remove a SELinux protection in every node:

    setsebool -P virt_use_nfs 1

PersistentVolume
----------------

Once the volumes as exposed from storage server, you can create a PersistentVolume with the NFS type to deploy a volume in your cluster to your developers:

**nfs-pv.yml**

    apiVersion: v1                                            
    kind: PersistentVolume
    metadata:
      name: nfs-v1
    spec:
      capacity:
        storage: 256Mi
      accessModes:
        - ReadWriteMany
      nfs:
        server: 192.168.1.40setsebool -P virt_use_nfs 1
        path: "/volumes/v1"

PersistentVolumeClaim
-----------------

To request a volume, a developer need to create a **PersistentVolumeClaim** object that matches the PersistentVolumes available in the cluster:

**nfs-pvc.yml**

    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: nfs-pvc1
    spec:
      accessModes:
        - ReadWriteMany
      storageClassName: ""
      resources:
        requests:
          storage: 256Mi

Mount the Volume
----------------

For a simple demonstration, you can attach this volume to a simple alpine pod:

**alpine-pod.yml**

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
        - name: shared-data
          mountPath: /var/shared-data
      volumes:
      - name: shared-data
        persistentVolumeClaim:
          claimName: nfs-pvc1
