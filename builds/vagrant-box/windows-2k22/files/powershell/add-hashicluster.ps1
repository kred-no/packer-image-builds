${CONSUL_VERSION}='1.18.1'
${NOMAD_VERSION}='1.7.6'

${BASE_DIR}="C:\HashiCorp"
${TEMP_DIR}="C:\Windows\Temp"

function Download {
  param(
    [string]$sourceUrl,
    [string]$targetFile
  )
  Invoke-WebRequest -UseBasicParsing "${sourceUrl}" -o "${TEMP_DIR}\${targetFile}"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip {
  param(
    [string]$sourceFile,
    [string]$targetDir
  )
  [System.IO.Compression.ZipFile]::ExtractToDirectory("${TEMP_DIR}\${sourceFile}", ${targetDir})
}

# Install HashiCluster
New-Item -ItemType Directory -Path ${BASE}\bin -Force 
New-Item -ItemType Directory -Path ${BASE}\Consul -Force 
New-Item -ItemType Directory -Path ${BASE}\Nomad -Force 

Download "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_windows_amd64.zip" "consul.zip"
Download "https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_windows_amd64.zip" "nomad.zip"

Unzip "consul.zip" "${BASE_DIR}\bin"
Unzip "nomad.zip" "${BASE_DIR}\bin"

New-Service -DisplayName "HashiCorp Consul" -Name "Consul" -BinaryPathName "${BASE_DIR}\bin\consul.exe agent -config-dir=${BASE_DIR}\Consul" -StartupType Automatic
New-Service -DisplayName "HashiCorp Nomad" -Name "Nomad" -BinaryPathName "${BASE_DIR}\bin\nomad.exe agent -config=${BASE_DIR}\Nomad" -StartupType Automatic

# Manage Services
Stop-Service Consul
Stop-Service Nomad
