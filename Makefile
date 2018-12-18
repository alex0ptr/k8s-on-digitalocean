
default: apply

init:
	rm -Rf .terraform/environment
	terraform init -reconfigure

apply: 
	terraform apply -var token=$$(cat ~/.config/doctl/config.yaml | grep access-token | cut -d ' ' -f 2) -var username=$$(whoami)
	echo 'cluster created, now run `alias kc="kubectl --kubeconfig kubeconfig.yaml"` to finish setup'

plan: 
	terraform plan -var token=$$(cat ~/.config/doctl/config.yaml | grep access-token | cut -d ' ' -f 2)  -var username=$$(whoami)

destroy: 
	terraform destroy -var token=$$(cat ~/.config/doctl/config.yaml | grep access-token | cut -d ' ' -f 2) -var username=$$(whoami)

brew:
	brew install terraform doctl || true
