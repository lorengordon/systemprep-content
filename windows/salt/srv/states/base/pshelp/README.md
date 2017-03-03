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
  - Ignore any errors...
- Repeat the above steps for a ws2016 server. Do not install every feature, but
at least install bitlocker, defender, and _all_ the remote server
administration tools (rsat)
- Merge the pshelp files from both ws2012r2 and ws2016 into a single zip file
called 'pshelp-content.zip' (just the contents of the C:\pshelp directories,
don't include the directory in the zip)
- Create a sha512 hash of 'pshelp-content.zip', named 'pshelp-content.zip.SHA512'
- Upload 'pshelp-content.zip' and 'pshelp-content.zip.SHA512' to the S3 bucket:
https://s3.amazonaws.com/systemprep-repo/windows/pshelp/
