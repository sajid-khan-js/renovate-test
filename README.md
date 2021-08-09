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

## Setup

The easiest way to use Renovate is to use the GitHub app, see
[here](https://docs.renovatebot.com/install-github-app/) for the deployment
options.

I opted to run it locally to give me more control over when it runs whilst I
experiment:

```sh
npm i -g renovate
export RENOVATE_TOKEN=<my GitHub token>
LOG_LEVEL=debug renovate --autodiscover --autodiscover-filter sajid-khan-js/renovate-test
```

It's also handy to run this after you make changes to your config
(`renovate.json`) `renovate-config-validator` (comes with npm install of
renovate)

## Structure

### [Infra](./infra)

Terragrunt deployment files.

Renovate will bump:

- Upstream module versions e.g.
  `github.com/cloudposse/terraform-null-label?ref=0.24.0`
- `.terraform-version` and `.terragrunt-version` files are used by `tfenv` and
  `tgenv` respectively - Renovate will bump the version numbers in these files
  to the latest respective version

### [Modules](./modules)

Terraform modules/stacks.

Renovate will bump:

- Provider and terraform version pins in specific cases
- Any upstream modules used in the stacks e.g.
  `github.com/cloudposse/terraform-null-label?ref=0.24.0`

#### Terraform version constraint syntax

:memo: Renovate is aware of the [different terraform version
constraints](https://www.terraform.io/docs/language/expressions/version-constraints.html),
meaning it doesn't simply bump versions but actually evaluates whether a bump is
needed. Read more
[here](https://docs.renovatebot.com/modules/manager/terraform/) and
[here](https://docs.renovatebot.com/configuration-options/#rangestrategy)

- `>= 2.0` will not be bumped since this pin allows any newer version than `2.0`
      i.e. at runtime (when you running `terraform init`), terraform will pull
      the latest provider version anyway
- `~> 0.14.4` will be bumped, but since the pessimistic operator is used (`~>`),
  renovate will bump to a version that satisfies this constraint e.g. if the
  latest version is `1.0.4`, bumping to `1.0.0` will still make the stack usable
  by anyone running terraform version `1.0.X`

### [Renovate config](./renovate.json)

Config file for renovate.

See [here](https://docs.renovatebot.com/configuration-options/) for
configuration options

## Renovate in action

Check out the [close/merged
PRs](https://github.com/sajid-khan-js/renovate-test/pulls?q=is%3Apr+is%3Aclosed)
to see what renovate can do

### Grouping dependency updates

> "Generally, the first reaction people have to automated dependency updates
like Renovate is "oh great/feel the power of automation". The next reaction a
few days or weeks later is often "this is getting overwhelming".Indeed, if you
leave Renovate on its default settings of raising a PR every single time any
dependency receives any update.. you will get a lot of PRs and related
notifications"

The above quote is from [here](https://docs.renovatebot.com/noise-reduction/)

Given this directory structure:

```text
├── infra
│   ├── dev
│   │   └── deployment
│   │       └── terragrunt.hcl
│   └── prd
│       └── deployment
│           └── terragrunt.hcl
├── modules
│   ├── dummy_module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── dummy_stack
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfstate
│       ├── variables.tf
│       └── versions.tf
```

We want to group dependency updates by env (e.g. one PR to update all of `dev`)
and by module/stack (e.g. one PR to update everything in `dummy_stack`).

You can achieve this in Renovate by using `packageRules`. You can group
directories with a static rule e.g.

```json
"packageRules": [
    {
      "groupName": "dev",
      "matchPaths": ["**/infra/dev/**"]
    }
]
```

or by using a dynamic rule e.g.

```json
"packageRules": [
   {
      "groupName": "{{parentDir}}",
      "additionalBranchPrefix": "{{parentDir}}-",
      "matchPaths": ["**/modules/**"]
    }
]
```

Dynamic rules are useful for repos that have a high change rate e.g. a terraform
modules repo where new modules are regularly created, this means you don't have
to remember to create a rule every time you create a new terraform module.
