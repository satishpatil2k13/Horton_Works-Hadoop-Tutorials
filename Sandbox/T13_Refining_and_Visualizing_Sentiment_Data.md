## Tutorial 13: Refining and Visualizing Sentiment Data

**This tutorial is from the [Hortonworks Sandbox](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.**

### Introduction

This tutorial describes how to refine raw Twitter data using the
Hortonworks Data Platform, and how to analyze and visualize this refined
sentiment data using the Power View feature in Microsoft Excel 2013.

Demo: Here is the video of [**Sentiment Analysis for Better
Decisions**](http://hortonworks.com/use-cases/sentiment-analysis-hadoop-example/)
as a demo of what you'll be doing in this tutorial.

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

In this tutorial, we will focus on a product launch. Specifically, we
will look at public sentiment during the days leading up to and
immediately following the recent release of the movie *Iron Man 3*.

How did the public feel about the debut, and how might that sentiment
data have been used to better promote the movie’s launch?

### Prerequisites:

-   Hortonworks Sandbox (installed and running)
-   Hortonworks ODBC driver installed and configured

Refer to:

-   [Tutorial 7: Installing and Configuring the Hortonworks ODBC driver on Windows 7](T07_Installing_the_Hortonworks_ODBC_Driver_on_Windws_7.md)
-   [Tutorial 11: Installing and Configuring the Hortonworks ODBC driver on Mac OS X](T11_Installing_the_Hortonworks_ODBC_driver_on_Mac_OSX.md)

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

###Step 1 – Download and Extract the Sentiment Tutorial Files

-   You can download a set of sample Twitter data contained in a
    compressed (.zip) folder here:

    [SentimentFiles.zip](http://s3.amazonaws.com/hw-sandbox/tutorial13/SentimentFiles.zip)

    The Twitter data was obtained using Hortonworks Flume. Flume can be
    used as a log aggregator, collecting log data from many diverse
    sources and moving it to a centralized data store. In this case,
    Flume was used to capture the Twitter stream data, which we can now
    load into the Hadoop Distributed File System (HFDS).

-   Save the SentimentFiles.zip file to your computer, and then extract
    the files. You should see a SentimentFiles folder that contains a
    loaddemo.sh file.

###Step 2 – Load Twitter Data into the Hortonworks Sandbox

We will now load Twitter data into the Sandbox.

-   Open the Sandbox HUE and click the File Browser icon in the toolbar
    at the top of the page, then click the first slash to the right of
    **Home** (and to the left of “user”) to navigate to the top level of
    the Sandbox file system.  

[![](./images/tutorial-13/04_select_top_level.jpg?raw=true)](./images/tutorial-13/04_select_top_level.jpg?raw=true)

-   Click **New**, then select **Directory**.

[![](./images/tutorial-13/05_new_directory.jpg?raw=true)](./images/tutorial-13/05_new_directory.jpg?raw=true)

-   On the Create Directory pop-up, type “data” in the Directory Name
    box, then click **Submit**.

[![](./images/tutorial-13/06_name_directory.jpg?raw=true)](./images/tutorial-13/06_name_directory.jpg?raw=true)

-   The “data” folder appears in the list of files.

[![](./images/tutorial-13/07_data_folder_created.jpg?raw=true)](./images/tutorial-13/07_data_folder_created.jpg?raw=true)

-   Click the “data” folder. In the “data” folder, use **New \>
    Directory** to create three folders with the names “dictionary”,
    “time\_zone\_map”, and “tweets”. You must use these exact names as
    the rest of the tutorial is based on these names.

[![](./images/tutorial-13/08_sub_folders_created.jpg?raw=true)](./images/tutorial-13/08_sub_folders_created.jpg?raw=true)

-   Click the “dictionary” folder. In the “dictionary” folder, click
    **Upload**, then select **Files**.

[![](./images/tutorial-13/09_upload_files.jpg?raw=true)](./images/tutorial-13/09_upload_files.jpg?raw=true)

-   On the Uploading pop-up, click **Select files**.

[![](./images/tutorial-13/10_upload_popup.jpg?raw=true)](./images/tutorial-13/10_upload_popup.jpg?raw=true)

-   Use the File Upload dialog to browse to the “data” folder in the
    SentimentFiles folder you extracted previously. Select the
    dictionary.tsv file, then click **Open**.

[![](./images/tutorial-13/11_file_upload_dialog.jpg?raw=true)](./images/tutorial-13/11_file_upload_dialog.jpg?raw=true)

-   The dictionary.tsv file will appear in the /data/dictionary folder.

[![](./images/tutorial-13/12_dictionary_tsv_uploaded.jpg?raw=true)](./images/tutorial-13/12_dictionary_tsv_uploaded.jpg?raw=true)

-   Navigate back up to the “data” folder. Use the same procedure to
    upload the time\_zone\_map.tsv file to the data/time\_zone\_map
    folder.

[![](./images/tutorial-13/13_time_zone_map_tsv_uploaded.jpg?raw=true)](./images/tutorial-13/13_time_zone_map_tsv_uploaded.jpg?raw=true)

-   Navigate back up to the “data” folder, then click the “tweets”
    folder. This folder contains all the tweets we collected. To keep
    things simple we will use a subset. Once you complete the tutorial
    you can upload the entire dataset and explore it. Select **Upload \>
    Files**, then click **Select files**.

    Use the File Upload dialog to browse to the
    SentimentFiles\\data\\tweets.rc folder. Select the “00” file, then
    Shift-click the “06” file to select files 00-06. Click **Open** to
    upload the files.

[![](./images/tutorial-13/14_select_files_00-06.jpg?raw=true)](./images/tutorial-13/14_select_files_00-06.jpg?raw=true)

-   A progress indicator appears while the files are being uploaded.

[![](./images/tutorial-13/15_upload_progress.jpg?raw=true)](./images/tutorial-13/15_upload_progress.jpg?raw=true)

-   When the upload is complete, files 00-06 will appear in the
    /data/tweets folder.

[![](./images/tutorial-13/16_files_00-06_uploaded.jpg?raw=true)](./images/tutorial-13/16_files_00-06_uploaded.jpg?raw=true)

###Step 3 – Copy a Hive Script to the Sandbox

We will now use SCP to copy the hiveddl.sql file to the Sandbox. The
procedure is slightly different for Windows and Mac, so both methods are
described here.

### Mac OS X -- Copy the hiveddl.sql File to the Sandbox

-   Open a Terminal window and navigate to “hive” subfolder in the
    SentimentFiles folder you extracted previously. Type in the
    following command, then press the Enter key:

    `scp -P 2222 hiveddl.sql root@127.0.0.1:`

**Notes:**

-   You must use an uppercase “P” for the “-P” in this command.
-   You may be prompted to validate the authenticity of the host. If so,
    type “yes” when prompted.

-   When prompted, type in the Sandbox password (“hadoop”), then Press
    Enter. This command will copy the hiveddl.sql file to the root
    folder on the Sandbox.

    When the file transfer is complete, a confirmation message will
    appear in the terminal window:

`    hiveddl.sql              100% 3368   3.3KB/s     00:00`

[![](./images/tutorial-13/17_mac_scp_complete.jpg?raw=true)](./images/tutorial-13/17_mac_scp_complete.jpg?raw=true)

### Windows 7: Copy the hiveddl.sql File to the Sandbox

On Windows you will need to download and install the free
[WinSCP](http://winscp.net/eng/index.php) application.

-   Open WinSCP and type in the following settings, then click
    **Login**.
-   **Host name:** 127.0.0.1
-   **Port:** 2222
-   **User name:** root

[![](./images/tutorial-13/18_scp_windows_login.jpg?raw=true)](./images/tutorial-13/18_scp_windows_login.jpg?raw=true)

-   Type the Sandbox password (“hadoop”) in the Password box, then click
    **OK**.

[![](./images/tutorial-13/19_scp_windows_password.jpg?raw=true)](./images/tutorial-13/19_scp_windows_password.jpg?raw=true)

-   Use the WinSCP file browser to navigate to the SentimentFiles\\hive
    folder in the left-hand pane, and to the Sandbox /root folder in the
    right-hand pane.

    Drag-and-drop the hiveddl.sql file from the SentimentFiles\\hive
    folder to the /root folder on the Sandbox.

[![](./images/tutorial-13/20_scp_windows_drag.jpg?raw=true)](./images/tutorial-13/20_scp_windows_drag.jpg?raw=true)

Click **Copy** on the Copy pop-up to confirm the file transfer.

[![](./images/tutorial-13/21_scp_windows_copy.jpg?raw=true)](./images/tutorial-13/21_scp_windows_copy.jpg?raw=true)

###Step 4 – Run the Hive Script to Refine the Raw Data

-   In the Hortonworks Sandbox virtual machine (VM) console window,
    press the Alt and F5 keys, then log in to the Sandbox using the
    following user name and password:

    Login: root\
     Password: hadoop

    After you log in, the command prompt will appear with the prefix
    [root@sandbox \~]\#:

-   At the command prompt, type in the following command, then press the
    Enter key:

    `hive -f hiveddl.sql`

Lines of text appear as the script runs a series of MapReduce jobs. It
will take a few minutes for the script to finish running. When the
script has finished running, the time taken is displayed, and the normal
command prompt appears.

[![](./images/tutorial-13/22_hiveddl_sql_complete.jpg?raw=true)](./images/tutorial-13/22_hiveddl_sql_complete.jpg?raw=true)

The hiveddl.sql script has performed the following steps to refine the
data:

-   Converted the raw Twitter data into a tabular format.
-   Used the dictionary file to score the sentiment of each Tweet by the
    number of positive words compared to the number of negative words,
    and then assigned a positive, negative, or neutral sentiment value
    to each Tweet.
-   Created a new table that includes the sentiment value for each
    Tweet.

Let's use HCatalog to take a quick look at the data.

-   Open the Sandbox HUE user interface, then click **HCatalog** in the
    menu at the top of the page. Select the check box next to the
    “tweets\_raw” table, then click **Browse Data**.

[![](./images/tutorial-13/23_select_tweets_raw.jpg?raw=true)](./images/tutorial-13/23_select_tweets_raw.jpg?raw=true)

-   The “tweets\_raw” table was created by the Hive script from the raw
    Twitter data. You should see columns with data for creation time,
    the number of re-tweets, the tweet content, the user name, and other
    Twitter data.

[![](./images/tutorial-13/24_tweets_raw_table.jpg?raw=true)](./images/tutorial-13/24_tweets_raw_table.jpg?raw=true)

-   Click **HCatalog** in the menu at the top of the page, select the
    check box next to the “tweetsbi” table, and then click **Browse
    Data**. The “tweetsbi” table is the table created by the Hive script
    that includes a column with the sentiment value for each tweet.
    (Note, you may need to scroll right to see all of the columns.)

[![](./images/tutorial-13/25_tweetsbi_table.jpg?raw=true)](./images/tutorial-13/25_tweetsbi_table.jpg?raw=true)

Now that we have refined Twitter data in a tabular format with sentiment
ratings, we can access the data with Excel.

Step 5 – Access the Refined Sentiment Data with Excel
-----------------------------------------------------

In this section, we will use Excel Professional Plus 2013 to access the
refined sentiment data.

-   In Windows, open a new Excel workbook, then select **Data \> From
    Other Sources \> From Microsoft Query**.

[![](./images/tutorial-13/26_open_query.jpg?raw=true)](./images/tutorial-13/26_open_query.jpg?raw=true)

-   On the Choose Data Source pop-up, select the Hortonworks ODBC data
    source you installed previously, then click **OK**.

    The Hortonworks ODBC driver enables you to access Hortonworks data
    with Excel and other Business Intelligence (BI) applications that
    support ODBC.

[![](./images/tutorial-13/27_choose_data_source.jpg?raw=true)](./images/tutorial-13/27_choose_data_source.jpg?raw=true)

-   After the connection to the Sandbox is established, the Query Wizard
    appears. Select the “tweetsbi” table in the Available tables and
    columns box, then click the right arrow button to add the entire
    “tweetsbi” table to the query. Click **Next** to continue.

[![](./images/tutorial-13/28_query_wizard1.jpg?raw=true)](./images/tutorial-13/28_query_wizard1.jpg?raw=true)

-   Select the “text” column in the “Columns in your query” box, then
    click the left arrow button to remove the text column.

[![](./images/tutorial-13/29_query_wizard2.jpg?raw=true)](./images/tutorial-13/29_query_wizard2.jpg?raw=true)

-   After the “text” column has been removed, click **Next** to
    continue.

[![](./images/tutorial-13/30_query_wizard3.jpg?raw=true)](./images/tutorial-13/30_query_wizard3.jpg?raw=true)

-   On the Filter Data screen, click **Next** to continue without
    filtering the data. \

[![](./images/tutorial-13/31_query_wizard4.jpg?raw=true)](./images/tutorial-13/31_query_wizard4.jpg?raw=true)

-   On the Sort Order screen, click **Next** to continue without setting
    a sort order.

[![](./images/tutorial-13/32_query_wizard5.jpg?raw=true)](./images/tutorial-13/32_query_wizard5.jpg?raw=true)

-   Click **Finish** on the Query Wizard Finish screen to retrieve the
    query data from the Sandbox and import it into Excel.

[![](./images/tutorial-13/33_query_wizard6.jpg?raw=true)](./images/tutorial-13/33_query_wizard6.jpg?raw=true)

-   On the Import Data dialog box, click **OK** to accept the default
    settings and import the data as a table.

[![](./images/tutorial-13/34_import_data.jpg?raw=true)](./images/tutorial-13/34_import_data.jpg?raw=true)

-   The imported query data appears in the Excel workbook.

[![](./images/tutorial-13/35_data_imported.jpg?raw=true)](./images/tutorial-13/35_data_imported.jpg?raw=true)

Now that we have successfully imported the Twitter sentiment data into
Microsoft Excel, we can use the Excel Power View feature to analyze and
visualize the data.

Step 6 – Visualize the Sentiment Data Using Excel Power View
------------------------------------------------------------

Data visualization can help you optimize your website and convert more
visits into sales and revenue. In this section we will see how sentiment
varies by country, and review the sentiment data for the United States.

-   In the Excel worksheet with the imported “tweetsbi” table, select
    **Insert \> Power View** to open a new Power View report.

[![](./images/tutorial-13/36_open_powerview_tweetsbi.jpg?raw=true)](./images/tutorial-13/36_open_powerview_tweetsbi.jpg?raw=true)

-   The Power View Fields area appears on the right side of the window,
    with the data table displayed on the left. Drag the handles or click
    the Pop Out icon to maximize the size of the data table.

[![](./images/tutorial-13/37_powerview_tweetsbi.jpg?raw=true)](./images/tutorial-13/37_powerview_tweetsbi.jpg?raw=true)

-   In the Power View Fields area, clear the checkboxes next to the
    **id** and **ts** fields, then click **Map** on the Design tab in
    the top menu.

[![](./images/tutorial-13/38_open_map.jpg?raw=true)](./images/tutorial-13/38_open_map.jpg?raw=true)

-   The map view displays a global view of the data.

[![](./images/tutorial-13/39_map_opened.jpg?raw=true)](./images/tutorial-13/39_map_opened.jpg?raw=true)

-   Now let’s display the sentiment data by color. In the Power View
    Fields area, click **sentiment**, then select **Add as Color**.

[![](./images/tutorial-13/40_sentiment_add_as_color.jpg?raw=true)](./images/tutorial-13/40_sentiment_add_as_color.jpg?raw=true)

-   Under SIZE, click **sentiment**, then select **Count (Not Blank)**.

[![](./images/tutorial-13/41_sentiment_count_not_blank.jpg?raw=true)](./images/tutorial-13/41_sentiment_count_not_blank.jpg?raw=true)

-   Now the map displays the sentiment data by color:

-   Orange: positive
-   Blue: negative
-   Red: neutral

[![](./images/tutorial-13/42_sentiment_by_color.jpg?raw=true)](./images/tutorial-13/42_sentiment_by_color.jpg?raw=true)

-   Use the map controls to zoom in on Ireland. About half of the tweets
    have a positive sentiment score, as indicated by the color orange.

[![](./images/tutorial-13/43_ireland_sentiment.jpg?raw=true)](./images/tutorial-13/43_ireland_sentiment.jpg?raw=true)

-   Now use the map controls to zoom in on Mexico. In Mexico, about
    one-fifth of the tweets expressed negative sentiment (shown in
    blue), and only a small portion of the tweets were positive. Most
    tweets from Mexico were neutral, as shown in red.

[![](./images/tutorial-13/44_mexico_sentiment.jpg?raw=true)](./images/tutorial-13/44_mexico_sentiment.jpg?raw=true)

-   Next, use the map controls to zoom in on the sentiment data in
    China. Marvel studios and the Chinese studio DMG co-financed *Iron
    Man 3*, and the cast included a famous Chinese actress.

    We can see that the majority of tweets from China are neutral, with
    positive sentiment slightly outweighing negative sentiment.

[![](./images/tutorial-13/45_china_sentiment.jpg?raw=true)](./images/tutorial-13/45_china_sentiment.jpg?raw=true)

-   The United States is the biggest market, so let’s look at sentiment
    data there. The size of the United States pie chart indicates that a
    relatively large number of the total tweets come from the US.

    About half of the tweets in the US show neutral sentiment, with a
    relatively small amount of negative sentiment.

[![](./images/tutorial-13/46_us_sentiment.jpg?raw=true)](./images/tutorial-13/46_us_sentiment.jpg?raw=true)

We've shown a visualization of Twitter sentiment data for the release of
**Iron Man 3**. This information will be useful for planning marketing
activities for any future **Iron Man** movie releases.
