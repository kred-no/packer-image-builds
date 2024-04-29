<?xml version="1.0" encoding="utf-8"?>
<!--
  Required template-variables:
  - hostname >> string
  - username >> string
  - password >> string
  - files    >> list(string)
-->
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="windowsPE">
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <SetupUILanguage>
        <UILanguage>en-US</UILanguage>
      </SetupUILanguage>
      <!-- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs?view=windows-11#input-locales -->
      <InputLocale>nb-NO</InputLocale>
      <UILanguage>en-US</UILanguage>
      <UILanguageFallback>en-US</UILanguageFallback>
      <SystemLocale>en-US</SystemLocale>
      <UserLocale>en-US</UserLocale>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <DiskConfiguration>
        <Disk wcm:action="add">
          <CreatePartitions>
            <CreatePartition wcm:action="add">
              <Order>1</Order>
              <Size>300</Size>
              <Type>Primary</Type>
            </CreatePartition>
            <CreatePartition wcm:action="add">
              <Extend>true</Extend>
              <Order>2</Order>
              <Type>Primary</Type>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <ModifyPartition wcm:action="add">
              <Active>true</Active>
              <Format>NTFS</Format>
              <Label>System</Label>
              <Order>1</Order>
              <PartitionID>1</PartitionID>
            </ModifyPartition>
            <ModifyPartition wcm:action="add">
              <Format>NTFS</Format>
              <Label>Windows</Label>
              <Order>2</Order>
              <PartitionID>2</PartitionID>
            </ModifyPartition>
          </ModifyPartitions>
          <DiskID>0</DiskID>
          <WillWipeDisk>true</WillWipeDisk>
        </Disk>
        <WillShowUI>OnError</WillShowUI>
      </DiskConfiguration>
      <ImageInstall>
        <OSImage>
          <InstallFrom>
            <MetaData wcm:action="add">
              <Key>/IMAGE/NAME</Key>
              <Value>Windows Server 2022 SERVERDATACENTER</Value>
            </MetaData>
          </InstallFrom>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>2</PartitionID>
          </InstallTo>
        </OSImage>
      </ImageInstall>

      <UserData>
        <!-- Product Key from https://www.microsoft.com/en-us/evalcenter/ -->
        <ProductKey>
          <!-- Do not uncomment the Key element if you are using trial ISOs -->
          <!-- You must uncomment the Key element (and optionally insert your own key) if you are using retail or volume license ISOs -->
          <!-- <Key>6XBNX-4JQGW-QX6QG-74P76-72V67</Key> -->
          <WillShowUI>OnError</WillShowUI>
        </ProductKey>
        <AcceptEula>true</AcceptEula>
        <FullName>Packer</FullName>
        <Organization>Packer</Organization>
      </UserData>
    </component>
  </settings>

  <settings pass="specialize">
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <OEMInformation>
        <HelpCustomized>false</HelpCustomized>
      </OEMInformation>
      <ComputerName>${hostname}</ComputerName>
      <!-- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones -->
      <TimeZone>W. Europe Standard Time</TimeZone>
      <RegisteredOwner />
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-ServerManager-SvrMgrNc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-IE-ESC" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <IEHardenAdmin>false</IEHardenAdmin>
      <IEHardenUser>false</IEHardenUser>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-IE-InternetExplorer" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <SearchScopes>
        <Scope wcm:action="add">
          <ScopeDefault>true</ScopeDefault>
          <ScopeDisplayName>Google</ScopeDisplayName>
          <ScopeKey>Google</ScopeKey>
          <ScopeUrl>http://www.google.com/search?q={searchTerms}</ScopeUrl>
        </Scope>
      </SearchScopes>
      <DisableAccelerators>true</DisableAccelerators>
      <DisableFirstRunWizard>true</DisableFirstRunWizard>
      <Home_Page>about:blank</Home_Page>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <fDenyTSConnections>false</fDenyTSConnections>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-TerminalServices-RDP-WinStationExtensions" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <UserAuthentication>0</UserAuthentication>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <FirewallGroups>
        <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
          <Active>true</Active>
          <Group>Remote Desktop</Group>
          <Profile>all</Profile>
        </FirewallGroup>
      </FirewallGroups>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-OutOfBoxExperience" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon>
    </component>

    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <SkipAutoActivation>true</SkipAutoActivation>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      
      <AutoLogon>
        <Password>
          <Value>${password}</Value>
          <PlainText>true</PlainText>
        </Password>
        <Enabled>true</Enabled>
        <Username>${username}</Username>
      </AutoLogon>

      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Description>Disable Network prompt</Description>
          <Order>1</Order>
          <CommandLine>cmd.exe /c reg add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff"</CommandLine>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f</CommandLine>
          <Order>2</Order>
          <Description>Show file extensions in Explorer</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f</CommandLine>
          <Order>3</Order>
          <Description>Show Run command in Start Menu</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f</CommandLine>
          <Order>4</Order>
          <Description>Show Administrative Tools in Start Menu</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f</CommandLine>
          <Order>5</Order>
          <Description>Zero Hibernation File</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
            <CommandLine>%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f</CommandLine>
            <Order>6</Order>
            <Description>Disable Hibernation Mode</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <CommandLine>cmd.exe /c wmic useraccount where "name='${username}'" set PasswordExpires=FALSE</CommandLine>
          <Order>7</Order>
          <Description>Disable password expiration for provisioning user</Description>
        </SynchronousCommand>
        
        <!-- Provisioner Custom Powershell Files -->
        %{~ for IDX,FILENAME in files ~}
        <SynchronousCommand wcm:action="add">
          <Description>Powershell Provisioning File ${IDX}</Description>
          <Order>${IDX+8}</Order>
          <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -File ${FILENAME}</CommandLine>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>
        %{~ endfor ~}

      </FirstLogonCommands>

      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideLocalAccountScreen>true</HideLocalAccountScreen>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Home</NetworkLocation>
        <ProtectYourPC>1</ProtectYourPC>
      </OOBE>
      
      <UserAccounts>
        <AdministratorPassword>
          <Value>${password}</Value>
          <PlainText>true</PlainText>
        </AdministratorPassword>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            <Password>
              <Value>${password}</Value>
              <PlainText>true</PlainText>
            </Password>
            <Group>Administrators</Group>
            <DisplayName>Provisioner</DisplayName>
            <Name>${username}</Name>
            <Description>Local Provisioning Account</Description>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>
      <RegisteredOwner />
    </component>
  </settings>
  <settings pass="offlineServicing">
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <EnableLUA>false</EnableLUA>
    </component>
  </settings>
</unattend>