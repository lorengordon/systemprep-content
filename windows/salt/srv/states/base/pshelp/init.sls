{% from "pshelp/map.jinja" import pshelp with context %}

#Update the Powershell Help files
UpdatePSHelp:
  cmd.run:
    - name: 'Update-Help -SourcePath {{ pshelp.source }} -Force'
    - shell: powershell
    - unless: '$($PSVersiontable.PSVersion.Major) -lt 3'
