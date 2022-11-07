//////////////////////////////////
// Build | Debian
//////////////////////////////////

build {
  sources = [
    "source.azure-arm.debian-11",
  ]

  // Install Ansible
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script          = join("/", [var.resources_folder, "shell/ansible.debian.sh"])
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
      join("/", [var.resources_folder, "ansible-local/docker.debian.yaml"]),
      join("/", [var.resources_folder, "ansible-local/aide.debian.yaml"]),
      join("/", [var.resources_folder, "ansible-local/deprovision.yaml"]),
    ]
  }
}
