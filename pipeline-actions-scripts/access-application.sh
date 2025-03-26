#!/usr/bin/env bash

set -eu

humctl api delete /orgs/canyon-demo/action-pipelines/access-project-abracadabra || true
yq -o j << EOF | humctl api post /orgs/canyon-demo/action-pipelines -f -
description: This action gives the calling user viewer role access on the project-abracadabra humanitec application so that they can retrieve environments, deployment sets, workloads, and deployment history.
github_workflow_params:
  access_token: $(op item get --account 'humanitecgmbh.1password.com' 'Github canyon-demo-samples API TOKEN' --fields credential)
  inputs:
    name: project-abracadabra
    org_id: canyon-demo
    user: \${{ pipeline.run.run_as }}
  url: https://github.com/humanitec/canyon-demo-samples/blob/main/.github/workflows/access-application.yaml
inputs: {}
id: access-project-abracadabra
type: github-workflow
EOF
