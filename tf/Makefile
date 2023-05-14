help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

pause: ## Shut down the AWS instances but save their storage
	terraform show -no-color | grep "\sid\s" | tr -d ' ' | cut -c 5-23 | tr '\n' ' ' > instance_ids.txt
	aws ec2 stop-instances --instance-ids $$(cat instance_ids.txt)
	rm instance_ids.txt

resume: ## Start the AWS instances that were paused
	terraform show -no-color | grep "\sid\s" | tr -d ' ' | cut -c 5-23 | tr '\n' ' ' > instance_ids.txt
	aws ec2 start-instances --instance-ids $$(cat instance_ids.txt)
	rm instance_ids.txt
