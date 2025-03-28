#!/usr/bin/env bash

set -eu

humctl api delete /orgs/canyon-demo/action-pipelines/create-ephemeral-environment || true
yq -o j << EOF | humctl api post /orgs/canyon-demo/action-pipelines -f -
description: |
  This action is a path to help developers create a new temporary environment in an existing application in order to test a small change.
  You must give this path a unique name 'development-<random>'. This will clone the existing development and deploy.
github_workflow_params:
  access_token: $(op item get --account 'humanitecgmbh.1password.com' 'Github canyon-demo-samples API TOKEN' --fields credential)
  inputs:
    app_id: \${{ inputs.app_id }}
    env_id: \${{ inputs.env_id }}
    org_id: \${{ pipeline.org.id }}
    owner: \${{ pipeline.run.run_as }}
    run-id: \${{ pipeline.run.id }}
  url: https://github.com/humanitec/canyon-demo-samples/blob/main/.github/workflows/create-ephemeral-environment.yaml
id: create-ephemeral-environment
inputs:
  app_id:
    description: The existing app identifier to create the new environment in.
    type: string
    required: true
  env_id:
    description: The new environment identifier. This should be less than 100 characters, alphanumeric with hyphens.
    required: true
    type: string
type: github-workflow
EOF
