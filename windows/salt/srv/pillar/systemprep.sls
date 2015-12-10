{#- Get the SYSTEMROOT value from the registry #}
{% set systemroot = salt['reg.read_value'](
    'HKEY_LOCAL_MACHINE',
    'SOFTWARE\Microsoft\Windows NT\CurrentVersion',
    'SystemRoot').vdata %}

{#-
    Set the SYSTEMDRIVE value to the first two characters of SYSTEMROOT.
    See http://msdn.microsoft.com/en-us/library/cc231436.aspx.
#}
{%- set systemdrive = systemroot|truncate(2, True, '') %}

systemprep:
  base-states:
    - dotnet4
    - pshelp
    - netbanner.custom
    - emet
    - ash-windows.stig
    - ash-windows.iavm
  post-states:
    - ash-windows.delta
    - scc.scan

ash-windows:
  lookup:
    logdir: '{{ systemdrive }}\SystemPrep\Logs\Ash'
    apply_lgpo_source: 'https://s3.amazonaws.com/systemprep-repo/windows/lgpo-utilities/Apply_LGPO_Delta.exe'
    apply_lgpo_source_hash: 'https://s3.amazonaws.com/systemprep-repo/windows/lgpo-utilities/Apply_LGPO_Delta.exe.SHA512'

pshelp:
  lookup:
    source: 'https://s3.amazonaws.com/systemprep-repo/windows/pshelp/pshelp-content.zip'
    source_hash: 'https://s3.amazonaws.com/systemprep-repo/windows/pshelp/pshelp-content.zip.SHA512'

netbanner:
  lookup:
    network_label: 'Unclass'
    custom_network_labels:
      Unclass:
        CustomBackgroundColor: '1'
        CustomDisplayText: 'UNCLASSIFIED'
        CustomForeColor: '2'

{%- load_yaml as all_scc_content %}
'common':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Microsoft_DotNet_Framework_4_V1R3_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Microsoft_DotNet_Framework_4_V1R3_STIG_SCAP_1-1_Benchmark.zip.SHA512
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Microsoft_IE10_V1R6_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Microsoft_IE10_V1R6_STIG_SCAP_1-1_Benchmark.zip.SHA512
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/u_microsoft_ie11_v1r3_stig_scap_1-0_benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/u_microsoft_ie11_v1r3_stig_scap_1-0_benchmark.zip.SHA512
'DomainController Microsoft Windows Server 2012 R2':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2012_and_2012_R2_DC_V2R3_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2012_and_2012_R2_DC_V2R3_STIG_SCAP_1-1_Benchmark.zip.SHA512
'MemberServer Microsoft Windows Server 2012 R2':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2012_and_2012_R2_MS_V2R3_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2012_and_2012_R2_MS_V2R3_STIG_SCAP_1-1_Benchmark.zip.SHA512
'DomainController Microsoft Windows Server 2008 R2':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2008_R2_DC_V1R19_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2008_R2_DC_V1R19_STIG_SCAP_1-1_Benchmark.zip.SHA512
'MemberServer Microsoft Windows Server 2008 R2':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2008_R2_MS_V1R19_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_2008_R2_MS_V1R19_STIG_SCAP_1-1_Benchmark.zip.SHA512
'Workstation Microsoft Windows 8.1':
  - source: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_8_and_8-1_V1R12_STIG_SCAP_1-1_Benchmark.zip
    source_hash: https://s3.amazonaws.com/systemprep-repo/windows/scap-content/U_Windows_8_and_8-1_V1R12_STIG_SCAP_1-1_Benchmark.zip.SHA512
{%- endload %}

{%- set os_ver = salt['grains.get']('osfullname') %}
{%- set role_int = salt['cmd.shell'](
    'wmic ComputerSystem get DomainRole /format:list').split('=')[1] %}
{%- set role = 'Workstation' %}
{%- set role = 'MemberServer' if role_int in ['2','3'] else role %}
{%- set role = 'DomainController' if role_int in ['4','5'] else role %}

{%- set scc_content = all_scc_content.common %}
{%- set os_matcher = role ~ ' ' ~ os_ver %}
{%- for os,sources in all_scc_content.items() %}
    {%- do scc_content.extend(sources) if os_matcher.startswith(os) %}
{%- endfor %}

scc:
  winrepo:
    versions:
      '4.0.1':
        installer: https://s3.amazonaws.com/systemprep-repo/windows/scc/SCC_4.0.1_Windows_Setup.exe
  lookup:
    outputdir: '{{ systemdrive }}\SystemPrep\SCC'
    content: {{ scc_content }}
