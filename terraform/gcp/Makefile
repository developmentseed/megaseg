# Settings
REMOTE_DIR=~/work
LOCAL_DIR=../../

##### You should not have to touch stuff below this line

PATH_SSH_KEY=.ssh/private_instance_gcp.pem
PATH_VM_ID=.vm-id
PATH_VM_IP=.vm-ip
PATH_VM_NAME=.vm-name

VM_ID=$(shell cat ${PATH_VM_ID}) # GCP resource ID
VM_CONN=$(shell cat ${PATH_VM_IP}) # user@IP
VM_NAME=$(shell cat ${PATH_VM_NAME}) # name

mkfile_path=$(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR=$(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# sync code
syncup:
	ssh -i ${PATH_SSH_KEY} -o IdentitiesOnly=yes ${VM_CONN} "mkdir -p ${REMOTE_DIR}/${CURRENT_DIR}"
	rsync -e "ssh -i ${PATH_SSH_KEY} -o IdentitiesOnly=yes" -avz --exclude="${LOCAL_DIR}.git/" --exclude-from=${LOCAL_DIR}.gitignore ${LOCAL_DIR} $(shell echo ${VM_CONN}:${REMOTE_DIR}/${CURRENT_DIR} | tr -d '[:space:]')
syncdown:
	rsync -e "ssh -i ${PATH_SSH_KEY}" -o IdentitiesOnly=yes" -avz --exclude="${LOCAL_DIR}.git/" --exclude-from=${LOCAL_DIR}.gitignore $(shell echo ${VM_CONN}:${REMOTE_DIR}/${CURRENT_DIR}/ | tr -d '[:space:]') ${LOCAL_DIR}

# start/stop instance
stop:
	gcloud compute instances stop ${VM_NAME}
start:
	gcloud compute instances start ${VM_NAME}
status:
	gcloud compute instances describe ${VM_NAME}

# ssh into machine with jupyter lab
ssh:
	ssh -i ${PATH_SSH_KEY} -L 8888:localhost:8888 -o IdentitiesOnly=yes ${VM_CONN}