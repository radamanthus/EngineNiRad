# Rails

This is a collection of terraform scripts for automated provisioning of a Rails environment on AWS.

## Quick Start

## Customization

TODO

Configurable variables:
- number of web instances
- web instance size
- web /data volume size
- web /mnt volume size
- rds instance size
- rds db volume size

Modules:
- passenger
- unicorn
- puma

Conditional code to determine if a module will be loaded:
https://github.com/hashicorp/terraform/issues/12906

- monit or upstart?

Plan:
- Implement Passenger first
- Then puma-upstart
- Then unicorn-monit