#!/usr/bin/env bash

set -eu

humctl api delete /orgs/canyon-demo/action-pipelines/promote-environment || true
yq -o j << EOF | humctl api post /orgs/canyon-demo/action-pipelines -f -
description: |
  This path helps developers promote the state of one environment to another. This is often used to promote between development and staging, or stage and prod but can also be used
  to keep an ephemeral environment in sync with a source. 
github_workflow_params:
  access_token: $(op item get --account 'humanitecgmbh.1password.com' 'Github canyon-demo-samples API TOKEN' --fields credential)
  inputs:
    app_id: \${{ inputs.app_id }}
    env_id: \${{ inputs.env_id }}
    org_id: \${{ pipeline.org.id }}
    run-id: \${{ pipeline.run.id }}
  url: https://github.com/humanitec/canyon-demo-samples/blob/main/.github/workflows/create-ephemeral-environment.yaml
id: promote-environment
inputs:
  app_id:
    description: The app id which contains the source and target environments.
    type: string
    required: true
  source_env_id:
    description: The source environment id.
    required: true
    type: string
  target_env_id:
    description: The target environment id.
    required: true
    type: string
type: github-workflow
EOF
