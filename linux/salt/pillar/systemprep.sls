systemprep:
  base-states:
    - name-computer
    - ash-linux.vendor
    - ash-linux.stig
    - ash-linux.iavm
  post-states:
    - scc.scan

scc:
  lookup:
    outputdir: /root/scc
    pkg:
      source: https://s3.amazonaws.com/systemprep-repo/linux/custom/scc/scc-4.1.1.x86_64.rpm
    content:
      - source: https://s3.amazonaws.com/systemprep-repo/linux/custom/scap-content/U_RedHat_6_V1R13_STIG_SCAP_1-1_Benchmark.zip
        source_hash: https://s3.amazonaws.com/systemprep-repo/linux/custom/scap-content/U_RedHat_6_V1R13_STIG_SCAP_1-1_Benchmark.zip.SHA512

ash-linux:
  lookup:
    scap-profile: C2S
