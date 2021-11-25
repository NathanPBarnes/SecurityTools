#!/bin/bash

# 
: 'The purpose of this script is to perform a preliminary vulnerability scan
   of website utilizing WordPress. The scan then generates a HTML report. 

   Author: Nathan Barnes
   Credit:
           nmap.org
           wpscan.org
           https://github.com/wpscanteam/wpscan 
           https://github.com/tristanlatr/wpscan_out_parse
           https://github.com/honze-net/nmap-bootstrap-xsl


\        /\        / |-----\        /
 \      /  \      /  |    | \      /
  \    /    \    /   |----   \    /
   \  /      \  /    |        \  /
    \/        \/     |         \/'
#

echo "First provide the name of the company requesting the scan. Next, please provide a target IPv4 address."

echo "For the third arugment please provide the URL of the WordPress site to be scanned in the format of https://<domain>"

echo "The last argument needs to be your wpscan API key"


# using two nmap scripts to find vulnerabilities (vulners & http-wordpress-enum)

# can provide -T2 to bypass sensitive Web Application Firewalls

nmap -A -sV --script vulners --script http-wordpress-enum -oX $1_Report.xml --stylesheet nmap-bootstrap.xsl -p- $2

# using xsltproc to convert nmap scan report to html 

xsltproc $1_Report.xml -o $1_Report.html

# always update wpscan before initiating a new scan

wpscan --update

# can proivde --stealthy (alias for --random-user-agent --detection-mode passive --plugins-version-detection passive)

wpscan --url $3 --enumerate u,vp,vt --output $1.json --format json --api-token $4

python3 -m wpscan_out_parse $1.json

python3 -m wpscan_out_parse $1.json --format html > $1.html              
