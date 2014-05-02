#Using Commandline to manage files on HDFS

##Preqequisites
A working HDP cluster - the easiest way to have a HDP cluster is to download the [Hortonworks Sandbox] [1].

###Let's run some commands!
In this we are going to run 6 examples on how to handle with HDFS files & folders.

####Step 1: Let's create a directory in HDFS, upload a file and list.

Let's look at the syntax first:

#####hadoop fs -mkdir:
-   It will take path uri's as argument and creates directory or directories.

```
    Usage: 
            hadoop fs -mkdir <paths> 
    Example:
            hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2
            hadoop fs -mkdir hdfs://nn1.example.com/user/hadoop/dir
```

#####hadoop fs -ls: 

  - Lists the contents of a directory
  - For a file returns stats of a file
  
```sql
    Usage: 
            hadoop fs -ls <args>
    Example: 
            hadoop fs -ls /user/hadoop/dir1 /user/hadoop/dir2
            hadoop fs -ls /user/hadoop/dir1/filename.txt
            hadoop fs -ls hdfs://<hostname>:9000/user/hadoop/dir1/
```

Let's use the following commands as follows and execute. You can ssh to the sandbox using Tools like Putty. You could download putty.exe from the internet.

![enter image description here][2]

Let's touch a file locally.

```
$ touch filename.txt
```
 
![enter image description here][3]

####Step 2: Now, let's check how to find out space utilization in a HDFS dir.
#####hadoop fs -du: 

 -  Displays sizes of files and directories contained in the given directory or the size of a file if its just a file.
  
```
    Usage:  
            hadoop fs -du URI
    Example:
            hadoop fs -du  /user/hadoop/ /user/hadoop/dir1/Sample.txt
```

![enter image description here][4]

####Step 4: 
Now let's see how to upload and download files from and to Hadoop Data File System(HDFS)
Upload: ( we have already tried this earlier)

#####hadoop fs -put:
-   Copy single src file, or multiple src files from local file system to the Hadoop data file system

```
    Usage: 
            hadoop fs -put <localsrc> ... <HDFS_dest_Path>
    Example:
            hadoop fs -put /home/ec2-user/Samplefile.txt ./ambari.repo /user/hadoop/dir3/
```

Download:
hadoop fs -get:

-   Copies/Downloads files to the local file system

```
    Usage: 
            hadoop fs -get <hdfs_src> <localdst> 
    Example:
            hadoop fs -get /user/hadoop/dir3/Samplefile.txt /home/
```

![enter image description here][5]

####Step 5: Let's look at quickly two advanced features.

#####hadoop fs -getmerge
 
-   Takes a source directory  files as input and concatenates files in src into the destination local file.

```
    Usage: 
            hadoop fs -getmerge <src> <localdst> [addnl]
    Example:
            hadoop fs -getmerge /user/hadoop/dir1/  ./Samplefile2.txt
    Option:
            addnl: can be set to enable adding a newline on end of each file
```

#####hadoop distcp: 

-   Copy file or directories recursively
-   It is a  tool used for large inter/intra-cluster copying
-   It uses MapReduce to effect its distribution copy, error handling and recovery, and reporting

```
    Usage: 
            hadoop distcp <srcurl> <desturl>
    Example:
            hadoop distcp hdfs://<NameNode1>:8020/user/hadoop/dir1/ \ 
                    hdfs://<NameNode2>:8020/user/hadoop/dir2/
            
```

You could use the following steps to perform getmerge and discp.
Let's upload two files for this exercise first:

```sql 
# touch txt1 txt2
# hadoop fs -put txt1 txt2 /user/hadoop/dir2/
# hadoop fs -ls /user/hadoop/dir2/
```

![enter image description here][6]




#### Step 6:Getting help
You can use Help command to get list of commands supported by Hadoop Data File System(HDFS)
```sql
    Example:    
            hadoop fs -help
```

![enter image description here][7]

Hope this short tutorial was useful to get the basics of file management. 

  [2]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_step_1(1).jpg
  [3]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_step_1(2).jpg
  [4]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_DU_step2.1.jpg
  [5]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_get_step2.1.jpg
  [6]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_getmerge_distcp_step2.1.jpg "HDFS_HW_getmerge_distcp_step2.1.png"
  [7]: http://hortonassets.s3.amazonaws.com/tutorial/commandline/HDFS_HW_step3.jpg "HDFS_HW_step3.png"