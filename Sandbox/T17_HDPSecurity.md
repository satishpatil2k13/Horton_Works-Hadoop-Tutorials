###Introduction

In this tutorial we will explore how you can use policies in HDP Security to protect your enterprise data lake and audit access by users to resources on HDFS, Hive and HBase from a centralized HDP Security Administration Console.

###Prerequisite

  - VirtualBox
  - Download [Hortonworks Sandbox + HDP Security](http://hortonassets.s3.amazonaws.com/2.1/hdpsecurity/HDPSecurity_3.5.000-on-HDP-2.1Sandbox.ova)
  
After you download the VM, import the .ova file to VirtualBox and run the VM.


###Login to HDP Security Administration Console 

Once the VM is running in VirtualBox, login to the HDP Security Administration console at [http://localhost:6080/](http://localhost:6080/) from your host machine. The username is `admin` and the password is `admin`


![](http://hortonassets.s3.amazonaws.com/tutorial/security/XAPolicyAdminLogin.png)

As soon as you login, you should see list of repositories as shown below:
![](http://hortonassets.s3.amazonaws.com/tutorial/security/RepositoryList.png)

###Review existing HDFS policies

Please click on `hadoopdev` link under HDFS section

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HDFSPolicyList.png)

User can review policy details by a single click on the policy. The policy details will appear on the right.


###Exercise HDFS access scenarios

To validate the policy, please login into the sandbox using username `it1`. User `it1` belongs to the `IT` group.

```bash
[root@sandbox ~]# su - it1
[it1@sandbox ~]$ id
uid=1018(it1) gid=1018(IT) groups=1018(IT)

[it1@sandbox ~]$ hdfs dfs -cat /demo/data/Customer/acct.txt
cat: Permission denied: user=it1, access=READ, inode="/demo/data/Customer/acct.txt":hdfs:hdfs:-rwx------
```

Go to Policy Administrator tool and see its access (denied) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HDFSAccessAuditDeniedUseCase.png) 

Now, try the same with user `mktg1`  who belongs to the `marketing` group.

```bash
[root@sandbox ~]# su - mktg1
[mktg1@sandbox ~]$ id
uid=1020(mktg1) gid=1020(Marketing) groups=1020(Marketing)
[mktg1@sandbox ~]$ hdfs dfs -cat /demo/data/Customer/acct.txt
PHONE_NUM|PLAN|DATE|STAUS|BALANCE|IMEI|REGION
5553947406|6290|20130328|31|0|012565003040464|R06
7622112093|2316|20120625|21|28|359896046017644|R02
5092111043|6389|20120610|21|293|012974008373781|R06
9392254909|4002|20110611|21|178|357004045763373|R04
....
```

Go to Policy Administrator tool and see its access (granted) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HDFSAccessAuditGrantedUseCase.png)

###Review Hive Policies

Click on PolicyManager section on the top menu, then click on `hivedev` link under HIVE section to view list of Hive Policies

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HivePolicyList.png)

User can review policy details by a single click on the policy. The policy details will appear on the right.

###Exercise Hive access scenarios

Run the `beeline` command to validate access for `mktg1` user to see if he can run 

```sql
select * from xademo.customer_details
```

```bash
$ /usr/lib/hive/bin/beeline -u "jdbc:hive2://localhost:10000/default" -n mktg1 -p mktg1 -d org.apache.hive.jdbc.HiveDriver
Connecting to jdbc:hive2://localhost:10000/default
Connected to: Apache Hive (version 0.13.0.2.1.1.0-385)
Driver: Hive JDBC (version 0.13.0.2.1.1.0-385)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 0.13.0.2.1.1.0-385 by Apache Hive
0: jdbc:hive2://localhost:10000/default> select * from xademo.customer_details ;
Error: Error while compiling statement: FAILED: HiveException org.apache.hadoop.hive.ql.metadata.AuthorizationException: User [mktg1] does not have [select] privilege on column [db:xademo,table:customer_details,column:imei] (state=42000,code=40000)
```

Go to Policy Administrator tool and see its access (denied) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HIVEAccessAuditDeniedUseCase.png)


Run the same beeline command to validate access for `legal1` user-id which belongs to the `legal` group:

```bash
$ /usr/lib/hive/bin/beeline -u "jdbc:hive2://localhost:10000/default" -n legal1 -p legal1 -d org.apache.hive.jdbc.HiveDriver
Connecting to jdbc:hive2://localhost:10000/default
Connected to: Apache Hive (version 0.13.0.2.1.1.0-385)
Driver: Hive JDBC (version 0.13.0.2.1.1.0-385)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 0.13.0.2.1.1.0-385 by Apache Hive
0: jdbc:hive2://localhost:10000/default> select * from xademo.customer_details ;
+--------------------------------+------------------------+--------------------+
| customer_details.phone_number  | customer_details.plan  | customer_details.d |
+--------------------------------+------------------------+--------------------+
| PHONE_NUM                      | PLAN                   | DATE               |
| 5553947406                     | 6290                   | 20130328           |
| 7622112093                     | 2316                   | 20120625           |
| 5092111043                     | 6389                   | 20120610           |
```

Go to Policy Administrator tool and see its access (granted) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HIVEAccessAuditGrantedUseCase.png)


###Review HBase Policies
Click on PolicyManager section on the top menu, then click on hbasedev link under HBASE section to view list of hbase Policies

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HBasePolicyList.png)

User can review policy details by a single click on the policy. The policy details will appear on the right.

###Exercise HBase access scenarios

Run the hbase shell command to validate access for Legal user-id to see if he can create an iemployee table with few column families:

```bash
# su - legal1
[legal1@sandbox ~]$ hbase shell
2014-05-30 14:47:31,740 INFO  [main] Configuration.deprecation: hadoop.native.lib is deprecated. Instead, use io.native.lib.available
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.98.0.2.1.1.0-385-hadoop2, re7b81b02bc8ba00573e009241b8e15848ae8bfb7, Wed Apr 16 15:23:13 PDT 2014

hbase(main):001:0> create 'iemployee', 'personal', 'payroll', 'skills', 'insurance'
....
....
ERROR: org.apache.hadoop.hbase.security.AccessDeniedException: Insufficient permissions for user 'legal1 (auth:SIMPLE)' (global, action=CREATE)
...
...
...
```

Go to Policy Administrator tool and see its access (denied) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HBaseAccessAuditDeniedUseCase.png)

Run the same beeline command to validate access for mktg1 user-id:

```bash
[root@sandbox xasecure]# su - mktg1
[mktg1@sandbox ~]$ hbase shell
2014-05-30 14:54:14,338 INFO  [main] Configuration.deprecation: hadoop.native.lib is deprecated. Instead, use io.native.lib.available
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.98.0.2.1.1.0-385-hadoop2, re7b81b02bc8ba00573e009241b8e15848ae8bfb7, Wed Apr 16 15:23:13 PDT 2014

hbase(main):001:0> create 'iemployee', 'personal', 'payroll', 'skills', 'insurance'
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/hadoop/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/lib/zookeeper/lib/slf4j-log4j12-1.6.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
0 row(s) in 6.1440 seconds

=> Hbase::Table - iemployee
hbase(main):002:0>
```

Go to Policy Administrator tool and see its access (granted) being audited.

![](http://hortonassets.s3.amazonaws.com/tutorial/security/HBaseAccessAuditGrantedUseCase.png)

###Summary

Hopefully by following this tutorial, you got a taste of the power and ease of securing your key enterprise resources using HDP Security.

Happy Hadooping!!! 


