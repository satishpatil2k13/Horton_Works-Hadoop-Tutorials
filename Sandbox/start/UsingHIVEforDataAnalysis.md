##Overview

Hive is designed to enable easy data summarization and ad-hoc analysis of large volumes of data. It uses a query language called Hive-QL which is similar to SQL. 

In this tutorial, we will explore the following:

1.  Load a data file into a Hive table
2.  Create a table using RCFormat
3.  Query tables
4.  Managed tables vs external tables
5.  ORC format
6.  PARTITIONED a Table
7.  Bucketing a Table

##Prerequisites

A working HDP cluster - the easiest way to have a HDP cluster is to download the [Hortonworks Sandbox] [1]

###Step 1.   Let's load a data file into a Hive table.
First of all, download data file from here [click here][2] and name the file as TwitterData.txt . You can copy the downloaded file into hdfs folder, /user/hadoop using hdfs fs -put command (see this [tutorial](http://hortonworks.com/hadoop-tutorial/using-commandline-manage-files-hdfs/)) or the Hue Interface. 

As the file is small, you can simply open it, copy and create a local file in the sandbox manually as well.

We will use the Web UI here. 

Open http://localhost:8000 in your browser.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/FileBrowser_opt.jpg)

Now, click on File Browser logo and you will see the following screen. You could load to /user hdfs folder or /user/hue folder. Please choose your hdfs path.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Upload_opt.jpg)


Now click on Upload option and select file TwitterData.txt from your computer.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/FileSelect_opt.jpg)

Here is a sample syntax to create a table and load datafile into the table. 

Make sure you are using the correct path for your data file.

Let's create this table and load data.
Type "hive" at the command prompt after you ssh in to the Sandbox.

```sql
    CREATE TABLE TwitterExampletextexample(
        tweetId BIGINT, username STRING,
        txt STRING, CreatedAt STRING,
        profileLocation STRING,
        favc BIGINT,retweet STRING,retcount BIGINT,followerscount BIGINT)
    COMMENT 'This is the Twitter streaming data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

	LOAD  DATA  INPATH  '/user/Twitterdata.txt' OVERWRITE INTO TABLE TwitterExampletextexample;
```
Here is the log that you can refer for exact steps.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/HiveHW_1.jpg)

Please run select * from this table to see the data.

###Step 2.   Let's create a table using RCfile format
Record Columnar(RC) format determines how to store relational tables on distributed computer clusters. With this format, you can get the advantages of a columnar format over row format of a record. 

#####Here is a sample Create RC file format table syntax:
```sql
    CREATE TABLE TwitterExampleRCtable(
        tweetId INT, username BIGINT,
        txt STRING, CreatedAt STRING,
        profileLocation STRING COMMENT 'Location of user',
        favc INT,retweet STRING,retcount INT,followerscount INT)
    COMMENT 'This is the Twitter streaming data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS RCFILE;
```
Here is the step on how to Load Data into the RC Table. Please execute and see the results.
```sql
INSERT OVERWRITE TABLE TwitterExampleRCtable select * from  TwitterExampletextexample;
```
Here are the logs of the exact steps.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_HW_step_2.jpg)

###Step 3.  Let's query the table we just created.
Let's find top 10 countries who tweeted most using TwitterExampleRCtable.
```sql
Select profileLocation, COUNT(txt) as count1 FROM TwitterExampleRCtable GROUP BY profileLocation ORDER BY count1 desc limit 10;
```
Please see the folloiwng log and the results:
![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_Hw_step_3.1.jpg)
![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_HW_step3.2.jpg)

###Step 4. Let's look at Managed tables vs External tables
Managed tables are created by default with CREATE TABLE statements, whereas External tables are used when you want your tables to point to data file in place. 

Here is the syntax for creating these tables.

```sql
Managed:
    CREATE TABLE ManagedExample(
        tweetId BIGINT, username STRING,
        txt STRING, CreatedAt STRING,
        profileLocation STRING,
        favc BIGINT,retweet STRING,retcount BIGINT,followerscount BIGINT)
    COMMENT 'This is the Twitter streaming data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;
External:
    CREATE EXTERNAL TABLE IF NOT EXISTS ExternalExample(
        tweetId BIGINT, username STRING,
        txt STRING, CreatedAt STRING,
        profileLocation STRING,
        favc BIGINT,retweet STRING,retcount BIGINT,followerscount BIGINT)
    COMMENT 'This is the Twitter streaming data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    location '/user/Twitterdata.txt';
```

Also, when you drop a Managed table, it deletes the data, and it also deletes the metadata.

When you drop an External table, it only deletes the metadata. 

As a next step, you could describe the above tables as below and compare the output with managed vs. external tables.

```sql 
describe formatted ManagedExample;
describe formatted ExternalExample;
```

###Step 5. Hive ORC File format.

Optimized Row Columnar (ORC) File format is used as it further compresses data files. It could result in a small performance loss in writing, but there will be huge performance gain in reading. 

Let's try it out. Please see that the table is stored as ORC.

```sql
    CREATE TABLE ORCFileFormatExample(
        tweetId INT, username BIGINT,
        txt STRING, CreatedAt STRING,
        profileLocation STRING COMMENT 'Location of user',
        favc INT,retweet STRING,retcount INT,followerscount INT)
    COMMENT 'This is the Twitter streaming data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS ORC tblproperties ("orc.compress"="GLIB");
```

###Step 6. Let's create a PARTITIONED Table and load data into.
Partitions are  horizontal slices of data which allow large sets of data to be segmented into more manageable blocks.
Here is the sample syntax to create a partitioned table and load data into partitions.

```sql
CREATE TABLE PARTITIONEDExample(
tweetId INT, username BIGINT, txt STRING,favc INT,retweet STRING,retcount INT,followerscount INT) COMMENT 'This is the Twitter streaming data' PARTITIONED BY(CreatedAt STRING, profileLocation STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
    
FROM twitterexampletextexample
INSERT OVERWRITE TABLE PARTITIONEDExample PARTITION (CreatedAt="26 04:50:56 UTC 2014",profileLocation="Chicago") SELECT tweetId,username,txt,favc,retweet,retcount,followerscount where profileLocation='Chicago' limit 100;
```
Here is the log from creating a table with ORC file format and a Partitioned table for your reference.

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_HW_step4.jpg)

![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_HW_step4.2.jpg
)
###Step 7. Let's create a table with Buckets.

Bucketing is a technique that allows to cluster or segment large sets of data to optimize query performance.

Here is an example for creating a table with buckets and load data into it.
```sql
    CREATE TABLE BucketingExample(
        tweetId INT, username BIGINT,
        txt STRING,CreatedAt STRING,favc INT,retweet STRING,retcount INT,                           followerscount INT)
    COMMENT 'This is the Twitter streaming data'
    PARTITIONED BY( profileLocation STRING)
    CLUSTERED BY(tweetId) INTO 2 BUCKETS
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;
    
    set hive.enforce.bucketing = true; 
    FROM twitterexampletextexample
    INSERT OVERWRITE TABLE BucketingExample PARTITION (profileLocation="Chicago")    SELECT tweetId,username,txt,CreatedAt,favc,retweet,retcount,followerscount       where profileLocation='Chicago' limit 100;
```
![](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_Hw_step5.1.jpg)
![enter image description here](http://hortonassets.s3.amazonaws.com/tutorial/hive/Hive_Hw_step_5.2.jpg)

You can go to hdfs folder and see the directory structure behind these Hive tables that you have just created. That could help you to design your tables and file distributions which is very important in designing your warehouse.

Hope, this was helpful and simple enough to give you a glimpse of the Hive world.


  [1]: http://hortonworks.com/sandbox
  [2]: http://hortonassets.s3.amazonaws.com/tutorial/hive/Twitterdata.txt
  