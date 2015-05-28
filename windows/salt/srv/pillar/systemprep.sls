#Get the SYSTEMROOT value from the registry
{% set systemroot = salt['reg.read_key']('HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'SystemRoot') %}

#Set the SYSTEMDRIVE value to the first two characters of SYSTEMROOT, see http://msdn.microsoft.com/en-us/library/cc231436.aspx
{% set systemdrive = systemroot|truncate(2, True, '') %}

ash-windows:
  lookup:
    logdir: '{{ systemdrive }}\SystemPrep\Logs\Ash'
    apply_lgpo_source: 'https://s3.amazonaws.com/systemprep-repo/windows/lgpo-utilities/Apply_LGPO_Delta.exe'
    apply_lgpo_source_hash: 'https://s3.amazonaws.com/systemprep-repo/windows/lgpo-utilities/Apply_LGPO_Delta.exe.SHA512'

pshelp:
  lookup:
    source : 'https://s3.amazonaws.com/systemprep-repo/windows/pshelp/badsource.zip'
    source_hash : 'https://s3.amazonaws.com/systemprep-repo/windows/pshelp/badsource.zip.SHA512'
