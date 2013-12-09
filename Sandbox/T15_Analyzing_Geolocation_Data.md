##Tutorial 15: Analyzing Geolocation Data

**This tutorial is from the [Hortonworks Sandbox 2.0](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.**

### Introduction

This tutorial describes how to refine data for a Geo Location use case
using the Hortonworks Data Platform. Geo Location use cases involve
vehicles/devices/people moving across a map or similar surface. Your
analysis is interested in tying together location information with your
analytic data.

For our tutorial we are looking at a use case where we have a truck
fleet. Each truck has been equipped to log location and event data.
These events are streamed back to a datacenter where we will be
processing the data.

Demo: Here is the video of [Analyzing Geolocation
Data](http://youtu.be/n8fdYHoEEAM) to show you what you'll be doing in
this tutorial.

### Tutorial scenario and process

In this tutorial we will be providing the collected geo location data
and the data from the trucks. We will import this data into HDFS and
build tables in HCatalog. Then we will process the data using Pig and
Hive. The processed data is then imported in Microsoft Excel where we
can do the visualizations.

### Prerequisites:

-   Hortonworks Sandbox (installed and running)
-   Hortonworks ODBC driver installed and configured - see the tutorial
    on installing the EDBC driver for Windows or OS X

Refer to

-   [Installing and Configuring the Hortonworks ODBC driver on Windows
    7](107.html)
-   [Installing and Configuring the Hortonworks ODBC driver on Mac OS
    X](111.html)
-   Microsoft Excel 2013 Professional Plus is required for the Windows 7
    or later installation to be able to construct the maps.

**Notes:**

-   In this tutorial, the Hortonworks Sandbox is installed on an Oracle
    VirtualBox virtual machine (VM) – your screens may be different.
-   Install the ODBC driver that matches the version of Excel you are
    using (32-bit or 64-bit).
-   We will use the Power View feature in Microsoft Excel 2013 to
    visualize the sensor data. Power View is currently only available in
    Microsoft Office Professional Plus and Microsoft Office 365
    Professional Plus.
-   Note, other versions of Excel will work, but the visualizations will
    be limited to charts or graphs. You can also use other visualization
    tool.

### Overview

To refine and analyze Geo Location data, we will:

-   Download and extract the Geo Location data files.
-   Load the captured data into the Hortonworks Sandbox.
-   Run a Hive and Pig scripts that computes truck mileage and driver
    risk factor.
-   Access the refined sensor data with Microsoft Excel.
-   Visualize the sensor data using Excel Power View.

### Step 1: Download and Extract the Sensor Data Files

-   You can download the sample sensor data contained in a compressed
    (.zip) folder here:

    [Geolocation.zip](http://s3.amazonaws.com/hw-sandbox/tutorial15/Geolocation.zip)

-   Save the Geolocation.zip file to your computer, then extract the
    files. You should see a Geolocation folder that contains the
    following files:

-   geolocation.csv – This is the collected geolocation data from the
    trucks. it contains records showing truck location, date, time, type
    of event, speed, etc.

-   trucks.csv – This is data taken from a relational data base and it
    shows info on truck model, driverid, truckid, and aggregated mileage
    info.

### Step 2: Load the Sensor Data into the Hortonworks Sandbox

-   Open the Sandbox HUE and click the HCatalog icon in the toolbar at
    the top of the page, then click **Create a new table from a file**.

    ![](./images/tutorial-15/01_create_table.jpg?raw=true)

-   On the "Create a new table from a file" page, type "trucks" in the
    Table Name box, then click **Choose a file** under the Input File
    box.

    ![](./images/tutorial-15/02_create_trucks.jpg?raw=true)

-   On the "Choose a file" pop-up, click **Upload a file**.

    ![](./images/tutorial-15/03_choose_file.jpg?raw=true)

-   Use the File Upload dialog to browse to the SensorFiles folder you
    extracted previously. Select the trucks.csv file, then click
    **Open**. This will return you to the "Choose a file screen". Select
    trucks.csv.

    ![](./images/tutorial-15/04_pick_trucks.jpg?raw=true)

-   Now you see the page where you will define the file. You will see
    that HCatalog automatically picked up the column headers and
    formats.

    ![](./images/tutorial-15/05_create_trucks.jpg?raw=true)

-   The default settings on the "Create a new table from a file" page
    are correct for this file, scroll down to the bottom of the page and
    click **Create table**.

    ![](./images/tutorial-15/06_define_trucks.jpg?raw=true)

-   A progress indicator appears while the table is being created.

    ![](./images/tutorial-15/07_importing_data.jpg?raw=true)

-   When the table has been created, it appears in the HCatalog Table
    List.

    ![](./images/tutorial-15/08_trucks_table_done.jpg?raw=true)

-   Repeat the previous steps to create a "geolocation" table by
    uploading the geolocation.csv file.

    ![](./images/tutorial-15/09_geolocation_table_done.jpg?raw=true)

-   Now let's take a look at the two data tables. On the HCatalog Table
    List page, select the check box next to the "trucks" table, then
    click **Browse Data**. We can see that the "trucks" table includes
    columns for driverid, truckid, model, mileage and gas.

    ![](./images/tutorial-15/10_trucks_data.jpg?raw=true)

-   Navigate back to the HCatalog Table List page. Select the check box
    next to the "geolocation" table, then click **Browse Data**. We can
    see that the "geolocation" table includes columns for driverid,
    truckid, event, location, etc.

    ![](./images/tutorial-15/11_geolocation_data.jpg?raw=true)

### Step 3: Run Hive Queries to Refine the Trucks data to get the average mileage

-   We now want to calculate the miles per gallon for each truck. We
    will start with our truck data table.
    ![](./images/tutorial-15/12_trucks_data_to_start.jpg?raw=true)
-   We need to sum up all the miles and gas columns on a per truck
    basis. Hive has a series of functions that can be used to reformat a
    table. The keyword LATERAL VIEW is how we invoke things. The stack
    function allows us to restructure the data into 3 columns labeled
    rdate, gas and mile with 54 rows. We pick truckid, driverid from our
    original table.

    ![](./images/tutorial-15/13_ComputeTruckMileage.jpg?raw=true)

-   Here is the code that you can cut and paste into the Query editor.

    `CREATE TABLE truck_mileage  AS SELECT truckid, driverid, rdate, miles, gas, miles / gas mpg   FROM  trucks    LATERAL VIEW  stack(   54,   'jun13',jun13_miles,jun13_gas,'may13',may13_miles,may13_gas,'apr13',apr13_miles,apr13_gas,'mar13',mar13_miles,mar13_gas,'feb13',feb13_miles,feb13_gas,'jan13',jan13_miles,jan13_gas,'dec12',dec12_miles,dec12_gas,'nov12',nov12_miles,nov12_gas,'oct12',oct12_miles,oct12_gas,'sep12',sep12_miles,sep12_gas,'aug12',aug12_miles,aug12_gas,'jul12',jul12_miles,jul12_gas,'jun12',jun12_miles,jun12_gas,'may12',may12_miles,may12_gas,'apr12',apr12_miles,apr12_gas,'mar12',mar12_miles,mar12_gas,'feb12',feb12_miles,feb12_gas,'jan12',jan12_miles,jan12_gas,'dec11',dec11_miles,dec11_gas,'nov11',nov11_miles,nov11_gas,'oct11',oct11_miles,oct11_gas,'sep11',sep11_miles,sep11_gas,'aug11',aug11_miles,aug11_gas,'jul11',jul11_miles,jul11_gas,'jun11',jun11_miles,jun11_gas,'may11',may11_miles,may11_gas,'apr11',apr11_miles,apr11_gas,'mar11',mar11_miles,mar11_gas,'feb11',feb11_miles,feb11_gas,'jan11',jan11_miles,jan11_gas,'dec10',dec10_miles,dec10_gas,'nov10',nov10_miles,nov10_gas,'oct10',oct10_miles,oct10_gas,'sep10',sep10_miles,sep10_gas,'aug10',aug10_miles,aug10_gas,'jul10',jul10_miles,jul10_gas,'jun10',jun10_miles,jun10_gas,'may10',may10_miles,may10_gas,'apr10',apr10_miles,apr10_gas,'mar10',mar10_miles,mar10_gas,'feb10',feb10_miles,feb10_gas,'jan10',jan10_miles,jan10_gas,'dec09',dec09_miles,dec09_gas,'nov09',nov09_miles,nov09_gas,'oct09',oct09_miles,oct09_gas,'sep09',sep09_miles,sep09_gas,'aug09',aug09_miles,aug09_gas,'jul09',jul09_miles,jul09_gas,'jun09',jun09_miles,jun09_gas,'may09',may09_miles,may09_gas,'apr09',apr09_miles,apr09_gas,'mar09',mar09_miles,mar09_gas,'feb09',feb09_miles,feb09_gas,'jan09',jan09_miles,jan09_gas  ) dummyalias AS rdate, miles, gas; `

    Once you have the code in the query editor execute it.

    ![](./images/tutorial-15/14_Query_editor_ComputeTruckMileage.jpg?raw=true)

-   To view the data generated by the script, click **Tables** in the
    menu at the top of the page, select the checkbox next to
    `truck_mileage`, and then click **Browse Data**. You see our table
    is now a list of each trip made by a truck.

    ![](./images/tutorial-15/15_truck_mileage.jpg?raw=true)

-   It is a very simple task to group the data by truckid and then take
    the average of the mpg values.

    Paste the following script in the Query Editor box, then click
    **Execute**:

    `CREATE TABLE avg_mileage AS  select truckid, avg(mpg) avgmpg from truck_mileage group by truckid;`

    Once the code has been copied into the Query editor you should
    execute it.

    ![](./images/tutorial-15/16_ComputeAvgMileage.jpg?raw=true)

-   To view the data generated by the script, click **Tables** in the
    menu at the top of the page, select the checkbox next to
    `avg_mileage`, and then click **Browse Data**.

    ![](./images/tutorial-15/17_Avg_Mileage.jpg?raw=true)

-   Now we have refined the truck data to get the average mpg for each
    truck.

    The next task is to computer the risk factor for each driver which
    is the total miles driven/abnormal events. We can get the event
    information from the geolocation table.

    ![](./images/tutorial-15/18_geolocation_data.jpg?raw=true)

-   If we look at the truck_mileage table we see we have the driverid
    and the number of miles for each trip. To get the total miles for
    each driver we can group those records by driverid and then sum the
    miles. This is a fairly common pattern in Hive and it is often
    called CTAS - create table as select. You can see we create the
    driver_mileage table using the select of the columns we want from
    truck_mileage. We specify to group the records by driverid and to
    sum the miles in the select statement. It will look like this:

    ![](./images/tutorial-15/19_ComputeDriverMileage1.jpg?raw=true)
    `create table DriverMileage as select driverid, sum(miles)totmiles from truck_mileage group by driverid;`

    You can copy the code from the box above into the Query editor and
    execute it to create the DriverMileage table. The results should
    look like:

    ![](./images/tutorial-15/20_drivermileage.jpg?raw=true)

-   Now we can compute the risk factor with this Pig script.

    ![](./images/tutorial-15/21_ComputeRiskFactor.jpg?raw=true)

-   Before we can run the code one of the requirements for the
    HCatStorer() function the table must already exist. The code expects
    the following structure for the riskfactor table.

    ![](./images/tutorial-15/22_riskfactor_table.jpg?raw=true)

    To create the table we select HCatalog from the top bar and then in
    the left column. This will start bring up this page.

    ![](./images/tutorial-15/23_create_table_manually.jpg?raw=true)

    Accept the defaults until Step 6 where you define the columns."

    ![](./images/tutorial-15/24_define_columns.jpg?raw=true)

    You will need to then define the columns in this order with these
    types. The script will fail if these are not done exactly right. Use
    the drop table function on the HCatalog page to delete riskfactor
    and rebuild it if there is an error. The columns are:

    -   driverid - type string
    -   events - type bigint
    -   totmiles - type bigint
    -   riskfactor - type float

    When you have defined the columns they should look like this.

    ![](./images/tutorial-15/25_create_columns.jpg?raw=true)
    ![](./images/tutorial-15/25.1_create_table.jpg?raw=true)

    click on the create table button at the bottom. You can verify the
    table structure by browsing the table in HCatalog. The browse data
    button will show an empty table. Clicking on the table name will
    show the table structure. Note the columns will be displayed
    alphabetically and not in the right order.

-   Now we can copy the code into the Pig editor. Here is the code and
    what it will look like once you paste it into the editor.

    `a = LOAD 'geolocation' using org.apache.hcatalog.pig.HCatLoader(); b = filter a by event != 'Normal'; c = foreach b generate driverid, event, (int) '1' as occurance; d = group c by driverid; e = foreach d generate group as driverid, SUM(c.occurance) as t_occ; g = LOAD 'drivermileage' using org.apache.hcatalog.pig.HCatLoader(); h = join e by driverid, g by driverid; describe h; dump h; final_data = foreach h generate $0 as driverid, $1 as events, $3 as totmiles, (float) $3/$1 as riskfactor; store final_data into 'riskfactor' using org.apache.hcatalog.pig.HCatStorer();`
    ![](./images/tutorial-15/26_run_ComputeRiskFactor.jpg?raw=true)

-   Before we execute the code let's look at what we are doing.

    -   The line a= loads the geolocation table from HCatalog.
    -   The line b= filters out all the rows where the event is not
        "Normal".
    -   Then we add a column called occurence and assign it a value of
        1.
    -   We then group the records by driverid and sum up the occurences
        for each driver.
    -   At this point we need the miles driven by each driver so we load
        the table we created using Hive
    -   To get our final result we join on the driverid the count of
        events in e with the mileage data in g.
    -   Now it is real simple to calculate the risk factor by dividing
        the miles driven by the numnber of events.

    Execute the code. The describe and dump statements will show you the
    interim results. You should see this in the results pane.

    ![](./images/tutorial-15/27_ComputeRiskFactor_output.jpg?raw=true)

-   Got to HCatalog and browse the data in the riskfactor table. Here is
    what is should look like.

    ![](./images/tutorial-15/28_riskfactor_table.jpg?raw=true)

-   At this point we now have our truck miles per gallon table and our
    risk factor table. The next step is to pull this data into Excel to
    create the charts for the visualization step.

* * * * *

Step 4: Access the Refined Data with Microsoft Excel
----------------------------------------------------

-   In this section, we will use Microsoft Excel Professional Plus 2013
    to access the refined data. We will be using the ODBC connection you
    have set up before we started this tutorial. Open the ODBC
    connection manager and open the connection you setup up. It should
    look like this. Click on the test button and it should report
    success. If the test fails you will need to troubleshoot the
    connection before you can go on.

    ![](./images/tutorial-15/29_check_ODBC_connection.jpg?raw=true)

-   Open a new blank workbook. Select Data tab at the top then select
    "Get External Data" and then select "From Other Data Sources". Then
    at the bottom select "From MIcrosoft Query". This is just like you
    did in the previous tutorials. Choose your data source and ours is
    called Hadoop and you will then see the Query Wizard. We will import
    the truck_mileage table.

    ![](./images/tutorial-15/30_import_avg_mileage.jpg?raw=true)

-   Accept the defaults for everything and click through till you hit
    the Finish button. After you click on Finish, Excel will send the
    data request over to Hadoop. It will take awhile for this to happen.
    When the data is returned it will ask you to place the data in the
    workbook. We want to be in cell \$A\$1 like this.

    ![](./images/tutorial-15/31_place_the_data.jpg?raw=true)

-   Once the data is placed you will see the avg_mileage table imported
    into your spreadsheet.

    ![](./images/tutorial-15/32_data_in_spreadsheet.jpg?raw=true)

-   So now we are going to insert a Power View report. We do this by
    selecting the "Insert" tab at the top and select "Power View
    Reports" button in the middle. This will create a new tab in your
    workbook with the data inserted in the Power View page."

    ![](./images/tutorial-15/33_insert_powerview.jpg?raw=true)

-   Select the design tab at the top and then select a column chart and
    use the stacked column version in the drop down menu. This will give
    you a bar chart. Grab the lower right of the chart and stretch it
    out to the full pane. Close the filter tab and the chart will exand
    and look like this.

    ![](./images/tutorial-15/34_power_view.jpg?raw=true)

-   So to finish off the tutorial I am going to create a map of the
    events reported in the geolocation table. I will show you how you
    can build up the queries and create a map of the data on an ad hoc
    basis.

    For a map we need location information and a data point. Looking at
    the geolocation table I will simply plot the location of each of the
    events. I will need the driverid, city and state columns from this
    table. We know that the select statement will let me extract these
    columns. So to start off I can just create the select query in the
    Query Editor. ![](./images/tutorial-15/35_select_data.jpg?raw=true)

-   After I execute the query I see what results are returned. In a more
    complex query you can easily make changes to the query at this point
    till you get the right results. So the results I get back look like
    this.

    ![](./images/tutorial-15/36_select_results.jpg?raw=true)

-   Since my results look fine I now need to capture the result in a
    table. So I will use the select statement as part of my CTAS (create
    table select as) pattern. I will call the table events and the query
    now looks like this.

    ![](./images/tutorial-15/37_CreateEvents.jpg?raw=true)

-   I can execute the query and the table events gets created. As we saw
    earlier I can go to Excel and import the table into a blank
    worksheet. The imported data will look like this.

    ![](./images/tutorial-15/38_import_events.jpg?raw=true)

-   Now I can insert the PowerView tab in the Excel workbook. To get a
    map I just select the Design tab at the top and select the Map
    button in the menu bar.

    ![](./images/tutorial-15/39_events_power_view.jpg?raw=true)

-   Make sure you have a network connection because Power View using
    Bing to do the geocoding which translates the city and state columns
    into map co-ordinates. If we just want to see where events took
    place we can uncheck the driverid. The finished map looks like this.
    ![](./images/tutorial-15/40_map.jpg?raw=true)

We've shown how the Hortonworks Data Platform (HDP) can store and
analyze geolocation data. In addition I have shown you a few techniques
on building your own queries. You can easily plot risk factor and miles
per gallon as bar charts. I showed you the basics of creating maps. A
good next step is to only plot certain types of events. Using the
pattern I gave you it is pretty straight forward to extract the data and
visualize it in Excel.

**Feedback**

We are eager to hear your feedback on this tutorial. Please let us know
what you think. [Click here to take
survey](https://www.surveymonkey.com/s/Sandbox_Machine_Sensor)
