# MongoDB Setup Tutorial
----

This tutorial represent a setup step of MongoDB by using Docker,
It include two structure:
1. Standalone
2. ReplicaSet

----
## Standalone

### Setup step

1. Copy env-sample file to .env  
```bash
  $ cp env-sample .env
```

2. Edit .env file  

3. Run docker-compose  
```bash
  $ make 
```

### Other command

- `make restart`
- `make stop`

**Caustion!! This Command will remove container**
- `make down`

----
## ReplicaSet

[ReplicaSet Document](https://docs.mongodb.com/manual/replication/)  

ReplicaSet will create at lease **3** nodes, so you should copy this repository for them  
1. Primary (rs1)
2. Secondary (rs2)
3. Secondary (rs3)

### Setup Primary (rs1)

1. Copy env-sample file to .env
```bash
  $ cp env-sample .env
```

2. Edit .env file  
 
3. Generate Key for ReplicaSet  
This key will use for other secondary node  
```bash
$ make genkey
```

4. Start master node  
After execute this command, please wait a moment for finish.  
```bash
$ make rs
```

5. Initial ReplicaSet in mongo shell  
```bash
$ make rs-init
```

### Setup Secondary (rs2, rs3)
1. Copy the key which generated from Primary

2. Copy .env file from Primary (You could edit the container name in .env file)

3. Start Relicate Set  
```bash
$ make rs
```

### Add DNS to each node (rs1, rs2, rs3, ...)  
If you have own DNS Server, you can ignore this step

1. Edit the /resource/hosts file, such as  
```txt
172.18.0.2    rs1
172.18.0.3    rs2
172.18.0.4    rs3
```  

2. Append hosts  
```bash
$ make rs-add-dns
```
> Execute previouse step for each node! (Primary, secondary1, secondary 2, ...)

### Add ReplicaSet Node in primary
1. Edit node file in _config/nodes_  
Add your nodes, and wrappd in _rs.add('\<HOST>')_ or_rs.add('\<HOST>:\<PORT>')_, such as below:
```vim
RS_NODES="rs.add('rs2:27017');rs.add('rs3:27017')"
```
2. Execute add nodes in primary node:  
```bash
$ make rs-add-nodes
```

3. You can check status with the command  
```bash
$ make rs-status
```

### Other command

- `make restart`
- `make stop`

**Caustion!! This Command will remove container**
- `make rs-down`
