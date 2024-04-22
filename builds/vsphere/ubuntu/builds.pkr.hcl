//////////////////////////////////
// Azure Builds | Debian
//////////////////////////////////

build {
  sources = [
    "source.vsphere-iso.ubuntu",
  ]

  // Install Ansible
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script          = join("/", [var.resources_folder, "shell/ansible.vsphere.sh"])
    skip_clean      = true
  }

  // Provision using Ansible
  provisioner "ansible-local" {
    command = join(" ", [
      "PYTHONUNBUFFERED=1", "ANSIBLE_FORCE_COLOR=1",
      "ANSIBLE_LOCAL_TEMP=/tmp/ansible", "ANSIBLE_REMOTE_TEMP=/tmp/ansible-managed",
      "ansible-playbook",
    ])

    playbook_files = [
      join("/", [var.resources_folder, "ansible-local/server.debian.yaml"]),
      join("/", [var.resources_folder, "ansible-local/hashicorp.debian.yaml"]),
      join("/", [var.resources_folder, "ansible-local/docker.ubuntu.yaml"]),
      join("/", [var.resources_folder, "ansible-local/aide.debian.yaml"]),
      #join("/", [var.resources_folder, "ansible-local/deprovision.yaml"]),
    ]
  }
}
