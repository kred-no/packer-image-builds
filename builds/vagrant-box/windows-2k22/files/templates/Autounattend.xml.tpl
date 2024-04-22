<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">

    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SetupUILanguage>
                <UILanguage>en-US</UILanguage>
            </SetupUILanguage>
            <InputLocale>nb-NO</InputLocale>
            <SystemLocale>nb-NO</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
            <UserLocale>nb-NO</UserLocale>
        </component>
        
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            
            <UserData>
                <ProductKey><WillShowUI>OnError</WillShowUI></ProductKey>
                <AcceptEula>true</AcceptEula>
                <FullName>Packer Builder</FullName> 
                <Organization>HashiCorp</Organization>
            </UserData>

            <DiskConfiguration>
                <Disk wcm:action="add">
                    <CreatePartitions>
                        
                        <!-- System partitions -->
                    
                        <CreatePartition wcm:action="add">
                            <Order>1</Order> 
                            <Type>EFI</Type> 
                            <Size>200</Size> 
                        </CreatePartition>

                        <CreatePartition wcm:action="add">
                            <Order>2</Order>
                            <Type>MSR</Type>
                            <Size>16</Size>
                        </CreatePartition>

                        <!-- Windows partition -->
                    
                        <CreatePartition wcm:action="add">
                            <Order>3</Order> 
                            <Type>Primary</Type> 
                            <Extend>true</Extend> 
                        </CreatePartition>
                    </CreatePartitions>

                    <ModifyPartitions>
                        
                        <!-- System Partitions -->
                    
                        <ModifyPartition wcm:action="add">
                            <Order>1</Order> 
                            <PartitionID>1</PartitionID> 
                            <Label>System</Label>
                            <Format>FAT32</Format> 
                        </ModifyPartition>

                        <ModifyPartition wcm:action="add">
                            <Order>2</Order>
                            <PartitionID>2</PartitionID>
                        </ModifyPartition>

                        <!-- Windows Partition -->
                    
                        <ModifyPartition wcm:action="add">
                            <Order>3</Order> 
                            <PartitionID>3</PartitionID> 
                            <Format>NTFS</Format> 
                            <Letter>C</Letter> 
                            <Label>OSDisk</Label> 
                        </ModifyPartition>
    
                    </ModifyPartitions>
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
            </DiskConfiguration>                

            <ImageInstall>
                <OSImage>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>3</PartitionID>
                    </InstallTo>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>Windows Server 2022 SERVERSTANDARD</Value>
                        </MetaData>
                    </InstallFrom>
                </OSImage>
            </ImageInstall>

        </component>
    </settings>

    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
                <SkipMachineOOBE>true</SkipMachineOOBE>
                <SkipUserOOBE>true</SkipUserOOBE>
            </OOBE>
            
            <TimeZone>W. Europe Standard Time</TimeZone>
            
            <UserAccounts>

                <!-- !! Remember to Disable the Built-In Administrator !! -->

                <AdministratorPassword>
                    <Value></Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>

                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Name>${username}</Name>
                        <Password>
                            <Value>${password}</Value>
                            <PlainText>true</PlainText>
                        </Password>
                        <Description>Vagrant</Description>
                        <DisplayName>Vagrant</DisplayName>
                        <Group>Administrators</Group>
                    </LocalAccount>
                </LocalAccounts>

            </UserAccounts>
            
            <AutoLogon>
                <Enabled>true</Enabled>
                <LogonCount>1</LogonCount>
                <Username>${username}</Username>
                <Password>
                    <Value>${password}</Value>
                    <PlainText>true</PlainText>
                </Password>
            </AutoLogon>

            <!-- Commands to run in the User context -->

            <FirstLogonCommands>
                
                <!-- Quality Of Life Settings -->

                <SynchronousCommand wcm:action="add">
                    <Order>46</Order>
                    <CommandLine>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f</CommandLine>
                    <Description>Show file extensions in Explorer</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>47</Order>
                    <CommandLine>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f</CommandLine>
                    <Description>Enable QuickEdit mode</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>48</Order>
                    <CommandLine>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f</CommandLine>
                    <Description>Show Run command in Start Menu</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>49</Order>
                    <CommandLine>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f</CommandLine>
                    <Description>Show Administrative Tools in Start Menu</Description>
                </SynchronousCommand>

                <!-- Enable OpenSSH Server -->
                
                <SynchronousCommand wcm:action="add">
                    <Order>97</Order>
                    <CommandLine>%SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe -c "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"</CommandLine>
                    <Description>Install OpenSSH server</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>98</Order>
                    <CommandLine>%SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe -c "Set-Service -Name sshd -StartupType Automatic"</CommandLine>
                    <Description>Set OpenSSH service to autostart</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>99</Order>
                    <CommandLine>%SystemRoot%\System32\WindowsPowerShell\v1.0\PowerShell.exe -c "Start-Service sshd"</CommandLine>
                    <Description>Start OpenSSH server</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>
                
                <!-- Done -->

            </FirstLogonCommands>

        </component>
    </settings>

    <settings pass="specialize">
        
        <component name="Microsoft-Windows-ServerManager-SvrMgrNc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon>
        </component>

        <component name="Microsoft-Windows-IE-ESC" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <IEHardenAdmin>false</IEHardenAdmin>
            <IEHardenUser>false</IEHardenUser>
        </component>

        <component name="Microsoft-Windows-OutOfBoxExperience" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon>
        </component>

        <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipAutoActivation>true</SkipAutoActivation>
        </component>

        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <fDenyTSConnections>false</fDenyTSConnections>
        </component>

        <component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <FirewallGroups>
                <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
                    <Profile>all</Profile>
                    <Group>Remote Desktop</Group>
                    <Active>true</Active>
                </FirewallGroup>
            </FirewallGroups>
        </component>

        <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            
            <!-- Commands to run in System context -->

            <RunSynchronous>

                <!-- Set Execution Policiy -->

                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>Set Execution Policy 32 Bit</Description>
                    <Path>%SystemRoot%\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</Path>
                    <WillReboot>Never</WillReboot>
                </RunSynchronousCommand>

                <RunSynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>Set Execution Policy 64 Bit</Description>
                    <Path>%SystemRoot%\System32\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</Path>
                    <WillReboot>Never</WillReboot>
                </RunSynchronousCommand>

                <!-- Disable Hibernation -->

                <RunSynchronousCommand wcm:action="add">
                    <Order>28</Order>
                    <Description>Zero Hibernation File</Description>
                    <Path>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f</Path>
                    <WillReboot>Never</WillReboot>
                </RunSynchronousCommand>

                <RunSynchronousCommand wcm:action="add">
                    <Order>29</Order>
                    <Description>Disable Hibernation Mode</Description>
                    <Path>%SystemRoot%\System32\cmd.exe /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f</Path>
                    <WillReboot>Never</WillReboot>
                </RunSynchronousCommand>

                <!-- Done -->

            </RunSynchronous>
        </component>

    </settings>

    <settings pass="offlineServicing">
        <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <EnableLUA>false</EnableLUA>
        </component>
    </settings>

</unattend>
