##Tutorial 13: Refining and Visualizing Sentiment Data

**This tutorial is from the [Hortonworks Sandbox 2.0](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.**

### Introduction

This tutorial describes how to refine raw Twitter data using the
Hortonworks Data Platform, and how to analyze and visualize this refined
sentiment data using the Power View feature in Microsoft Excel 2013.

Demo: Here is the video of [**Sentiment Analysis for Better
Decisions**](http://www.youtube.com/watch?v=y3nFfsTnY3M) as a demo of
what you'll be doing in this tutorial.

### Sentiment Data

Sentiment data is unstructured data that represents opinions, emotions,
and attitudes contained in sources such as social media posts, blogs,
online product reviews, and customer support interactions.

### Potential Uses of Sentiment Data

Organizations use sentiment analysis to understand how the public feels
about something at a particular moment in time, and also to track how
those opinions change over time.

An enterprise may analyze sentiment about:

-   A product – For example, does the target segment understand and
    appreciate messaging around a product launch? What products do
    visitors tend to buy together, and what are they most likely to buy
    in the future?
-   A service – For example, a hotel or restaurant can look into its
    locations with particularly strong or poor service.
-   Competitors – In what areas do people see our company as better than
    (or weaker than) our competition?
-   Reputation – What does the public really think about our company? Is
    our reputation positive or negative?

### Prerequisites:

-   Hortonworks Sandbox (installed and running)
-   Hortonworks ODBC driver installed and configured

Refer to:

-   [Tutorial 7: Installing and Configuring the Hortonworks ODBC driver
    on Windows 7](107.html)
-   [Tutorial 11: Installing and Configuring the Hortonworks ODBC driver
    on Mac OS X](111.html)
-   Microsoft Excel 2013 Professional Plus
-   Sentiment tutorial files (included)

**Notes:**

-   In this tutorial, the screenshots show the Hortonworks Sandbox is
    installed on an Oracle VirtualBox virtual machine (VM) – your
    screens may be different.
-   Install the ODBC driver that matches the version of Excel you are
    using (32-bit or 64-bit).
-   In this tutorial, we will use the Power View feature in Excel 2013
    to visualize the sentiment data. Power View is currently only
    available in Microsoft Office Professional Plus and Microsoft Office
    365 Professional Plus.
-   Note, other versions of Excel will work, but the visualizations will
    be limited to charts. You can connect to any other visualization
    tool you like

### Overview

To refine and visualize website sentiment data, we will:

-   Download and extract the sentiment tutorial files.
-   Load Twitter data into the Hortonworks Sandbox.
-   Copy a Hive script to the Sandbox.
-   Run the Hive script to refine the raw data.
-   Access the refined sentiment data with Excel.
-   Visualize the sentiment data using Excel Power View.

### Step 1: Download and Extract the Sentiment Tutorial Files

-   You can download a set of sample Twitter data contained in a
    compressed (.zip) folder here:

    [SentimentFiles.zip](http://s3.amazonaws.com/hw-sandbox/tutorial13/SentimentFiles.zip)

    The Twitter data was obtained using Hortonworks Flume. Flume can be
    used as a log aggregator, collecting log data from many diverse
    sources and moving it to a centralized data store. In this case,
    Flume was used to capture the Twitter stream data, which we can now
    load into the Hadoop Distributed File System (HFDS).

-   Save the SentimentFiles.zip file to your computer, and then extract
    the files. You should see a SentimentFiles folder.

### Step 2: Load Twitter Data into the Hortonworks Sandbox

We will now load Twitter data into the Sandbox.

To make things simpler we have prepared a zip file with all the data
files we need uploaded into the sandbox. Click on the File Browser tab
at the top and then select Upload -> Zip File.

![](./images/tutorial-13/4_upload_zip_file.jpg?raw=true)

You will see a file selection box and navigate into the SentimentFiles
folder. You will see a file called upload.zip. Select that and start the
upload.

![](./images/tutorial-13/5_pick_upload_file.jpg?raw=true)

The file will upload into the Sandbox VM and be automatically unpacked
into the directory.

![](./images/tutorial-13/6_uploading_zip.jpg?raw=true)

When the upload it complete you will see a new folder called upload.

![](./images/tutorial-13/7_zip_uploaded.jpg?raw=true)

### Step 3: Copy a Hive Script to the Sandbox

We will now use SCP to copy the hiveddl.sql file to the Sandbox. The
procedure is slightly different for Windows and Mac, so both methods are
described here.

### Mac OS X -- Copy the hiveddl.sql File to the Sandbox

-   Open a Terminal window and navigate to "SentimentFiles/upload/hive"
    subfolder in the SentimentFiles folder you extracted previously.
    Type in the following commands, then press the Enter key:

    `scp -P 2222 hiveddl.sql root@127.0.0.1:`

**Notes:**

-   You must use an uppercase "P" for the "-P" in this command.
-   You may be prompted to validate the authenticity of the host. If so,
    type "yes" when prompted.

-   When prompted, type in the Sandbox password ("hadoop"), then Press
    Enter. This command will copy the hiveddl.sql file to the root
    folder on the Sandbox.

    When the file transfer is complete, a confirmation message will
    appear in the terminal window:

-   Open WinSCP and type in the following settings, then click
    **Login**.
-   **Host name:** 127.0.0.1
-   **Port:** 2222
-   **User name:** root
-   Type the Sandbox password ("hadoop") in the Password box, then click
    **OK**.
-   Use the WinSCP file browser to navigate to the SentimentFiles\hive
    folder in the left-hand pane, and to the Sandbox /root folder in the
    right-hand pane.

    Drag-and-drop the hiveddl.sql file from the SentimentFiles\hive
    folder to the /root folder on the Sandbox.

### Step 4: Run the Hive Script to Refine the Raw Data

-   In the Hortonworks Sandbox virtual machine (VM) console window,
    press the Alt and F5 keys, then log in to the Sandbox using the
    following user name and password:

    Login: root Password: hadoop

    After you log in, the command prompt will appear with the prefix
    [root@sandbox \~]#:

-   At the command prompt, type in the following command, then press the
    Enter key:

    `hive -f hiveddl.sql`

-   Converted the raw Twitter data into a tabular format.
-   Used the dictionary file to score the sentiment of each Tweet by the
    number of positive words compared to the number of negative words,
    and then assigned a positive, negative, or neutral sentiment value
    to each Tweet.
-   Created a new table that includes the sentiment value for each
    Tweet.
-   Open the Sandbox HUE user interface, then click **HCatalog** in the
    menu at the top of the page. Select the check box next to the
    "tweetsbi" table, then click **Browse Data**. The "tweetsbi" table
    is the table created by the Hive script that added a column with the
    sentiment value for each tweet. (Note, you may need to scroll right
    to see all of the columns.)

* * * * *

Step 5: Access the Refined Sentiment Data with Excel
----------------------------------------------------

In this section, we will use Excel Professional Plus 2013 to access the
refined sentiment data.

-   In Windows, open a new Excel workbook, then select **Data > From
    Other Sources > From Microsoft Query**.
-   On the Choose Data Source pop-up, select the Hortonworks ODBC data
    source you installed previously, then click **OK**.

    The Hortonworks ODBC driver enables you to access Hortonworks data
    with Excel and other Business Intelligence (BI) applications that
    support ODBC.

-   After the connection to the Sandbox is established, the Query Wizard
    appears. Select the "tweetsbi" table in the Available tables and
    columns box, then click the right arrow button to add the entire
    "tweetsbi" table to the query. Click **Next** to continue.
-   Select the "text" column in the "Columns in your query" box, then
    click the left arrow button to remove the text column.
-   After the "text" column has been removed, click **Next** to
    continue.
-   On the Filter Data screen, click **Next** to continue without
    filtering the data.
-   On the Sort Order screen, click **Next** to continue without setting
    a sort order.
-   Click **Finish** on the Query Wizard Finish screen to retrieve the
    query data from the Sandbox and import it into Excel.
-   On the Import Data dialog box, click **OK** to accept the default
    settings and import the data as a table.
-   The imported query data appears in the Excel workbook.

* * * * *

Step 6: Visualize the Sentiment Data Using Excel Power View
-----------------------------------------------------------

Data visualization can help you optimize your website and convert more
visits into sales and revenue. In this section we will see how sentiment
varies by country, and review the sentiment data for the United States.

In the Excel worksheet with the imported "tweetsbi" table, select
**Insert > Power View** to open a new Power View report.

![](./images/tutorial-13/36_open_powerview_tweetsbi.jpg?raw=true)

The Power View Fields area appears on the right side of the window, with
the data table displayed on the left. Drag the handles or click the Pop
Out icon to maximize the size of the data table.

![](./images/tutorial-13/37_powerview_tweetsbi.jpg?raw=true)

In the Power View Fields area, clear the checkboxes next to the **id**
and **ts** fields, then click **Map** on the Design tab in the top menu.

![](./images/tutorial-13/38_open_map.jpg?raw=true)

The map view displays a global view of the data.

![](./images/tutorial-13/39_map_opened.jpg?raw=true)

Now let’s display the sentiment data by color. In the Power View Fields
area, click **sentiment**, then select **Add as Color**.

![](./images/tutorial-13/40_sentiment_add_as_color.jpg?raw=true)

Under SIZE, click **sentiment**, then select **Count (Not Blank)**.

![](./images/tutorial-13/41_sentiment_count_not_blank.jpg?raw=true)

-   Now the map displays the sentiment data by color:
-   Orange: positive
-   Blue: negative
-   Red: neutral

![](./images/tutorial-13/42_sentiment_by_color.jpg?raw=true)

Use the map controls to zoom in on Ireland. About half of the tweets
have a positive sentiment score, as indicated by the color orange.

![](./images/tutorial-13/43_ireland_sentiment.jpg?raw=true)

Now use the map controls to zoom in on Mexico. In Mexico, about
one-fifth of the tweets expressed negative sentiment (shown in blue),
and only a small portion of the tweets were positive. Most tweets from
Mexico were neutral, as shown in red.

![](./images/tutorial-13/44_mexico_sentiment.jpg?raw=true)

Next, use the map controls to zoom in on the sentiment data in China.
Marvel studios and the Chinese studio DMG co-financed *Iron Man 3*, and
the cast included a famous Chinese actress.

We can see that the majority of tweets from China are neutral, with
positive sentiment slightly outweighing negative sentiment.

![](./images/tutorial-13/45_china_sentiment.jpg?raw=true)

The United States is the biggest market, so let’s look at sentiment data
there. The size of the United States pie chart indicates that a
relatively large number of the total tweets come from the US.

About half of the tweets in the US show neutral sentiment, with a
relatively small amount of negative sentiment.

![](./images/tutorial-13/46_us_sentiment.jpg?raw=true)

We've shown a visualization of Twitter sentiment data for the release of
**Iron Man 3**. This information will be useful for planning marketing
activities for any future **Iron Man** movie releases.

**Feedback**

We are eager to hear your feedback on this tutorial. Please let us know
what you think. [Click
here](https://www.surveymonkey.com/s/Sandbox_Sentiment) to take survey
