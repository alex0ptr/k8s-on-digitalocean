# Kubernetes 101 on Digitalocean

This is a quick and dirty automation for creating a dev cluster on digitalocean.

## Prerequisites

You'll need `doctl` and `terraform` installed. If you are on a Mac just run `make brew` and then run `doctl auth init` and follow the setup instructions. 

NOTE: `doctl` is not really necessary as the `makefile` just greps the token from the config. However it is likely that you'll need doctl anyways, if you use Digitalocean.

## Spin Up the cluster

Just run `make init` once and then `make apply` and confirm with `yes` to make sure you agree with what will be provisioned. (If you fully trust this automation, add `-auto-approve` to avoid the prompt for future executions.)
Finally run `alias kc="kubectl --kubeconfig kubeconfig.yaml"` to set your current shell to the newly created cluster and have fun. 

When you're done run `make destroy` and all resources will be destroyed.

Customize the amount and types of nodes you want in `default.auto.tfvars`.
