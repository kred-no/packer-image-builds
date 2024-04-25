<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<settings pass="windowsPE">
		
		<!-- Device Driver Locations -->
		
		<component name="Microsoft-Windows-PnpCustomizationsWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<DriverPaths>
				
				<PathAndCredentials wcm:action="add" wcm:keyValue="1">
					<Path>A:\</Path>
				</PathAndCredentials>
				
				<PathAndCredentials wcm:action="add" wcm:keyValue="2">
					<Path>D:\</Path>
				</PathAndCredentials>

			</DriverPaths>
		</component>
		
		<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<SetupUILanguage>
				<UILanguage>nb-NO</UILanguage>
			</SetupUILanguage>
			<InputLocale>nb-NO</InputLocale>
			<SystemLocale>nb-NO</SystemLocale>
			<UILanguage>nb-NO</UILanguage>
			<UserLocale>nb-NO</UserLocale>
		</component>

		<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">

			<RunSynchronous>
				
				<!-- Bypass Windows 11 Validation -->

				<RunSynchronousCommand wcm:action="add">
					<Order>1</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
				
				<RunSynchronousCommand wcm:action="add">
					<Order>2</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
				
				<RunSynchronousCommand wcm:action="add">
					<Order>3</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassStorageCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
				
				<RunSynchronousCommand wcm:action="add">
					<Order>4</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
				
				<RunSynchronousCommand wcm:action="add">
					<Order>5</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
				
				<RunSynchronousCommand wcm:action="add">
					<Order>6</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassDiskCheck /t REG_DWORD /d 0x00000001 /f</Path>
				</RunSynchronousCommand>
		
			</RunSynchronous>

			<!-- Configure Partitions -->

			<DiskConfiguration>
				<WillShowUI>OnError</WillShowUI>
				<Disk wcm:action="add">
					<DiskID>0</DiskID>
					<WillWipeDisk>true</WillWipeDisk>
					
					<CreatePartitions>

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
						
						<CreatePartition wcm:action="add">
							<Order>3</Order>
							<Type>Primary</Type>
							<Extend>true</Extend>
						</CreatePartition>
					
					</CreatePartitions>

					<ModifyPartitions>

						<ModifyPartition wcm:action="add">
							<Order>1</Order>
							<PartitionID>1</PartitionID>
							<Format>FAT32</Format>
							<Label>System</Label>
						</ModifyPartition>
						
						<ModifyPartition wcm:action="add">
							<Order>2</Order>
							<PartitionID>2</PartitionID>
						</ModifyPartition>
						
						<ModifyPartition wcm:action="add">
							<Order>3</Order>
							<PartitionID>3</PartitionID>
							<Letter>C</Letter>
							<Format>NTFS</Format>
							<Label>Windows</Label>
						</ModifyPartition>

					</ModifyPartitions>
				</Disk>
			</DiskConfiguration>

			<!-- Install -->

			<ImageInstall>
				<OSImage>
<!--
					<InstallFrom>
						<MetaData wcm:action="add">
							<Key>/IMAGE/NAME</Key>
							<Value>Windows 11 Enterprise Evaluation</Value>
						</MetaData>
					</InstallFrom>
-->
					<InstallTo>
						<DiskID>0</DiskID>
						<PartitionID>3</PartitionID>
					</InstallTo>
				</OSImage>
			</ImageInstall>			
			<UserData>
				<ProductKey>
					<WillShowUI>OnError</WillShowUI>
					<Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
				</ProductKey>
				<AcceptEula>true</AcceptEula>
				<FullName>Packer Builder</FullName>
				<Organization>HashiCorp</Organization>
			</UserData>
			
			<DynamicUpdate>
				<Enable>false</Enable>
			</DynamicUpdate>

		</component>
	</settings>

	<settings pass="generalize">
		
		<component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<SkipRearm>1</SkipRearm>
		</component>

		<component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<PersistAllDeviceInstalls>false</PersistAllDeviceInstalls>
			<DoNotCleanUpNonPresentDevices>false</DoNotCleanUpNonPresentDevices>
		</component>

	</settings>
	
	<settings pass="specialize">

		<!-- Disable System Restore -->

		<component name="Microsoft-Windows-SystemRestore-Main" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<DisableSR>1</DisableSR>
		</component>

		<component name="Microsoft-Windows-SystemSettingsThreshold" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<DisplayNetworkSelection>false</DisplayNetworkSelection>
		</component>

		<!-- Disable Customer Experience -->

		<component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<CEIPEnabled>0</CEIPEnabled>
		</component>

		<!-- Set Timezone -->

		<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<TimeZone>W. Europe Standard Time</TimeZone>
		</component>
		
		<!-- First Time Experience -->
		
		<component name="Microsoft-Windows-IE-InternetExplorer" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<DisableAccelerators>true</DisableAccelerators>
			<DisableFirstRunWizard>true</DisableFirstRunWizard>
			<Home_Page>about:blank</Home_Page>
		</component>

		<!-- Disable Auto-Activation -->

		<component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<SkipAutoActivation>true</SkipAutoActivation>
		</component>

		<!-- Remote Desktop -->

		<component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<fDenyTSConnections>false</fDenyTSConnections>
		</component>

		<component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<FirewallGroups>
				<FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
				<Profile>all</Profile>
				<Group>Remote Desktop</Group>
				<Active>true</Active>
				</FirewallGroup>
			</FirewallGroups>
		</component>

	</settings>

	<settings pass="auditSystem"></settings>
	<settings pass="auditUser"></settings>

	<settings pass="oobeSystem">
		
		<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<!-- <InputLocale>0414:00000414</InputLocale> -->
			<InputLocale>nb-NO</InputLocale>
			<SystemLocale>nb-NO</SystemLocale>
			<UILanguage>nb-NO</UILanguage>
			<UserLocale>nb-NO</UserLocale>
		</component>

		<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">

			<OOBE>
				<HideEULAPage>true</HideEULAPage>
				<HideLocalAccountScreen>true</HideLocalAccountScreen>
				<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
				<HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
				<NetworkLocation>Work</NetworkLocation>
				<ProtectYourPC>3</ProtectYourPC>
				<SkipMachineOOBE>true</SkipMachineOOBE>
				<SkipUserOOBE>true</SkipUserOOBE>

				<VMModeOptimizations>
					<SkipAdministratorProfileRemoval>true</SkipAdministratorProfileRemoval>
					<SkipNotifyUILanguageChange>true</SkipNotifyUILanguageChange>
					<SkipWinREInitialization>true</SkipWinREInitialization>
				</VMModeOptimizations>
			</OOBE>

			<TimeZone>W. Europe Standard Time</TimeZone>

			<UserAccounts>
				<LocalAccounts>
					<LocalAccount wcm:action="add">
						<Name>${username}</Name>
						<Group>Administrators</Group>
						<Password>
							<Value>${password}</Value>
							<PlainText>true</PlainText>
						</Password>
					</LocalAccount>
				</LocalAccounts>
			</UserAccounts>

			<AutoLogon>
				<Username>${username}</Username>
				<Enabled>true</Enabled>
				<LogonCount>1</LogonCount>
				<Password>
					<Value>${password}</Value>
					<PlainText>true</PlainText>
				</Password>
			</AutoLogon>

			<FirstLogonCommands>
				
				<!-- Set Execution Policies -->
				
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

				<!-- Disable Hibernation -->

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f</CommandLine>
					<Order>3</Order>
					<Description>Zero Hibernation File</Description>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f</CommandLine>
					<Order>4</Order>
					<Description>Disable Hibernation Mode</Description>
				</SynchronousCommand>

				<!-- Disable Admin Password Expiration  -->
				
				<SynchronousCommand wcm:action="add">
					<CommandLine>cmd.exe /c wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE</CommandLine>
					<Order>5</Order>
					<Description>Disable password expiration for Administrator user</Description>
				</SynchronousCommand>

				<!-- Quality Of Life Settings -->

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f</CommandLine>
					<Order>6</Order>
					<Description>Show file extensions in Explorer</Description>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f</CommandLine>
					<Order>7</Order>
					<Description>Enable QuickEdit mode</Description>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f</CommandLine>
					<Order>8</Order>
					<Description>Show Run command in Start Menu</Description>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<CommandLine>CMD /c reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f</CommandLine>
					<Order>9</Order>
					<Description>Show Administrative Tools in Start Menu</Description>
				</SynchronousCommand>

				<!-- Enable OpenSSH Server -->
				
				<SynchronousCommand wcm:action="add">
					<Order>97</Order>
					<CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"</CommandLine>
					<Description>Install OpenSSH server</Description>
					<RequiresUserInput>true</RequiresUserInput>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<Order>98</Order>
					<CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Set-Service -Name sshd -StartupType Automatic"</CommandLine>
					<Description>Set OpenSSH service to autostart</Description>
					<RequiresUserInput>true</RequiresUserInput>
				</SynchronousCommand>

				<SynchronousCommand wcm:action="add">
					<Order>99</Order>
					<CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe -c "Start-Service sshd"</CommandLine>
					<Description>Start OpenSSH server</Description>
					<RequiresUserInput>true</RequiresUserInput>
				</SynchronousCommand>
				
				<!-- Finalize -->

				<SynchronousCommand wcm:action="add">
					<Order>100</Order>
					<CommandLine>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
				</SynchronousCommand>

			</FirstLogonCommands>
		</component>

		<component name="Microsoft-Windows-WinRE-RecoveryAgent" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<UninstallWindowsRE>true</UninstallWindowsRE>
		</component>
	</settings>

	<settings pass="offlineServicing">
		
		<!-- Turn Off UAC -->

		<component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<EnableLUA>false</EnableLUA>
		</component>

	</settings>

</unattend>