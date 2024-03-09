# Pure-Storage-Ansible

This is the repo contains the code for automating Pure Storage OPerational tasks such volume creation, cloning storage systems etc. using the ansible cli code.
Ansible is an automation and orchestration solution from an OPen source community managed by Red Hat.

These playbooks however do not employ any Pure specific collection/module to execute the various tasks on a pure storage Instance.
So it enables the user to enable these automation cases without having to deal with the complexities of managing the various python and pther dependencies that 
are needed when you run Ansible with the technology specific modules.

All the playbook are embedded with the native Pure CLI.
