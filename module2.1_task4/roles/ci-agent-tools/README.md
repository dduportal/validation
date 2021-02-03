# ci-agent-tools

This role installs all the tools required for a CI agent server

## Requirements

* Ansible 2.9+
* If you want to edit and test this role:
  - Molecule with the Docker provider (`pip install molecule[docker]`)
  - The command lines `yamllint`and `ansible-lint`

## Role Variables

* `java_major_version` (defined in `defaults/main.yml): the major version of the OpenJDK package to install. Default is **8**.

## Dependencies

There are no dependencies for this role.

## Example Playbook

Default Use Case:

```yml
- hosts: servers
  roles:
    - ci-agent-tools
```

Custom OpenJDK Major version

```yml
- hosts: servers
  roles:
    - role: ci-agent-tools
      vars:
        java_major_version: 11
```

## License

BSD
