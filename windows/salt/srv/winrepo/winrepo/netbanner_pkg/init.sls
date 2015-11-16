Netbanner:
  2.1.161:
    installer: 'https://s3.amazonaws.com/systemprep-repo/windows/netbanner/2.1.161/NetBanner.Setup+2.1.161.msi'
    full_name: 'Microsoft NetBanner'
    reboot: False
    install_flags: ' ALLUSERS=1 /quiet /qn /norestart'
    msiexec: True
    uninstaller: 'https://s3.amazonaws.com/systemprep-repo/windows/netbanner/2.1.161/NetBanner.Setup+2.1.161.msi'
    uninstall_flags: ' /qn'
  1.3.93:
    installer: 'https://s3.amazonaws.com/systemprep-repo/windows/netbanner/1.3.93/netbanner.msi'
    full_name: 'NetBanner'
    reboot: False
    install_flags: ' ALLUSERS=1 /quiet /qn /norestart'
    msiexec: True
    uninstaller: 'https://s3.amazonaws.com/systemprep-repo/windows/netbanner/1.3.93/netbanner.msi'
    uninstall_flags: ' /qn'
