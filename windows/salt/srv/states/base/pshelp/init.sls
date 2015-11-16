{% from "pshelp/map.jinja" import pshelp with context %}


# Get the pshelp-content
GetPSHelpContent:
  file.managed:
    - name: {{ pshelp.filename }}
    - source: {{ pshelp.source }}
    - source_hash: {{ pshelp.source_hash }}
    - makedirs: True
    - onlyif: 'powershell -command "& { if ($($PSVersiontable.PSVersion.Major) -ge 3) { return 0 } else { throw } }"'


# Clean the pshelp directory
CleanPSHelpDir:
  file.directory:
    - name: {{ pshelp.extract_dir }}
{#- Remove `clean: True` due to a bug, where even managed files are removed #}
{#- Fixed in salt v2015.8.2 #}
{#-    - clean: True #}
    - require:
      - file: GetPSHelpContent
    - onlyif: 'powershell -command "& { if ($($PSVersiontable.PSVersion.Major) -ge 3) { return 0 } else { throw } }"'


# Extract pshelp-content:
ExtractPSHelpContent:
  cmd.run:
    - name: '
    new-object -com shell.application | % {
        $_.namespace("{{ pshelp.extract_dir }}").copyhere($_.namespace("{{ pshelp.filename }}").items(), 0x14)
    }'
    - shell: powershell
    - require:
      - file: CleanPSHelpDir
    - onchanges:
      - file: GetPSHelpContent
    - onlyif: 'if ($($PSVersiontable.PSVersion.Major) -ge 3) { return 0 } else { throw }'


# Update the Powershell Help files
UpdatePSHelp:
  cmd.run:
    - name: 'Update-Help -SourcePath {{ pshelp.extract_dir }} -Force -Verbose'
    - shell: powershell
    - require:
      - cmd: ExtractPSHelpContent
    - onchanges:
      - file: GetPSHelpContent
    - onlyif: 'if ($($PSVersiontable.PSVersion.Major) -ge 3) { return 0 } else { throw }'
