
humctl api delete /orgs/canyon-demo/action-pipelines/create-application || true
yq -o j << EOF | humctl api post /orgs/canyon-demo/action-pipelines -f -
description: This action is a standard path to help developers create new applications. You MUST check if an application in this org already exists with the same id before running this tool.
github_workflow_params:
  access_token: $(op item get --account 'humanitecgmbh.1password.com' 'Github canyon-demo-samples API TOKEN' --fields credential)
  inputs:
    name: \${{ inputs.id }}
    org_id: \${{ pipeline.org.id }}
    owner: \${{ pipeline.run.run_as }}
    run-id: \${{ pipeline.run.id }}
  url: https://github.com/humanitec/canyon-demo-samples/blob/main/.github/workflows/create-application.yaml
id: create-application
inputs:
  id:
    description: The new application identifier. This should be less than 100 characters, alphanumeric with hyphens.
    required: true
    type: string
type: github-workflow
EOF
