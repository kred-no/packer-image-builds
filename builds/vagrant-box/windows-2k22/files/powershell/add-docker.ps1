${TEMP_DIR}="C:\Windows\Temp"
${SCRIPT_URL}="https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE\install-docker-ce.ps1"
Invoke-WebRequest -UseBasicParsing "${SCRIPT_URL}" -OutFile "${TEMP_DIR}\install-docker-ce.ps1"
. "${TEMP_DIR}\install-docker-ce.ps1 -NoRestart=${true}"
