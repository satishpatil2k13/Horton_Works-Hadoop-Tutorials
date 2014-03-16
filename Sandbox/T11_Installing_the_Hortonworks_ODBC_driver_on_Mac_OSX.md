##Tutorial 11: Installing and Configuring the Hortonworks ODBC driver on Mac OS X

**This tutorial is from the [Hortonworks Sandbox 2.0](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. [Download](http://hortonworks.com/products/sandbox) the Hortonworks Sandbox to run this and other tutorials in the series.**

### Summary

This document describes how to install and configure the Hortonworks
ODBC driver on Mac OS X. After you install and configure the ODBC
driver, you will be able to access Hortonworks sandbox data using Excel.

In this procedure, we will use Microsoft Excel 2011 to access
Hortonworks Sandbox data. You should also be able to access sandbox data
using other versions of Excel. The process may not be identical in other
versions of Excel, but it should be similar.

### Prerequisites:

-   Mac running OS X
-   Hortonworks Sandbox 1.2 (installed and running)
-   Excel 2011

### Overview:

To install and configure the Hortonworks ODBC driver on Mac OS X:

-   Download and install the Hortonworks ODBC driver for Mac OS X.
-   Download and install the iODBC Driver Manager for Mac OS X.
-   Configure the Hortonworks ODBC driver
-   Open Excel and test the connection to the Hortonworks Sandbox.

### Adding an extra network interface for ODBC

In order for ODBC to work we will have to add a private network between
your laptop and the Sandbox Virtual Machine. If the Sandbox VM is
running halt it.

Once the VM has been halted open the Virtual Box console. Select
Preferences from the Menu bar at the very top of the screen.

![Load](./images/odbcifc/101_vb_prefs.jpg?raw=true)

The preferences window for Virtual Box will open up.

![Load](./images/odbcifc/102_prefs_screen.jpg?raw=true)

Select Network and click on the Add icon on the right. Then click on the
screwdriver icon to configure the network. Virtual Box will assign an
IPv4 Address and subnet.

![Load](./images/odbcifc/103_config_host_only.jpg?raw=true)

Click on the DHCP Server tab and configure the DHCP server. When you are
done click OK on this screen and OK on the Network screen. This will
return you back to the Virtual Box console screen.

![Load](./images/odbcifc/104_config_dhcp.jpg?raw=true)

Now select your VM and cick on the Settings button. This will open the
Setting screen for your VM. Select Network at the top.

![Load](./images/odbcifc/105_vm_settings.jpg?raw=true)

Now select Adapter 2. Click on the Enable Network Adapter box. It should
be filled in to attach on the Host-only Adapter you created in the
Virtual Box preferences. Click OK to close the window.

![Load](./images/odbcifc/106_enable_2nd_adapter.jpg?raw=true)

Boot your VM. Once the Sandbox screen shows on the console hit Alt-F5 to
get a login and login as root/hadoop. Type ifconfig and look for eth1.
The IP address of Eth1 is the address you will use as the IP address
when you configure the ODBC connection.

![Load](./images/odbcifc/107_find_ip.jpg?raw=true)

* * * * *

Step 1: Download and Install the Hortonworks ODBC Driver for Mac OS X
---------------------------------------------------------------------

-   Open a web browser and navigate to
    [http://hortonworks.com/products/hdp-2/\#add\_ons](http://hortonworks.com/products/hdp-2/#add_ons).
-   On the Add-Ons page, scroll down to Hortonworks Hive ODBC Driver
    (Windows + Mac) and select **Mac OS X (dmg)**.

    ![](./images/tutorial-11/02_addons_page.jpg?raw=true)

-   Review the Hortonworks license, then click **Accept Agreement**.

    ![](./images/tutorial-11/03_license_agreement.jpg?raw=true)

-   A confirmation message appears. Click **OK** to open the file with
    the Disk Image Mounter.

    ![](./images/tutorial-11/04_confirm_dmg.jpg?raw=true)

-   When the download is complete, the driver package will appear in a
    new window. Double-click (or right-click with the mouse) the driver
    package, then select **Open**.

    ![](./images/tutorial-11/05_open_dmg_submenu.jpg?raw=true)

-   To start the installation, click **Continue** on the ODBC Driver
    Installer Welcome screen.

    ![](./images/tutorial-11/06_installer1.jpg?raw=true)

-   Review the license agreement, then click **Continue**.

    ![](./images/tutorial-11/07_installer2.jpg?raw=true)

-   Click **Agree** on the pop-up message to agree to the license terms.

    ![](./images/tutorial-11/08_installer3.jpg?raw=true)

-   Click **Install** to accept the default installation folder.

    ![](./images/tutorial-11/09_installer4.jpg?raw=true)

-   A progress indicator appears while the driver is being installed.

    ![](./images/tutorial-11/10_installer5.jpg?raw=true)

-   When the installation is complete, the Driver Installer displays a
    confirmation message. Click **Close** to close the installer.

    ![](./images/tutorial-11/11_installer6.jpg?raw=true)

Now that you have installed the Hortonworks ODBC driver for Mac OS X,
the next step is to install the iODBC Driver Manager for Mac OS X.

* * * * *

Step 2: Download and Install the iODBC Driver Manager for Mac OS X
------------------------------------------------------------------

-   Open a web browser and navigate to:

    [http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/Downloads](http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/Downloads)

    Scroll down to the Mac OS X section and select the applicable
    installer package.

    **Note:** In this tutorial, we successfully installed the latest
    available version of the iODBC driver for Mac OS X (10.5 Leopard,
    10.6 Snow Leopard) on a MacBook Pro running OS X 10.8.3.

    ![](./images/tutorial-11/12_download_iodbc.jpg?raw=true)

-   Click **Save File** on the confirmation pop-up message.

    ![](./images/tutorial-11/13_save_file.jpg?raw=true)

-   When the installer file download is complete, double-click the file,
    then select **Open**.

    ![](./images/tutorial-11/14_open_dmg.jpg?raw=true)

-   The driver package appears in a new window. Double-click the driver
    package, then select **Open**.

    ![](./images/tutorial-11/15_open_dmg2.jpg?raw=true)

-   To start the installation, click **Continue** on the ODBC Driver
    Installer Welcome screen.

    ![](./images/tutorial-11/16_iodbc_installer1.jpg?raw=true)

-   Review the Read Me information, then click **Continue**.

    ![](./images/tutorial-11/17_iodbc_installer2.jpg?raw=true)

-   Review the license agreement, then click **Continue**.

    ![](./images/tutorial-11/18_iodbc_installer3.jpg?raw=true)

-   Click **Agree** on the pop-up message to agree to the license terms.

    ![](./images/tutorial-11/19_iodbc_installer4.jpg?raw=true)

-   Click **Install** to accept the default installation folder.

    ![](./images/tutorial-11/19_iodbc_installer5.jpg?raw=true)

-   When the installation is complete, the Driver Installer displays a
    confirmation message. Click **Close** to close the installer.

    ![](./images/tutorial-11/20_iodbc_installer6.jpg?raw=true)

Now that you have installed the iODBC Driver Manager for Mac OS X, the
next step is to configure the Hortonworks ODBC .ini files.

* * * * *

Step 3: Configure the Hortonworks ODBC Driver
---------------------------------------------

### Overview

To configure the Hortonworks ODBC driver:

-   Enable the Finder to view hidden files.
-   Configure the Hortonworks ODBC .ini files.
-   Set the `DYLD\_LIBRARY\_PATH` environmental variable.

### Procedure

In this procedure we will need to work with files that start with a
period. Files that start with a period are considered to be hidden
files, and are not usually visible with the Finder. We will run two
Terminal commands to make these files visible with the Finder. Please
note that these commands are case-sensitive.

-   Open Finder (or click an empty portion of the desktop) to display
    the Finder menu at the top of the screen. Select **Go > Utilities
    >** **Terminal**, then click **Open** to open a Terminal window.
-   In the Terminal window, type in the following command, then press
    the Enter key:
-   In order for the changes to take effect, you must restart the
    Finder. To restart the Finder, type the following command in the
    Terminal window, then press the Enter key.

    `killall Finder`

    You will now be able to view hidden files using the Finder. If you
    would like to reset Finder later to hide hidden files, use the
    following Terminal commands to hide hidden files and restart the
    Finder:

    `defaults write com.apple.Finder AppleShowAllFiles FALSE  killall Finder`

-   Use **Go > Go to Folder** or the Finder to navigate to the
    `/usr/lib/hive/lib/native/hiveodbc/Setup` directory. The Setup
    directory contains the following sample files:
-   `odbc.ini` and `odbcinst.ini` – sample DSN setup files
-   `hortonworks.hiveodbc.ini` – sample Hortonworks driver configuration
    file
-   Copy the `hortonworks.hiveodbc.ini` to the Home directory and rename
    the file as `.hortonworks.hiveodbc.ini` (insert a period at the
    beginning of the file name).
-   In the Home directory, open the `.hortonworks.hiveodbc.ini` file
    with TextEdit in plain text mode. Confirm that the line containing
    the ODBCInstLib setting for the iODBC driver manager is uncommented
    (does not have a # symbol at the beginning of the line). The path
    should be set to the location of the `libiodbcinst.dylib` file by
    default.

    ![](./images/tutorial-11/21_hiveodbc_ini.jpg?raw=true)

-   Review the contents of the Home directory. If there are no .odbc.ini
    or .odbcinst.ini files in the Home directory, copy the odbc.ini and
    .odbcinst.ini files from the
    `/usr/lib/hive/lib/native/hiveodbc/Setup` folder to the Home
    directory.

-   Rename the files to .odbc.ini and .odbinst.ini (insert a period at
    the beginning of the file name).

-   Use TextEdit in plain text mode to edit the configuration settings
    in the `.odbc.ini` file. The host settings should be set to the IP
    address of the sandbox. PORT should be set to 10000 (the default
    listening port). HS2AuthMech should be set to 2, and UserName should
    be set to the sandbox user name (in this case, the default user name
    "hue").

    ![](./images/tutorial-11/22_odbc_ini.jpg?raw=true)

-   If there is already an `.odbc.ini` or `.odbcinst.ini` file in the
    Home directory, copy the relevant settings from the `odbc.ini` and
    `.odbcinst.ini` sample files in the
    `/usr/lib/hive/lib/native/hiveodbc/Setup` folder to the files in the
    Home directory. Configure the settings as described in the previous
    step.

-   The final step is to add the `/usr/lib/hive/lib/native/universal`
    directory to the `DYLD\_LIBRARY\_PATH` environment variable. Open a
    Terminal window and type the following command, then press the Enter
    key:

`Launchctl setenv DYLD\_LIBRARY\_PATH /usr/lib/hive/lib/native/universal`

This command will set the `DYLD\_LIBRARY\_PATH` variable only for the
current session – you will need to run the command again each time you
log in. To permanently set the `DYLD\_LIBRARY\_PATH` environmental
variable, navigate to the `/etc` folder and add the following line to
the `launchd.conf` file:

`setenv DYLD\_LIBRARY\_PATH /usr/lib/hive/lib/native/universal`

If there is no `launchd.conf` file in the `/etc` folder, you can use
TextEdit to create a `launchd.txt` file, then rename it to
`launchd.conf`

**Note:** You may need to be logged in as an administrator to edit files
in the `/etc` folder.

Now that you have configured the Hortonworks ODBC driver, the next step
is to open Excel and test the connection to the Hortonworks Sandbox.

* * * * *

Step 4: Open Excel and Test the Connection to the Hortonworks Sandbox
---------------------------------------------------------------------

-   Open a new Excel workbook, then select **Data > Get External Data
    > New Database Query**.
-   On the iODBC Data Source Chooser window, select the Hortonworks ODBC
    data source, then click **Test**.

    ![](./images/tutorial-11/23_choose_data_source.jpg?raw=true)

-   On the Login pop-up, type "sandbox" in the Username box, then click
    **Ok**.

    ![](./images/tutorial-11/24_data_source_login.jpg?raw=true)

-   It may take several seconds for the connection to be established.
    After the connection is established, a confirmation message appears.
    Click **OK** to close the message.

    ![](./images/tutorial-11/25_dsn_success.jpg?raw=true)

Now that you have configured the Hortonworks ODBC driver, you can use
Excel to access data in the Hortonworks Sandbox.

-   Open a new Excel workbook, then select **Data > Get External Data
    > New Database Query**.
-   On the iODBC Data Source Chooser window, select the Hortonworks ODBC
    data source, then click **OK**.
-   On the Login pop-up, type "sandbox" in the Username box, then click
    **Ok**. The Microsoft Query window and the Tables pop-up box appear.

    ![](./images/tutorial-11/26_microsoft_query.jpg?raw=true)

-   In the Tables pop-up box, select a table, then click **Add Table**.
    The table will appear in the top section of the Microsoft Query
    window. It may take several seconds for the table to appear.

**Notes**

-   The tables listed in the pop-up have been previously created in the
    Sandbox with a **Create new table** command using either HCatalog or
    Beeswax (**Beeswax >Tables**).
-   In this tutorial, we selected the omniture table previously created
    in the "Loading Data into the Hortonworks Sandbox" tutorial, but you
    can select any available table.

    ![](./images/tutorial-11/27_select_omniture.jpg?raw=true)

-   To preview the table data, select the table in the Field drop-down,
    then click **Test**. The data will appear in the lower section of
    the Microsoft Query window. It may take several seconds for the data
    to appear.

    ![](./images/tutorial-11/28_preview_omniture.jpg?raw=true)

-   To import the data into Excel, click **Return Data** at the bottom
    right of the Microsoft Query Window, then click **OK** on the
    Returning Data to Microsoft Excel pop-up box.

    ![](./images/tutorial-11/29_return_data.jpg?raw=true)

-   The table data will appear in the Excel workbook.

    ![](./images/tutorial-11/30_excel_data.jpg?raw=true)

**Feedback**

We are eager to hear your feedback on this tutorial. Please let us know
what you think. [Click here to take
survey](https://www.surveymonkey.com/s/Connect_to_ODBC)
