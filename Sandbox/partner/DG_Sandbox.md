> #    INTRODUCTION: Using DgSecure in the Hortonworks Sandbox
>     

Using DgSecure to discover and secure sensitive data is fairly straightforward and we
will describe the process through a set of use cases in this document, which will include:
* Defining Policy 
* Data Discovery
* Data Protection (Masking & Encryption for Unstructured/Structured Data)
* Bulk Decryption

> # INSTALLATION   

###Sandbox System Requirements

1. 32-bit and 64-bit OS (Linux, Windows XP, Windows 7, Windows 8).
2. Minimum 6GB memory available for VM, and minimum 10GB disc space
3. Virtualization enabled on BIOS
4. Browser: Chrome 25+, IE 9+ recommended. (Dataguise supports IE 10, however it is not supported in the Hortonworks Sandbox environment)

###Step 1: Install a virtualization environment (3 Options)

1. Go to the following site to download one of the VM environements; http://hortonworks.com/products/hortonworks-sandbox/#install


###Step 2: Download the Dataguise / Hortonworks Sandbox & License Key

 

1. To access and download the combined Sandbox, please visit http://dataguise.com/?q=sandbox-dataguise-hortonworks

2. There will be multiple files to download. Download ALL files to the same directory. 
3. Download the received license key to a local directory your
browser can access.
3. Once you’ve downloaded, unzip the first file 'Hortonworks_Sandbox_2.1.zip'.  Unzipping this file will unzip the remaining files.
3. Next, please start the VM (*Hortonworks_Sandbox_2.1*). Click inside the VM and follow the steps on the screen to start it up.

3. Then, continue on with the below steps.

- (To access Hue, go to <http://sandbox.hortonworks.com:8000>)


###Step 3: Apply DgSecure License & Sign In



1. Start the DgSecure Application (tomcat webserver)
    
    -   Lock into Sandbox (Alt+F5) 
    
    -   root/hadoop 
    
   

2. Go to this URL:
<https://sandbox.hortonworks.com:10182/dgadmin/login.html> (Make sure
your host file from where you are connecting to the DgSecure
application, is updated with the IP address of the sandbox,
sandbox.hortonworks.com)

- Enter username: **user1**

- Enter password: **Admin123**


![1](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic1.png)


5. Click Sign In

6. Click the license link on the left

7. Click the browse button on the right in the install license section, and
point to your downloaded license key and click OK, then click the install button.
####*DgSecure is now ready to use for 30 days*

![2](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic2.png)

**.......................................................**

> #USE CASES

###Use Case 1: Define Custom Policy


In this section we will be creating a custom policy that will be used
for discovery and masking in later steps.

Go to this URL:
[https://sandbox.hortonworks.com:10182/DgSecure/login.html](https://sandbox:10182/DgSecure/login.html)

Enter username: user1

Enter password: Admin123

![3](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic3.png)


Click Sign In

Click the Policy link on the left

Click the New Policy tab

![4](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic4.png)

Fill in the policy name: Sandbox

Fill in the Description field: Sandbox Tutorial Policy

Check the following sensitive elements and Masking Options:

- Address (Unstructured only), Random + Street Address
- Social Security \# (digits only), Random + Social Security Numbers + Digits Only + Valid Numbers
- Telephone (all), FPM
- Email Address, Character + Character \# + Left + 4

![5](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic5.png
)
Click Save

Policy is now created and ready to use.

We are now ready to utilize the policy, and we will be running different
tasks to explore the many features we have in our Hadoop product.

###Use Case 2: Run Discovery Jobs 

First we will start with a discovery task against unstructured data,
followed by a discovery task against structured data.


**UNSTRUCTURED DISCOVERY**

*Setup Unstructured Discovery Task*


Click on the Hadoop tab.

![6](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic6.png)

Click on the New Task tab.

In the new task tab, enter a name for your task. In this case we are
doing a discovery task, so we will name the task Sandbox Discovery.

Task Name: Sandbox Discovery-Text Files

Task Description: Sandbox Tutorial Discovery Task-Text Files

Task Type: Discovery only (select from the dropdown)

Select a Compliance Policy. We will be using Sandbox.

Select the directories you would like to discover sensitive data in. We
will be using the directories Consulting, HR, and Legal.

Click Save and Execute.

Below is a screenshot of the new/edit task page.

New/Edit Task-Discovery Text Files:

![7](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic7.png)

Discovery Result

Below are screenshots of the result pages.

Results For Discovery Task Text Files:

![8](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic8.png)


Detailed Results For Discovery Task Text Files:

Click on the Detailed Results tab

![9](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic9.png)


**STRUCTURED DISCOVERY**


***Setup Structures***

In this section will be running discovery against Sequence and Avro
files using the same policy as we defined earlier.

First we will have to create the structures for the 2 file types, and
then proceed with the same process as we did earlier to run the
discovery job. Please go to Hue, to download the jar and avsc files
needed to create the structures. They are located in the Jar directory.

**Create Structure for Sequence Files**

![10](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic10.png)

 

Click on Sequence Files under Structure Management.

Section 1: Add Structure

Structure Name (no spaces): PayrollSequenceStructure

Description (free text box): Payroll Sequence Structure

KeyClassName: This is provided with the sequence structure file, we will
be using: org.apache.hadoop.io.LongWritable

Value Type: Select SelfDefined

Select File: Select the jar file with the structure for the sequence
files.

Click Read File Structure.

Select the items you would like to search for sensitivity. We will be
searching:

SSNDigits-Sensitive Type dropdown will be Social Security \# (Digits
Only)

Phone-Sensitive Type dropdown will be Telephone (Digits Only)

Click Save.

 

**Section 2: Directories**

Browse the directory path with the sequence files you are creating the
structure for.

Assign the specific structure you created to that directory path.

![11](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic11.png)

 Click Save.

The Structure for the Sequence file is now ready to be used, and we now
need to create the structure for the Avro file.

### Create Structure for Avro Files

Click on Avro Files under Structure Management.

**Section 1: Add Structure**

![12](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic12.png)

Structure Name: PayrollAvroStructure

Description: Payroll Avro Structure

Browse File: Browse for the avsc file that is associated with that avro
structure you are creating

Click Read Structure.

Select the items you would like to search for sensitivity.

SSNDigits-Sensitive Type dropdown will be Social Security \# (Digits
Only)

Phone-Sensitive Type dropdown will be Telephone (Digits Only)

Click Save.


**Section 2: Directories**

Browse the directory path with the sequence files you are creating the
structure for.

Assign the specific structure you created to that directory path.

![13](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic13.png)

Click Save.

Now that we have created structures for each of the two file types, we
can create discovery tasks.

**Setup Sequence Files Discovery Task**

Click on the Hadoop tab.

Click on the New Task tab.

Task Name: Sandbox Discovery-Sequence

Task Description: Sandbox Tutorial Discovery Task-Sequence

Task Type: Discovery Only (select from the dropdown)

Select a Compliance Policy. We will be using Sandbox.

Select the directories you would like to discover sensitive data in. We
will be using the directory Sales.  

Click Save and Execute.

Below is a screenshot of the new/edit task page

New/Edit Task-Discovery Seq Files:

![14](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic14.png)


**Sequence Files Discovery Result**

Below are screenshots of the result pages.

![15](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic15.png)

Detailed Results For Discovery Task Seq Files:

![16](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic16.png)

**Setup Sequence Files Discovery Task**

Click on the Hadoop tab.

Click on the New Task tab.

Task Name: Sandbox Discovery-Avro

Task Description: Sandbox Tutorial Discovery Task-Avro

Task Type: Discovery Only (select from the dropdown)

Select a Compliance Policy. We will be using Sandbox.

Select the directories you would like to discover sensitive data in. We
will be using the directory Marketing.  

Click Save and Execute.

Below is a screenshot of the new/edit task page.

 New/Edit Task-Discovery Avro Files:

![17](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic17.png)

**Avro Files Discovery Result**

Below is the Results screens For Avro files Discovery:

![18](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic18.png)

 
Detailed Results For Discovery Task Avro Files:

![19](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic19.png)



 

###Use Case 3: Run Masking Jobs


**UNSTRUCTURED MASKING**


***Setup Output Directory***

Click on the Hadoop tab.

Before we setup an unstructured masking task, we first need to create an
Output Directory. The output directory is the directory where all the
masked files will be stored for a specific directory. If you don’t setup
an output directory, then the files will be created in the default
output directory according to the setting in the HDFS config file.  

Click on Output Directory.

Now, click on Add Source Directory. (We will do this for each of the
directories. Below is an example of what you will see while creating the
Output Directory for Consulting)

The source directory is the directory which holds the files you will
mask.

The Destination Directory is the directory where masked data will be
located.

The Branch Point is a branch off the destination directory if you would
like to place the masked files in a more specified folder.

![20](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic20.png)


Source Directory: /Consulting

Branch Point: /

Destination Directory: /SandboxMaskOut

Click Save.



***Next, Setup Unstructured Masking Task***

Now we are ready to create a Masking Task. Click Tasks.

Click Hadoop.

Click New Task.

Task Name: Sandbox Unstructured Masking

Task Description: Sandbox Tutorial Unstructured Masking

Task Type: Masking (Select from the dropdown)

Compliance Policy: Sandbox

Select Directories:

Consulting/Webinfo

Legal/license.txt

Click Save and Execute.

New/Edit Task-Unstructured Masking:

![21](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic21.png)


**Results for Unstructured Masking**


![22](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic22.png)

This is what your results page will look like once the task has
completed.

Results Overview:

This is the results overview. Here you can see the number of files that
were searched (blue=2), the number of files that were masked (green=2),
the number of sensitive data items found in those files (red=96), and a
pie chart with the breakdown of the different types of sensitive data
(these are the sensitive data we originally selected while creating our
policy).

Detailed Results:

![23](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic23.png)


These are the detailed results. Here we get a breakdown of which
sensitive data, with how many hit counts, we get from each file that was
searched.
 

**STRUCTURED MASKING**



***Setup Structure for CSV Files***

Now we will create an additional structure for CSV files in addition to
the 2 we have already defined.  We will use the 3 structures to run
masking and encryption tasks on structured data.

Create a Structure for Text Files (ex. CSV)

Click on Text Files under Structure Management.

Click Add Structure.

Section 1: Add Structure.

![24](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic24.png)



Section 2: Directories

![25](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic25.png)
 
Section 3: Add/Edit Column Info for a Structure

![26](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic26.png)
![27](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic27.png)


After all the three parts have been created, we need to assign the
columns to the structure and the directory. You must select Save
Structure in order for the column structures to be assigned to the
specific structure and directory.

![28](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic28.png)


**Run Structured Masking of a CSV File**

In Structured Masking, there are three option to how we write out the
masked files.

1.  Masked data can be added as new columns to the original data 

2.  Mask data can replace the original data 

3.  Mask data can be added within the column of the original data with
    a chosen delimiter.  


Let’s start with masking of the CSV file we just created a structure
for.

Click Hadoop.

Click New Task.
               

Task Name: Sandbox CSV Structured Masking

Task Description: Sandbox Tutorial CSV Structured Masking

Task Type: Masking

Structured: Click checkbox.

Output Column Form: Choose from Add column, Replace, Add within column

We will Replace the original data.

Compliance Policy: Sandbox

Select Directories: HR


New/Edit Task-Structured Masking on CSV File:

![29](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic29.png)

**Results for Structured Masking of a CSV File**

Results Overview:

![30](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic30.png)


Detailed Results:

![31](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic31.png)
     

**Run Structured Masking of a Sequence File**


Same procedure as for the CSV file

Task Name: Sandbox Seq Structured Masking

Task Description: Sandbox Tutorial Seq Structured Masking

Task Type: Masking

Structured: Click checkbox.

We will Replace the original data.

Compliance Policy: Sandbox

Select Directories: Sales

New/Edit Task-Structured Masking on Sequence File:

![32](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic32.png)


**Results for Structured Masking of a Sequence File**


Results Overview:

![33](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic33.png)

 

Detailed Results:

![34](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic34.png)

**Run Structured Masking of a Avro File**


Same procedure as for the CSV file

Task Name: Sandbox Avro Structured Masking

Task Description: Sandbox Tutorial Avro Structured Masking

Task Type: Masking

Structured: Click checkbox.

Output Column Form: Choose Replace

Compliance Policy: Sandbox

Select Directories: Sandbox/Marketing/payroll.avro


![35](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic35.png)

**Results for Structured Masking of a Avro File**


Results Overview:

![36](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic36.png)

 

Detailed Results:

![37](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic37.png)
> 
# Use Case 4: Run Encryption Jobs


**Domain Definition**


A domain is needed when a data set requires encryption or decryption. A
domain comprises a name, encryption key, one or more destination
directories, and one or more policies. Having a domain enables easier
management of encryption keys, policies, and ensures unique encryption
between different domains.  

**Setup a Domain for Unstructured Data**


Click Domain Definition.

Click Add Domain.

Domain Name: SandboxUnstructuredDomain

Description: Sandbox Tutorial Unstructured Domain

Encryption Key (chose):  hdfskey: AES 128 bits

FP Encryption Key: hdfskey: AES 128 bits

FP Encryption Salt: sandbox

(this is a free text box; the fp encryption salt is used to maintain
consistent encryption results through multiple domains and directories;
when the same encryption salt is used, the encrypted values will be the
same as the previous ones used with that salt, however if a new salt is
used, the values will change)

Click Save.

![38](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic38.png)

After creating a domain, we will have to add a directory to the domain.

Directory Path: The path in which we have the data we are looking to
encrypt. /Legal

Domain: Select the domain you would like to associate with that
Directory Path. SandboxUnstructuredDomain

Branch Point: There is a default branch point which will populate the
textbox, however we will use "/" in order to simplify the destination
path.

Destination Directory: The directory in which we will store the
encrypted file. This as well will be pre-populated with a default but we
will use: /SandboxEncryptOut

Click Save.

![39](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic39.png)


Now click on the domain to select it, click on the directory you would
like to use with that domain, and select a Compliance Policy, in our
case Sandbox, and click Save Policies to Domain in order to associate
that policy with the selected domain and directory.

![40](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic40.png)


Repeat for the Consulting Directory. We are now ready to create and
execute an Encryption Tasks.


**Run Unstructured Encryption Job**


Click Tasks under the Hadoop heading.

Click New Task.

Task Name: Sandbox Unstructured Field Encryption

Task Description: Sandbox Tutorial Unstructured Field Encryption

Task Type: Field Encryption

Compliance Policy: Sandbox

Manage Scan Locations: Click Select Directories

Select Consulting and Legal.

Select the directories and/or files that you would like to encrypt from
the file selection in the left panel. All files/directories selected
will be listed in the bottom portion of the page.

Click Done.

Click Save and Execute.

 
![41](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic41.png)



**Results Unstructured Encryption Job (Field Level)**


Results Overview:


![42](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic42.png)

 

Detailed Results:

![43](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic43.png)

**Setup a Domain for Structured Data**


Same steps as we went through setting up the domain for unstructured
data, except we will have different in- and output directories.  

Click Domain Definition.

Click Add Domain.

Domain Name (no spaces): SandboxStructuredDomain

Description: Sandbox Tutorial Structured Domain

Encryption Key (chose from the dropdown): hdfskey: AES 128 bits

FP Encryption Key (chose from the dropdown): hdfskey: AES 128 bits

FP Encryption Salt: sandbox

Click Save.

![44](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic44.png)



Directory Path: The path in which we have the data we are looking to
encrypt. /HR

Domain: Select the domain you would like to associate with that
Directory Path. SandboxStructuredDomain

Branch Point: There is a default branch point which will populate the
starting location of the output directory. We will use "/" in order to
simplify the destination path.

Destination Directory: The directory in which we will store the
encrypted file. We will use: /SandboxEncryptOut

![45](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic45.png) 


 
**Run Structured Encryption Job (Field Level)**

 
In this example we will use the structure we created for the CSV file
earlier, and encrypt the SSN and phone columns. (The process is exactly
the same if you want to encrypt the sequence file or the Avro file we
already have created structures for).  

Click Tasks under the Hadoop heading.

Click New Task.

Task Name: Sandbox CSV Structured Field Encryption

Task Description: Sandbox Tutorial CSV Structured Field Encryption

Task Type: Field Encryption

Structured: Click checkbox

Compliance Policy: Sandbox

Manage Scan Locations: Click Select Directories (/HR)

Select the directories and/or files that you would like to encrypt from
the file selection in the left panel. All files/directories selected
will be listed in the bottom portion of the page.

Click Done.

Click Save and Execute.


![46](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic46.png)


**Result Structured Encryption Job (Field Level)**


Results Overview:

![47](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic47.png)
 
Detailed Results:


![48](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic48.png)



> Use Case 5: Run Bulk Decryption Jobs
> ===========================

 

**ACL Management**


In order to do a decryption task, we first need to add a user and assign
sensitive elements that the user has privileges to decrypt. We will use
user hdfs, because we have configured our agent to run as hdfs.

**Setup ACL’s for User**



![49](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic49.png)

Click ACL Management

Click Add User

User Name: hdfs

Check: Social Security and Telephone

Click Save


**Update Encryption Domain to include Decryption**


We need to update the domain we defined earlier to include the directory
of the encrypted file, and where we want the decrypted file to go.


Click Domain Definition.

Click Domain Name: SandboxUnstructuredDomain

Click Add Directory

Source Directory: The path in which we have the data we are looking to
decrypt. /SandboxEncryptOut

Domains: SandboxUnstructuredDomain

Branch Point: "/"

Destination Directory: The directory in which we will store the
decrypted file. This as well will be pre-populated with a default but we
will use: /SandboxDecryptOut



![50](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic50.png)

Click Save

**Run Decryption Job**



Click HDFS Tasks

Click New Task

Task Name: SandboxDecryption

Task Description: Sandbox Tutorial Decryption

Task Type: Decryption

Compliance Policies: Sandbox

Select Directories: /SandboxEncryptOut




![51](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic51.png)

Click Save and Execute


**Results for Decryption Job**


Results Overview:


![52](http://dataguise.com/dgc/Sandbox/SandboxImages/Pic52.png)
The decrypted file can be found under the /SandboxDecryptOut directory.
