##Tutorial 14: Analyzing Machine and Sensor Data

**This tutorial is from the [Hortonworks Sandbox 2.0](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. [Download](http://hortonworks.com/products/sandbox) the Hortonworks Sandbox to run this and other tutorials in the series.**

### Introduction

This tutorial describes how to refine data from heating, ventilation,
and air conditioning (HVAC) systems using the Hortonworks Data Platform,
and how to analyze the refined sensor data to maintain optimal building
temperatures.

Demo: Here is the video of [Enable Predictive Analytics with
Hadoop](http://www.youtube.com/watch?v=Op_5MmG7hIw) as a demo of what
you'll be doing in this tutorial.

### Sensor Data

A sensor is a device that measures a physical quantity and transforms it
into a digital signal. Sensors are always on, capturing data at a low
cost, and powering the "Internet of Things."

### Potential Uses of Sensor Data

Sensors can be used to collect data from many sources, such as:

-   To monitor machines or infrastructure such as ventilation equipment,
    bridges, energy meters, or airplane engines. This data can be used
    for predictive analytics, to repair or replace these items before
    they break.
-   To monitor natural phenomena such as meteorological patterns,
    underground pressure during oil extraction, or patient vital
    statistics during recovery from a medical procedure.

In this tutorial, we will focus on sensor data from building operations.
Specifically, we will refine and analyze the data from Heating,
Ventilation, Air Conditioning (HVAC) systems in 20 large buildings
around the world.

### Prerequisites:

-   Hortonworks Sandbox (installed and running)
-   Hortonworks ODBC driver installed and configured

Refer to

-   [Tutorial 7: Installing and Configuring the Hortonworks ODBC driver
    on Windows 7](T07_Installing_the_Hortonworks_ODBC_Driver_on_Windows_7.md)
-   [Tutorial 11: Installing and Configuring the Hortonworks ODBC driver
    on Mac OS X](T11_Installing_the_Hortonworks_ODBC_driver_on_Mac_OSX.md)
-   Microsoft Excel 2013 Professional Plus

**Notes:**

-   In this tutorial, the Hortonworks Sandbox is installed on an Oracle
    VirtualBox virtual machine (VM) – your screens may be different.
-   Install the ODBC driver that matches the version of Excel you are
    using (32-bit or 64-bit).
-   In this tutorial, we will use the Power View feature in Microsoft
    Excel 2013 to visualize the sensor data. Power View is currently
    only available in Microsoft Office Professional Plus and Microsoft
    Office 365 Professional Plus.
-   Note, other versions of Excel will work, but the visualizations will
    be limited to charts. You can connect to any other visualization
    tool you like

### Overview

To refine and analyze HVAC sensor data, we will:

-   Download and extract the sensor data files.
-   Load the sensor data into the Hortonworks Sandbox.
-   Run two Hive scripts to refine the sensor data.
-   Access the refined sensor data with Microsoft Excel.
-   Visualize the sensor data using Excel Power View.

### Step 1: Download and Extract the Sensor Data Files

-   You can download the sample sensor data contained in a compressed
    (.zip) folder here:

    [SensorFiles.zip](http://s3.amazonaws.com/hw-sandbox/tutorial14/SensorFiles.zip)

-   Save the SensorFiles.zip file to your computer, then extract the
    files. You should see a SensorFiles folder that contains the
    following files:

-   HVAC.csv – contains the targeted building temperatures, along with
    the actual (measured) building temperatures. The building
    temperature data was obtained using Apache Flume. Flume can be used
    as a log aggregator, collecting log data from many diverse sources
    and moving it to a centralized data store. In this case, Flume was
    used to capture the sensor log data, which we can now load into the
    Hadoop Distributed File System (HFDS).  For more details on Flume,
    refer to Tutorial 13: Refining and Visualizing Sentiment Data

-   building.csv – contains the "building" database table. Apache Sqoop
    can be used to transfer this type of data from a structured database
    into HFDS.

### Step 2: Load the Sensor Data into the Hortonworks Sandbox

-   Open the Sandbox HUE and click the HCatalog icon in the toolbar at
    the top of the page, then click **Create a new table from a file**.

    ![](./images/tutorial-14/01_create_table.jpg?raw=true)

-   On the "Create a new table from a file" page, type "HVAC" in the
    Table Name box, then click **Choose a file** under the Input File
    box.

    ![](./images/tutorial-14/02_open_choose_file.jpg?raw=true)

-   On the "Choose a file" pop-up, click **Upload a file**.

    ![](./images/tutorial-14/03_choose_file_popup.jpg?raw=true)

-   Use the File Upload dialog to browse to the SensorFiles folder you
    extracted previously. Select the HVAC.csv file, then click **Open**.

    ![](./images/tutorial-14/04_file_upload_window.jpg?raw=true)

-   On the "Choose a file" pop-up, click the HVAC.csv file.

    ![](./images/tutorial-14/05_choose_file_HVAC.jpg?raw=true)

-   The default settings on the "Create a new table from a file" page
    are correct for this file, scroll down to the bottom of the page and
    click **Create table**.

    ![](./images/tutorial-14/06_create_table.jpg?raw=true)

-   A progress indicator appears while the table is being created.

    ![](./images/tutorial-14/07_creating_table_progress.jpg?raw=true)

-   When the table has been created, it appears in the HCatalog Table
    List.

    ![](./images/tutorial-14/08_HCat_hvac_table.jpg?raw=true)

-   Repeat the previous steps to create a "building" table by uploading
    the building.csv file.

    ![](./images/tutorial-14/09_HCat_hvac_and_building.jpg?raw=true)

-   Now let's take a look at the two data tables. On the HCatalog Table
    List page, select the check box next to the "hvac" table, then click
    **Browse Data**. We can see that the "hvac" table includes columns
    for date, time, the target temperature, the actual temperature, the
    system identifier, the system age, and the building ID.

    ![](./images/tutorial-14/10_hvac_table.jpg?raw=true)

-   Navigate back to the HCatalog Table List page. Select the check box
    next to the "building" table, then click **Browse Data**. We can see
    that the "building" table includes columns for the building
    identifier, the building manager, the building age, the HVAC product
    in the building, and the country in which the building is located.

    ![](./images/tutorial-14/11_building_table.jpg?raw=true)

### Step 3: Run Two Hive Scripts to Refine the Sensor Data

We will now use two Hive scripts to refine the sensor data. We hope to
accomplish three goals with this data:

-   Reduce heating and cooling expenses.
-   Keep indoor temperatures in a comfortable range between 65-70
    degrees.
-   Identify which HVAC products are reliable, and replace unreliable
    equipment with those models.

-   First, we will identify whether the actual temperature was more than
    five degrees different from the target temperature.

    In the Sandbox HUE, click the Beeswax (Hive UI) icon in the toolbar
    at the top of the page to display the Query Editor.

-   To view the data generated by the script, click **Tables** in the
    menu at the top of the page, select the checkbox next to
    `hvac_temperatures`, and then click **Browse Data**.

    ![](./images/tutorial-14/13_browse_data_hvac_temperatures.jpg?raw=true)

-   On the Query Results page, us the slider to scroll to the right. You
    will notice that two new attributes appear in the
    `hvac_temperatures` table.

    The data in the "temprange" column indicates whether the actual
    temperature was:

    -   **NORMAL** **–** within 5 degrees of the target temperature.
    -   **COLD** **–** more than five degrees colder than the target
        temperature.
    -   **HOT** **–** more than 5 degrees warmer than the target
        temperature.

    If the temperature is outside of the normal range, "extremetemp" is
    assigned a value of 1; otherwise its value is 0.

    ![](./images/tutorial-14/14_hvac_temperatures_table.jpg?raw=true)

-   Next we will combine the "hvac" and "hvac_temperatures" data sets.

    In the Sandbox HUE, click the Beeswax (Hive UI) icon in the toolbar
    at the top of the page to display the Query Editor.

-   To view the data generated by the script, click **Tables** in the
    menu at the top of the page, select the checkbox next to
    `hvac_building`, and then click **Browse Data**.

    ![](./images/tutorial-14/16_browse_data_hvac_building.jpg?raw=true)

-   The `hvac_temperatures` table is displayed on the Query Results
    page.

    ![](./images/tutorial-14/17_hvac_building_table.jpg?raw=true)

Now that we have refined the HVAC sensor data, we can access the data
with Microsoft Excel.

* * * * *

Step 4: Access the Refined Sensor Data with Microsoft Excel
--------------------------------------------------------------

In this section, we will use Microsoft Excel Professional Plus 2013 to
access the refined sentiment data.

-   In Windows, open a new Excel workbook, then select **Data > From
    Other Sources > From Microsoft Query**.

    ![](./images/tutorial-14/18_open_query.jpg?raw=true)

-   On the Choose Data Source pop-up, select the Hortonworks ODBC data
    source you installed previously, then click **OK**.

    The Hortonworks ODBC driver enables you to access Hortonworks data
    with Excel and other Business Intelligence (BI) applications that
    support ODBC.

    ![](./images/tutorial-14/19_choose_data_source.jpg?raw=true)

-   After the connection to the Sandbox is established, the Query Wizard
    appears. Select the "hvac_building" table in the Available tables
    and columns box, then click the right arrow button to add the entire
    "hvac_building" table to the query. Click **Next** to continue.

    ![](./images/tutorial-14/20_query_wizard1_choose_columns.jpg?raw=true)

-   On the Filter Data screen, click **Next** to continue without
    filtering the data.

    ![](./images/tutorial-14/21_query_wizard2_filter_data.jpg?raw=true)

-   On the Sort Order screen, click **Next** to continue without setting
    a sort order.

    ![](./images/tutorial-14/22_query_wizard3_sort_order.jpg?raw=true)

-   Click **Finish** on the Query Wizard Finish screen to retrieve the
    query data from the Sandbox and import it into Excel.

    ![](./images/tutorial-14/23_query_wizard4_finish.jpg?raw=true)

-   On the Import Data dialog box, click **OK** to accept the default
    settings and import the data as a table.

    ![](./images/tutorial-14/24_import_data.jpg?raw=true)

-   The imported query data appears in the Excel workbook.

    ![](./images/tutorial-14/25_data_imported.jpg?raw=true)

Now that we have successfully imported the refined sensor data into
Microsoft Excel, we can use the Excel Power View feature to analyze and
visualize the data.

### Step 5: Visualize the Sensor Data Using Excel Power View

We will begin the data visualization by mapping the buildings that are
most frequently outside of the optimal temperature range.

-   In the Excel worksheet with the imported "hvac_building" table,
    select **Insert > Power View** to open a new Power View report.

    ![](./images/tutorial-14/26_open_powerview_hvac_building.jpg?raw=true)

-   The Power View Fields area appears on the right side of the window,
    with the data table displayed on the left. Drag the handles or click
    the Pop Out icon to maximize the size of the data table.

    ![](./images/tutorial-14/27_powerview_hvac_building.jpg?raw=true)

-   In the Power View Fields area, select the checkboxes next to the
    **country** and **extremetemp** fields, and clear all of the other
    checkboxes. You may need to scroll down to see all of the check
    boxes.

    ![](./images/tutorial-14/28_select_country_extremetemp.jpg?raw=true)

-   In the FIELDS box, click the down-arrow at the right of the
    **extremetemp** field, then select **Count (Not Blank)**.

    ![](./images/tutorial-14/29_extremetemp_count_not_blank.jpg?raw=true)

-   Click **Map** on the Design tab in the top menu.

    ![](./images/tutorial-14/30_open_map.jpg?raw=true)

-   The map view displays a global view of the data. We can see that the
    office in Finland had 814 sensor readings where the temperature was
    more than five degrees higher or lower than the target temperature.
    In contrast, the German office is doing a better job maintaining
    ideal office temperatures, with only 363 readings outside of the
    ideal range.

    ![](./images/tutorial-14/31_extremetemp_map.jpg?raw=true)

-   Hot offices can lead to employee complaints and reduced
    productivity. Let's see which offices run hot.

    In the Power View Fields area, clear the **extremetemp** checkbox
    and select the **temprange** checkbox. Click the down-arrow at the
    right of the **temprange** field, then select **Add as Size**.

    ![](./images/tutorial-14/32_add_temprange_as_size.jpg?raw=true)

-   Drag **temprange** from the Power View Fields area to the Filters
    box, then select the **HOT** checkbox. We can see that the buildings
    in Finland and France run hot most often.

    ![](./images/tutorial-14/33_filter_by_temprange_hot.jpg?raw=true)

-   Cold offices cause elevated energy expenditures and employee
    discomfort.

    In the Filters box, clear the **HOT** checkbox and select the
    **COLD** checkbox. We can see that the buildings in Finland and
    Indonesia run cold most often.

    ![](./images/tutorial-14/34_filter_by_temprange_cold.jpg?raw=true)

-   Our data set includes information about the performance of five
    brands of HVAC equipment, distributed across many types of buildings
    in a wide variety of climates. We can use this data to assess the
    relative reliability of the different HVAC models.

-   Open a new Excel worksheet, then select **Data > From Other Sources
    > From Microsoft Query** to access the hvac_building table. Follow
    the same procedure as before to import the data, but this time only
    select the "hvacproduct" and "extremetemp" columns.

    ![](./images/tutorial-14/35_import_hvacproduct_extremetemp.jpg?raw=true)

-   In the Excel worksheet with the imported "hvacproduct" and
    "extremetemp" columns, select **Insert > Power View** to open a new
    Power View report.

    ![](./images/tutorial-14/36_open_powerview_hvacproduct.jpg?raw=true)

-   Click the Pop Out icon to maximize the size of the data table. In
    the FIELDS box, click the down-arrow at the right of the extremetemp
    field, then select Count (Not Blank).

    ![](./images/tutorial-14/37_extremetemp_count_not_blank.jpg?raw=true)

-   Select **Column Chart > Stacked Column**in the top menu.

    ![](./images/tutorial-14/38_open_stacked_column.jpg?raw=true)

-   Click the down-arrow next to **sort by hvacproduct** in the upper
    left corner of the chart area, then select **Count of extremetemp**.

    ![](./images/tutorial-14/39_sort_by_extremetemp.jpg?raw=true)

-   We can see that the GG1919 model seems to regulate temperature most
    reliably, whereas the FN39TG failed to maintain the appropriate
    temperature range 9% more frequently than the GG1919.

    ![](./images/tutorial-14/40_chart_sorted_by_extremetemp.jpg?raw=true)

We've shown how the Hortonworks Data Platform (HDP) can store and
analyze sensor data. With real-time access to massive amounts of
temperature and other types of data on HDP, your facilities department
can initiate data-driven strategies to reduce energy expenditures and
improve employee comfort.

**Feedback**

We are eager to hear your feedback on this tutorial. Please let us know
what you think. [Click here to take
survey](https://www.surveymonkey.com/s/Sandbox_Machine_Sensor)
