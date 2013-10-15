## Community Tutorial 02: Using Spring XD to stream Tweets to Hadoop for Sentiment Analysis

**This tutorial is from the Community part of tutorial for [Hortonworks Sandbox](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.** 

###Summary

This tutorial will build on the previous tutorial - [13 - Refining and Visualizing Sentiment Data](../Sandbox/T13_Refining_And_Visualizing_Sentiment_Data.md) - by using Spring XD to stream in tweets to HDFS. Once in HDFS, we'll use Apache Hive to process and analyze them, before visualizing in a tool.

##1 - Download and Install Spring XD
Spring XD can be found at [http://spring.io](http://projects.spring.io/spring-xd/). This tutorial uses the 1.0.0.M3 version, so conventions may change in next release. 

Follow the install instructions and kick up Spring XD with a test stream to make sure it's looking good. 

	create stream --name ticktock --definition "Time | Log"

That simple instruction should begin showing output in the server terminal window similar to:

	2013-10-12 17:18:09
	2013-10-12 17:18:10
	2013-10-12 17:18:11
	2013-10-12 17:18:12
	2013-10-12 17:18:13
	2013-10-12 17:18:14
	
Congrats, Spring XD is running.

##2 - Download and Install Hortonworks Sandbox
The Hortonworks Sandbox environment can be downloaded from [http://hortonworks.com/products/sandbox](http://hortonworks.com/products/sandbox). This tutorial uses the 1.3 version, so conventions may change in the next release. This tutorial also uses the VirtualBox version of the image.

###Running Sandbox with Bridged Networking
The current Sandbox uses a NAT adapter with port forwarding by default. This makes it convenient to access Sandbox at 127.0.0.1:8888 but unfortunately, Spring XD appears to locate and attempt to use the internal IP address (in my case that was a fairly standard VirtualBox IP 10.0.2.15).
As this IP won't resolve, the simplest workaround is to use Bridged Networking so the Sandbox has an IP address on local physical network.

Steps to do this are as follows:

* Power off Sandbox
* Access the Network settings for the Sandbox.
* Disable the NAT Adapter

![./images/tutorial-02/screenshot.4.png?raw=true](./images/tutorial-02/screenshot.4.png?raw=true)

* Set-up a Bridged Adapter (and don't forget to change it back later if necessary)

![./images/tutorial-02/screenshot.3.png?raw=true](./images/tutorial-02/screenshot.3.png?raw=true)

* Power on Sandbox

**NB: Sandbox will still say access at 127.0.0.1, but owing to the changes is now incorrect. You can find the IP Address of the Sandbox as it loads:**

![./images/tutorial-02/screenshot.2.png?raw=true](./images/tutorial-02/screenshot.2.png?raw=true)

In my case, local IP was 10.0.0.27 and I could access the Sandbox at 10.0.0.27:8888.
Check you can do the same, and then we can configure SpringXD to use Sandbox.

###Configuring Spring XD to use Hadoop (Hortonworks Sandbox)
**NB: If you have Ambari activated on Sandbox, then both it and Spring XD attempt to use port 8080. This means you'll need to run Spring XD with a different port, for example:** `--httpPort 8090`

####Step 1 - Edit the Hadoop.properties file

Edit the file at `XD_HOME\xd\config\hadoop.properties` to enter the namenode config:
	
	fs.default.name=hdfs://10.0.0.27:8020

####Step 2 - Spin up the Spring XD Service with Hadoop

In a terminal window get the server running from the `XD_HOME\XD\` folder:

	./xd-singlenode --hadoopDistro hadoop11

####Step 3 - Spin up the Spring XD Client with Hadoop

In a separate terminal window get the shell running from the `XD_HOME\Shell\` folder:

	./xd-shell --hadoopDistro hadoop11

Then set the namenode for the client using the IP Address of the Sandbox:

	hadoop config fs --namenode hdfs://10.0.0.27:8020
	
Next, test out whether you can see HDFS with a command like:

	hadoop fs ls /
	
You should see something like:

	drwxr-xr-x   - hdfs   hdfs          0 2013-05-30 10:34 /apps
	drwx------   - mapred hdfs          0 2013-10-12 17:06 /mapred
	drwxrwxrwx   - hdfs   hdfs          0 2013-10-12 17:19 /tmp
	drwxr-xr-x   - hdfs   hdfs          0 2013-06-10 14:39 /user
	
Once that's confirmed we can set up a simple test stream. In this case, we can re-create TickTock but store it in HDFS.

	stream --name ticktockhdfs --definition "Time | HDFS"
	
Leave it a few seconds, then destroy or undeploy the stream.

	stream destroy --name ticktockhdfs
	
You can then view the small file that will have been generated in HDFS.

	hadoop fs ls /xd/ticktockhdfs
	
	Found 1 items
	-rwxr-xr-x   3 root hdfs        420 2013-10-12 17:18 /xd/ticktockhdfs/ticktockhdfs-0.log
	
Which you can quickly examine with:

	hadoop fs cat /xd/ticktockhdfs/ticktockhdfs-0.log

	2013-10-12 17:18:09
	2013-10-12 17:18:10
	2013-10-12 17:18:11
	2013-10-12 17:18:12
	2013-10-12 17:18:13
	2013-10-12 17:18:14

Cool, but not so interesting, so let's get to Twitter.

##3 - Create the Tweet Stream in Spring XD

In order to stream in information from Twitter, then you'll need to set-up a [Twitter Developer app](http://dev.twitter.com) so you can get the necessary keys.

Once you have the keys, you can add them to `XD_HOME\xd\config\twitter.properties`

In our case, we'll take a look at the stream of current opinion on that current icon of popular culture: Miley Cyrus. 
The stream can be set-up as follows with some simple tracking terms:
	
	stream create --name cyrustweets --definition "twitterstream --track='mileycyrus, miley cyrus' | hdfs"
	
You might want to build up these files for a little while. You can check in on the data at:

	hadoop fs ls  /xd/cyrustweets/

	Found 12 items
	-rwxr-xr-x   3 root hdfs    1002252 2013-10-12 19:33 /xd/cyrustweets/cyrustweets-0.log
	-rwxr-xr-x   3 root hdfs    1000126 2013-10-12 19:33 /xd/cyrustweets/cyrustweets-1.log
	-rwxr-xr-x   3 root hdfs    1004800 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-10.log
	-rwxr-xr-x   3 root hdfs          0 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-11.log
	-rwxr-xr-x   3 root hdfs    1003357 2013-10-12 19:33 /xd/cyrustweets/cyrustweets-2.log
	-rwxr-xr-x   3 root hdfs    1000903 2013-10-12 19:33 /xd/cyrustweets/cyrustweets-3.log
	-rwxr-xr-x   3 root hdfs    1000096 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-4.log
	-rwxr-xr-x   3 root hdfs    1001072 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-5.log
	-rwxr-xr-x   3 root hdfs    1001226 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-6.log
	-rwxr-xr-x   3 root hdfs    1000398 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-7.log
	-rwxr-xr-x   3 root hdfs    1001404 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-8.log
	-rwxr-xr-x   3 root hdfs    1006052 2013-10-12 19:34 /xd/cyrustweets/cyrustweets-9.log
	
The default rollover for the logs is 1MB so there are a lot of files. You might want to increase that or change other options.

After a cup of coffee or two, we should have some reasonable data to begin processing and refining. It took around 30 mins to generate 100MB of log files - clearly a fairly popular topic.

At this point, you can undeploy the stream so we can do some sample analysis:

	stream undeploy --name cyrustweets
	
We're now done with Spring XD. It's a fun way to pull in a [bunch of data from various sources](http://docs.spring.io/spring-xd/docs/1.0.0.BUILD-SNAPSHOT/reference/html/#sources). We can now switch over to Sandbox.

##4 - Refine the Data using Hive

To process and analyze the data, we'll borrow the technique [from the previous tutorial](../Sandbox/T13_Refining_And_Visualizing_Sentiment_Data.md). First of all, we can take a look in the File Browser to see the logs we've ingested.

![./images/tutorial-02/screenshot.1.png?raw=true](./images/tutorial-02/screenshot.1.png?raw=true)

Next, we need to position the reference files for the analysis. You can follow the steps (Step 1 and Step 2) in the previous tutorial to load in the `dictionary` file, and the `time_zone_map` file. If you've already completed that tutorial, then you have everything you need already in the Sandbox.

Next, let's run some Hive queries. 

###Create the Tables for the logos, dictionary and time zone map

In the [previous tutorial](../Sandbox/T13_Refining_And_Visualizing_Sentiment_Data.md), we had the luxury of pre-formatted files, but in this case, the incoming tweets are stored as JSON, so we need to use a JSON SerDe to process the files into tables. This [project on Github](https://github.com/rcongiu/Hive-JSON-Serde.git) provides a great JSON SerDe. We need to clone it, build it and then move it to the Sandbox. Use the following to build the JAR.

	git clone https://github.com/rcongiu/Hive-JSON-Serde.git
	cd Hive-JSON-Serde
	mvn package
	
This will place a JAR called `json-serde-1.1.7-jar-with-dependencies.jar` in the `target` folder.

This JAR is needed for the Hive queries we'll perform. To do that, we will create a new query, first loading the JAR by selecting 'Add File' > 'Upload File' and then finally selecting that JAR for use.

![./images/tutorial-02/screenshot.5.png?raw=true](./images/tutorial-02/screenshot.5.png?raw=true)

Once done, the following script creates a fresh table for the twitter logs:

	CREATE EXTERNAL TABLE cyrustweets_raw (
	   id BIGINT,
	   created_at STRING,
	   source STRING,
	   favorited BOOLEAN,
	   retweet_count INT,
	   retweeted_status STRUCT<
	      text:STRING,
	      user:STRUCT<screen_name:STRING,name:STRING>>,
	   entities STRUCT<
	      urls:ARRAY<STRUCT<expanded_url:STRING>>,
	      user_mentions:ARRAY<STRUCT<screen_name:STRING,name:STRING>>,
	      hashtags:ARRAY<STRUCT<text:STRING>>>,
	   text STRING,
	   user STRUCT<
	      screen_name:STRING,
	      name:STRING,
	      friends_count:INT,
	      followers_count:INT,
	      statuses_count:INT,
	      verified:BOOLEAN,
	      utc_offset:STRING,
	      time_zone:STRING>,
	   in_reply_to_screen_name STRING,
	   year int,
	   month int,
	   day int,
	   hour int
	)
	ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
	STORED AS TEXTFILE
	LOCATION '/xd/cyrustweets'
	
**NB. If you've already completed the previous tutorial, there's no need to recreate the next two tables. Note that the `LOCATION` paths may be different for you.**

	-- Add the dictionary table
	CREATE EXTERNAL TABLE dictionary (
	    type string,
   		length int,
    	word string,
    	pos string,
    	stemmed string,
    	polarity string
	)
	ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
	STORED AS TEXTFILE
	LOCATION '/user/hue/data/dictionary';

	-- Add the time zone map table
	CREATE EXTERNAL TABLE time_zone_map (
    	time_zone string,
    	country string,
    	notes string
	)
	ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
	STORED AS TEXTFILE
	LOCATION '/user/hue/data/time_zone_map';

### Refine the Data

With the essential data now in place, we can refine the data a little.

	CREATE VIEW cyrustweets_simple AS
	SELECT
  		id,
  		cast ( from_unixtime( unix_timestamp(concat( '2013 ', substring(created_at,5,15)), 
  		'yyyy MMM dd hh:mm:ss')) as timestamp) ts,
  		text,
  		user.time_zone 
	FROM cyrustweets_raw
	;

	CREATE VIEW cyrustweets_clean AS
	SELECT
  		id,
  		ts,
  		text,
  		m.country 
 	FROM cyrustweets_simple t 
 	LEFT OUTER JOIN time_zone_map m ON t.time_zone = m.time_zone;
 
### Run the Sentiment Analysis 
 
Then we'll create some views that can be used in the sentiment calculations.

	-- Compute sentiment
	CREATE VIEW l1 AS 
	SELECT 
		id, 
		words 
	FROM cyrustweets_raw LATERAL VIEW explode(sentences(lower(text))) dummy AS words;
	
	CREATE VIEW l2 AS 
	SELECT 
		id, 
		word 
	FROM l1 LATERAL VIEW explode( words ) dummy AS word ;

	CREATE VIEW l3 AS
	SELECT 
  		id, 
   		l2.word, 
    	CASE d.polarity 
    		WHEN  'negative' THEN -1
    		WHEN 'positive' THEN 1 
    		ELSE 0 
    	END AS polarity 
 	FROM l2 LEFT OUTER JOIN dictionary d ON l2.word = d.word;
 
 	CREATE VIEW tweets_sentiment AS
 	SELECT 
  		id, 
  		CASE 
    		WHEN sum( polarity ) > 0 THEN 'positive' 
    		WHEN sum( polarity ) < 0 THEN 'negative'  
    		ELSE 'neutral'
    	END AS sentiment 
 	FROM l3 GROUP BY id;
 	
 Finally, we execute the analysis.

	-- Put everything back together and re-number sentiment
	CREATE TABLE cyrustweetsanalysis
		STORED AS RCFile 
		AS
		SELECT 
  			t.*,
  			case s.sentiment 
    			when 'positive' then 2 
    			when 'neutral' then 1 
    			when 'negative' then 0 
  			end as sentiment  
		FROM cyrustweets_clean t 
		LEFT OUTER JOIN tweets_sentiment s on t.id = s.id;
		
Once this job has completed, then a quick browse of the data in `cyrustweetsanalysis` will show the results of the analysis.

![./images/tutorial-02/screenshot.7.png?raw=true](./images/tutorial-02/screenshot.7.png?raw=true)

##5 - Visualize the Data using Tool X

We've created the same table definition as in [Tutorial 13](../Sandbox/T13_Refining_And_Visualizing_Sentiment_Data.md), so you could now follow the rest of those instructions to visualize this data in PowerBI and Excel, or you could follow a tutorial for another [visualization tool such as Tableau](http://hortonworks.com/hadoop-tutorial/making-things-tick-with-tableau/).
