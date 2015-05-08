To update the pshelp files:

- Deploy a plain vanilla ws2012r2 instance (this will get pshelp files that 
can be used on ws2008 or later, as well)
- Open Server Manager, go to the "Features" page, and expand every arrow and 
select every feature
- Once the features finish installing, restart the machine
- Open a PowerShell window and run the following commands:
  - `mkdir C:\pshelp`
  - `Save-Help -Module * -DestinationPath C:\pshelp -Force -Verbose`
- Delete the files from the `pshelpfiles` directory and replace them with the 
files from the `C:\pshelp` directory on the instance
