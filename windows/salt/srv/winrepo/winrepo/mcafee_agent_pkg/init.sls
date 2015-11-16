McAfee Agent:
  5.00.1009:
    installer: 'https://path/to/your/FramePkg.exe'
    full_name: 'McAfee Agent'
    install_flags: ' /install=agent /forceinstall /silent'
    msiexec: False
    uninstaller: '%ProgramFiles%\McAfee\Agent\x86\FrmInst.exe'
    uninstall_flags: ' /forceuninstall /silent'
