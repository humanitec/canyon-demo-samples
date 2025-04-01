#!/usr/bin/env bash

set -eu

humctl api delete /orgs/canyon-demo/action-pipelines/link-postgres-resource-definition || true
yq -o j << EOF | humctl api post /orgs/canyon-demo/action-pipelines -f -
description: |
  This path adds a resource definition matching criteria for a postgres resource to this app and environment. This allows the postgres resource type to be used in the environment.
  Without doing this path, the deployment with a postgres resource may fail.
github_workflow_params:
  access_token: $(op item get --account 'humanitecgmbh.1password.com' 'Github canyon-demo-samples API TOKEN' --fields credential)
  inputs:
    app_id: \${{ inputs.app_id }}
    env_id: \${{ inputs.env_id }}
    org_id: \${{ pipeline.org.id }}
    run-id: \${{ pipeline.run.id }}
  url: https://github.com/humanitec/canyon-demo-samples/blob/main/.github/workflows/link-resource-definition.yaml
id: link-postgres-resource-definition
inputs:
  app_id:
    description: The app id which contains the environment.
    type: string
    required: true
  env_id:
    description: The environment id.
    required: true
    type: string
type: github-workflow
EOF
