<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <TimeZone>W. Europe Standard Time</TimeZone>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>vagrant</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Name>vagrant</Name>
                        <Password><Value>vagrant</Value><PlainText>true</PlainText></Password>
                        <Description>Vagrant</Description>
                        <DisplayName>Vagrant</DisplayName>
                        <Group>Administrators</Group>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
            <AutoLogon>
                <Password>
                    <Value>vagrant</Value>
                    <PlainText>true</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <Username>vagrant</Username>
            </AutoLogon>
            <FirstLogonCommands>
                
                <!-- Set Execution Policiy -->
                
                <SynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>Set Execution Policy 64 Bit</Description>
                    <CommandLine>cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>Set Execution Policy 32 Bit</Description>
                    <CommandLine>C:\Windows\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>                

                <!-- Quality Of Life Settings -->

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f</CommandLine>
                    <Order>3</Order>
                    <Description>Show file extensions in Explorer</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f</CommandLine>
                    <Order>4</Order>
                    <Description>Enable QuickEdit mode</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f</CommandLine>
                    <Order>5</Order>
                    <Description>Show Run command in Start Menu</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f</CommandLine>
                    <Order>6</Order>
                    <Description>Show Administrative Tools in Start Menu</Description>
                </SynchronousCommand>

                <!-- Disable Hibernation -->

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f</CommandLine>
                    <Order>7</Order>
                    <Description>Zero Hibernation File</Description>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <CommandLine>CMD /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f</CommandLine>
                    <Order>8</Order>
                    <Description>Disable Hibernation Mode</Description>
                </SynchronousCommand>

                <!-- Disable Admin Password Expiration  -->
                
                <SynchronousCommand wcm:action="add">
                    <CommandLine>cmd.exe /c wmic useraccount where "name='CHANGEME'" set PasswordExpires=FALSE</CommandLine>
                    <Order>9</Order>
                    <Description>Disable password expiration for Administrator user</Description>
                </SynchronousCommand>
                
                <!-- Enable OpenSSH Server -->
                
                <SynchronousCommand wcm:action="add">
                    <Order>10</Order>
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"</CommandLine>
                    <Description>Install OpenSSH server</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>11</Order>
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Set-Service -Name sshd -StartupType Automatic"</CommandLine>
                    <Description>Set OpenSSH service to autostart</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>

                <SynchronousCommand wcm:action="add">
                    <Order>12</Order>
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Start-Service sshd"</CommandLine>
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
    </settings>

    <settings pass="offlineServicing">
        <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <EnableLUA>false</EnableLUA>
        </component>
    </settings>

    <cpi:offlineImage cpi:source="wim:c:/wim/windows-2022/install.wim#Windows Server 2022 SERVERSTANDARD" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>