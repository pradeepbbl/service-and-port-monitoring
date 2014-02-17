Introduction

This is a simple perl5 based tool which helps to check services and ports status in a complex infrastructure environment using a simple configuration file and generate a user user friendly report.

    Prerequisite
    Setup
    How To 

Prerequisite

This section will describe the required application and module to setup this tool.

    Download and install Perl5. 

Required Perl Module

    Spreadsheet::WriteExcel
    Config::Simple
    IO::Socket::INET
    Crypt::CBC
    MIME::Base64 

Setup

Install the above prerequisite on the host machine which had access to all the client/app machine over SSH of all environment. Once the application are setup and tested download/check out the source code to a directory on host system.

Configuration Directive:-

The configuration file present in config folder named "config.cfg".

    [Env_List]:- Contain list of environment alias/reference name. Eg:- DEV,STG etc.

    [DEV_Service_List]:- Contain list of dev environment services alias/reference name. Eg:- Jboss7, Jboss7_0_1.

    [STG_Service_List]:- Contain list of stage environment services alias/reference name. Eg:- STG_Jboss_7, STG_Jboss_7_0_1.

    [Prod_Service_List]:- Contain list of prod environment services alias/reference name. Eg:- PROD_Jboss_7, PROD_Jboss_7_0_1.

    [Dev_Jboss]:- Contain list of jboss server IP. This filed can be adjust as per the application properties. This field was referred via "Hosted On" directive of application properties.

    [Jboss_7]:- Contain application properties like service name, command, port etc. This filed associated with [DEV_Service_List],[STG_Service_List] or [Prod_Service_List] and can be modify or adjust according to alias/reference name.

    Application Properties:-
    Service Name:- Contain name of application.

    Port List:- Contain port's of application.

    Hosted On:- This filed refers to the application stack as mentioned above [Dev_Jboss].

    Command:- Contain combination of shell command in order to get the specific process data of application like process id etc. 

    Sample Application Entry:-
    [Jboss7]
    Service Name = jboss7
    Port List = 9090,19009
    Hosted On = Dev_Jboss?
    Command = "ps -eaf | grep -w /app/jboss7 | grep -w jboss | grep -v /bin/sh"

How-TO

This section will describe how to generate encrypted username and paasword for SSH etc and update the script.

    Generate encrypted Username/Password:- 

    In order to generate encrypted username/password go to utils folder of application and execute the encrypt.pl script.
    #./encrypt.pl <username> <key> ---> Produce encrypted username.
    #./encrypt.pl <password> <key> ---> Produce encrypted password.

    Once you have the encrypted username and password go to libs folder open Main.pm file in a text editor update the value of $hash_user and $hash_pass (line no 61 and 62) with encrypted username and password.

    Note:- Please use same key to generate both username and password. Don't share the key with anyone.

    How to run the script:- 

    To run the script go to the application root folder and run service_monitor.pl with environment name and key (used above to generate the username and password) as command line argument.

    Eg:- #./service_monitor.pl DEV Eyf007HK (Make sure the environment DEV was listed under [Env_List]) 