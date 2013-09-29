## Community Tutorial 01: Using RHadoop to predict visitors amount

**This tutorial is from the Community part of tutorial for [Hortonworks Sandbox](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.** 

### Summary

This tutorial describes how to use RHadoop on Hortonworks Daata Platform, how to facilitate using R on Hadoop to create powerful analytics platform.  

### Clickstream Data

Clickstream data is an information trail a user leaves behind while
visiting a website. It is typically captured in semi-structured website
log files.

Clickstream data has been described in already exisiting tutorial [10 - Visualizing Website Clickstream Data](../Sandbox/T10_Visualizing_Website_Clickstream_Data.md). In this tutorial the same dataset will be used. So, it must be uploaded into `omniturelogs` table.  


### R Language

[![](./images/tutorial-01/Rlogo.png?raw=true)](./images/tutorial-01/Rlogo.png?raw=true)
R is language for Stats, Math and Data Science created by statisticians for statisticians. It contains 5000+ implemented algorithms and 
impressive 2M+ users with domain knowledge worldwide. However, it has one big disadvantage - all data is placed into memory ... and procesed in one thread.  

### Using R on Hadoop

Hadoop was developed in Java and Java is the main programming languages for Hadoop. Although Java is main language, you can still use any other language to write MR: for example, Python, R or Ruby. It is called "Streaming API". Of course, not all features available in Java will be available in R, because streaming works through "unix streams", not surprise here. Unfortunately, Streaming API is not easy to be used and that's why RHadoop has been created. It still uses streaming, but brings the following advantages:
* don’t need to manage key change in Reducer
* don’t need to control functions output manually
* simple MapReduce API for R
* enables access to files on HDFS 
* R code can be run on local env/Hadoop without changes  

RHadoop is set of packages for R language, it contains the next packages currently (you install and load this package the same as you would for any other R package):
* rmr provides MapReduce interface; mapper and reducer can be described in R code and then called from R
* rhdfs provides access to HDFS; using simple R functions, you can copy data between R memory, the local file system, and HDFS
* rhbase required if you are going to access HBase  

### Instalation

To enable RHadoop on existing Hadoop cluster the following steps must be applied:
1. install R on each node in Cluster
2. on each node install RHadoop packages with dependencies
3. set up env variables; run R from console and check that these variables are accessable  
				

Environment variables required for RHadoop is 'HADOOP_CMD' and 'HADOOP_STREAMING', details are described in [RHadoop Wiki](https://github.com/RevolutionAnalytics/RHadoop/wiki/rmr). To facilitate development, RStudio server is recommended to be installed. It provides the same GUI for development as standalone RStudio. RStudio WebUI accessible just after instalation at <host>:8787  

### Overview

We age going to predict number of visitors in the next period for each country/state using RHadoop.  

## Step 1. Create table with required data  

In the “Loading Data into the Hortonworks Sandbox” tutorial, we loaded website data files into Hortonworks. **Omniture logs*** – website log files containing information such as URL, timestamp, IP address, geocoded IP address, and user ID (SWID). First of all, we will create table with required data for us.  

[![](./images/tutorial-01/Omniture-hive.png?raw=true)](./images/tutorial-01/Omniture-hive.png?raw=true)  

## Step 2. Predict visitors number for new period  

In omniture dataset we have information from 2012-03-01 till 2012-03-15 (Hive query `select country, ts, count(*) from omniture_r group by country, ts`), for many countries there are gups, wich we a going to fill in with 0.