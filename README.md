# renovate-test

> Repository to test renovate dependency updates for terraform and terragrunt

## Overview

[Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/)
is [depdendabot](https://dependabot.com/) on steroids.

This repo is not your typical terraform structure, it's best to keep modules in
a separate repo to your config repo. See
[here](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example)
for more info.

The purpose of the repo is to easily test custom config for various terraform
and terragrunt [renovate
managers](https://docs.renovatebot.com/modules/manager/) in one place.

## Structure

- [infra](./infra) Terragrunt deployment files - Renovate will bump upstream
  module versions
  - `.terraform-version` and `.terragrunt-version` files are used by `tfenv` and
      `tgenv` respectively - Renovate will bump the version numbers in these
      files
- [modules](./modules) Terraform modules - Renovate will bump provider and
  terraform version pins
- [renovate.json](./renovate.json) - Config file for renovate

## Renovate in action

Check out the [close/merged
PRs](https://github.com/sajid-khan-js/renovate-test/pulls?q=is%3Apr+is%3Aclosed)
to see what renovate can do
