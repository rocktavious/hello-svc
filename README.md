# Sample App

A basic Go program that responds to requests with an environment variable templated into the response.

## Local Development

### Prerequisites

- Skaffold - `brew install skaffold`
- Kind - `brew install kind`
- Kubectl - `brew install kubectl`

### Deploy

1. `kind create cluster`
2. `skaffold dev --port-forward`
3. `curl localhost:8080/hello`

### Cleanup

1. `ctrl + c` to exit skaffold
2. `kind delete cluster`

## Production

### Prerequisites

- wget - `brew install wget`
- AWS CLI - `brew install awscli`
- AWS IAM Authenticator - `brew install aws-iam-authenticator`
- Terraform - `brew install terraform`
- Kubectl - `brew install kubectl`
- Skaffold - `brew install skaffold`

### Create Infrastructure

1. `cd ./terraform`
2. `terraform init`
3. `terraform apply` NOTE: This process should take approximately 10 minutes. 
4. `aws eks --region $(terraform output region) update-kubeconfig --name $(terraform output cluster_name)`
5. `cd ../`

### Deploy

1. `skaffold run -p staging`
2. `skaffold run -p prod`

### Cleanup

1. `skaffold delete -p staging`
2. `skaffold delete -p prod`

## Wins

- Localdev is slick, fast and painless
- Localdev is near identical to production
- VPC & EKS terraform modules help to get up and running quickly with sane defaults
- Building ontop of K8S gives alot of wins & future wins in terms of HA, Scaleability, Uptime, Observeability, Audit, CD, Ingress, Extensibility etc etc

## Failures

- No terraform remote state (would recommend GCS for state store & Alantis for gitops)
- EKS K8S API is public but protected by IAM (would recommend a VPN & Private Access only)
- VPC & EKS terraform modules are likely too black box (might need to fork and customize network security policies)
- Uses a single nat gateway (would recommend using 1 per AZ)
- Overly large CIDR (would recommend /19 per k8s cluster)
- Uses AWS CNI - Might require different CNI (if so would recommend not using EKS)
- No Network seperation between Prod/Staging copy of app (would recommend seperate k8s clusters)
- No reconciliation (IE Flux/gitops) so things could drift over time
- No observeability (would recommend an observeability platform - IE Datadog)
- Seperate k8s configs for stagings & production (would recommend kustomize or helm to reduce duplication)
- No CI process to speak of (would recommend github actions)
- Use's a ELB per app deployed in k8s (would recommend an ingress controller)