Red Gate Continuous Integration.

This zip file contains:

*The free TFS and MSBuild scripts
*The free NAnt build script
*The free sqlCI.exe tool
*The SQL Toolbelt command line tools used by sqlCI.exe


*The free TFS and MSBuild scripts*

The build scripts for TFS and MSBuild are sqlCI.proj and sqlCI.targets. Both scripts are needed whether you're using TFS or MSBuild.

To configure Red Gate Continuous Integration for TFS or MSBuild, open the sqlCI.targets file and set the appropriate options for your solution. Then point your build at the sqlCI.proj file.

sqlCI.exe and all the folders from sqlCI.zip must be in the same folder as sqlCI.proj and sqlCI.targets for the build to work because the build scripts call sqlCI.exe.

Using the sqlCI.proj and sqlCI.targets scripts without a license will start a 14 day trial of the command line tools. For more information about licensing, see the following webpage: 
http://www.red-gate.com/supportcenter/Content/Automation_with_Red_Gate_tools/help/1.0/ActivatingyourAutomationLicense


*The free NAnt build script*

The build script for NAnt is sqlCI.build.

To configure Red Gate Continuous Integration for NAnt, open the sqlCI.build file and set the appropriate options for your solution. Then point your build at the sqlCI.build file.

sqlCI.exe and all the folders from sqlCI.zip must be in the same folder as sqlCI.build for the build to work because the build script calls sqlCI.exe.

Using the sqlCI.build script without a license will start a 14 day trial of the command line tools. For more information about licensing, see the following webpage: 
http://www.red-gate.com/supportcenter/Content/Automation_with_Red_Gate_tools/help/1.0/ActivatingyourAutomationLicense


*The free sqlCI.exe tool*

sqlCI.exe is a free command line tool which acts as a wrapper for the SQL Toolbelt command line tools. Run 'sqlCI.exe /help' to get a list of command line options. You can use sqlCI.exe to set up Continuous Integration or other automation in a custom scenario.

If you're using MSBuild, TFS or NAnt, we recommend you use the build scripts provided in the sqlCI.zip folder.
If you're using TeamCity, we recommend using our TeamCity plugin available here: http://www.red-gate.com/products/sql-development/automation-license-for-continuous-integration/free-resources


*The SQL Toolbelt command line tools used by sqlCI.exe*

These are in the folders called:
*SC (SQL Compare)
*SDG (SQL Data Generator)
*SDOC (SQL Doc)
*sqlCmd (SQL Command, a Microsoft redistributable required for running SQL commands)
*msOdbcSql (Microsoft ODBC Driver for SQL Server, a Microsoft redistributable required for connectivity)

These tools require an Automation License. See http://www.red-gate.com/products/sql-development/automation-license-for-continuous-integration/licensing for more information on this and http://www.red-gate.com/supportcenter/Content/Automation_with_Red_Gate_tools/help/1.0/ActivatingyourAutomationLicense for more information on how to activate the license.

These tools do not automatically check for updates. When newer versions are available, they can be downloaded manually from the following page: http://www.red-gate.com/products/sql-development/automation-license-for-continuous-integration/free-resources
