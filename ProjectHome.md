# Introduction #

This is a simple perl5 based tool which helps to check services and ports status in a complex infrastructure environment using a simple configuration file and generate a user user friendly report.

  * [Prerequisite](#Prerequisite.md)
  * [Setup](#Setup.md)
  * [How To](#How-TO.md)

# Prerequisite #

This section will describe the required application and module to setup this tool.

  1. Download and install [Perl5](http://www.perl.org/get.html).

**Required Perl Module
  1. [Spreadsheet::WriteExcel](http://search.cpan.org/~jmcnamara/Spreadsheet-WriteExcel-2.38/lib/Spreadsheet/WriteExcel.pm)
  1. [Config::Simple](http://search.cpan.org/~sherzodr/Config-Simple-4.59/Simple.pm)
  1. [IO::Socket::INET](http://search.cpan.org/~gbarr/IO-1.25/lib/IO/Socket/INET.pm)
  1. [Crypt::CBC](http://search.cpan.org/~lds/Crypt-CBC-2.32/CBC.pm)
  1. [MIME::Base64](http://search.cpan.org/~gaas/MIME-Base64-3.13/Base64.pm)**

# Setup #
Install the above prerequisite on the host machine which had access to all the client/app machine over SSH of all environment. Once the application are setup and tested download/check out the source code to a directory on host system.

<b>Configuration Directive:-</b>
<p>The configuration file present in config folder named "config.cfg".<p>

<blockquote><b><code>[Env_List]</code></b>:- Contain list of environment alias/reference name. Eg:- DEV,STG etc.<br><br>
<b><code>[DEV_Service_List]</code></b>:- Contain list of dev environment services alias/reference name. Eg:- Jboss7, Jboss7_0_1.<br><br>
<b><code>[STG_Service_List]</code></b>:- Contain list of stage environment services alias/reference name. Eg:- STG_Jboss_7, STG_Jboss_7_0_1.<br><br>
<b><code>[Prod_Service_List]</code></b>:- Contain list of prod environment services alias/reference name. Eg:- PROD_Jboss_7, PROD_Jboss_7_0_1.<br><br>
<b><code>[Dev_Jboss]</code></b>:- Contain list of jboss server IP. This filed can be adjust as per the application properties. This field was referred via "Hosted On" directive of application properties.<br><br>
<b><code>[Jboss_7]</code></b>:- Contain application properties like service name, command, port etc. This filed associated with <code>[DEV_Service_List]</code>,<code>[STG_Service_List]</code> or <code>[Prod_Service_List]</code> and can be modify or adjust according to alias/reference name.<br><br></blockquote>

<blockquote>Application Properties:-<br>
<b>Service Name</b>:- Contain name of application.<br><br>
<b>Port List</b>:- Contain port's of application.<br><br>
<b>Hosted On</b>:- This filed refers to the application stack as mentioned above <code>[Dev_Jboss]</code>.<br><br>
<b>Command</b>:- Contain combination of shell command in order to get the specific process data of application like process id etc.</blockquote>

<blockquote>Sample Application Entry:-<br>
<code>[Jboss7]</code><br>
Service Name = jboss7<br>
Port List    = 9090,19009<br>
Hosted On    = Dev_Jboss<br>
Command      = "ps -eaf | grep -w /app/jboss7 | grep -w jboss | grep -v /bin/sh"<br></blockquote>

<h1>How-TO</h1>
This section will describe how to generate encrypted username and paasword for SSH etc and update the script.<br>
<br>
<ol><li>Generate encrypted Username/Password:-<br>
</li></ol><blockquote>In order to generate encrypted username/password go to utils folder of application and execute the encrypt.pl script.<br>
<code>#./encrypt.pl &lt;username&gt; &lt;key&gt;</code> --->  Produce encrypted username.<br>
<code>#./encrypt.pl &lt;password&gt; &lt;key&gt;</code> --->  Produce encrypted password.<br></blockquote>

<blockquote>Once you have the encrypted username and password go to libs folder open Main.pm file in a text editor update the value of <code>$hash_user</code> and <code>$hash_pass</code> <code>(line no 61 and 62)</code> with encrypted username and password.<br></blockquote>

<blockquote><b><font color='red'>Note</font></b>:- Please use same key to generate both username and password. Don't share the key with anyone.<br></blockquote>


<ol><li>How to run the script:-<br>
</li></ol><blockquote>To run the script go to the application root folder and run service_monitor.pl with environment name and key (used above to generate the username and password) as command line argument.<br></blockquote>

<blockquote>Eg:- <code>#./service_monitor.pl DEV Eyf007HK</code> (Make sure the environment DEV was listed under <code>[Env_List]</code>)