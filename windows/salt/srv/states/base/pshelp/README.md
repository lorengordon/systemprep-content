To update the pshelp files:

- Deploy a plain vanilla ws2012r2 instance (this procedure will get pshelp 
files that can be used on any system with PowerShell 3.0 or later)
- Open Server Manager, go to the "Features" page, and expand every arrow and 
select every feature
- Once the features finish installing, restart the machine. The first login 
will restart the instance again, automatically.
- Open a PowerShell window and run the following commands:
  - `mkdir C:\pshelp`
  - `Save-Help -Module * -DestinationPath C:\pshelp -Force -Verbose`
- Create a zip file of the contents of C:\pshelp (just the contents, don't 
include the directory)
- Name the zip file 'pshelp-contents.zip'
- Create an md5sum of 'pshelp-contents.zip', named 'pshelp-contents.zip.md5'
- Upload 'pshelp-content.zip' and 'pshelp-contents.zip.md5' to the S3 bucket: 
https://s3.amazonaws.com/systemprep-repo/windows/pshelp/
