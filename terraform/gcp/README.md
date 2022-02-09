# Deploy GPU ML instance in GCP

## Setup

Follow the steps described in [this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication) to setup GCP authentication.

Install the [terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Import the base image

In case your project doesn't have a the `ubuntu-2004-cuda-conda-fastai-v1` image import it, in the [console](https://console.cloud.google.com/compute/imagesAdd) or using the command line:

```
gcloud compute images import ubuntu-2004-cuda-conda-fastai-v1 --source-file=gs://ml-machine-images/ubuntu-2004-cuda-conda-fastai-v1.vmdk --no-guest-environment
```

## Adapt `variables.tf` file

Navigate to the folder containing `main.tf`. Adapt the `variables.tf` file as needed, specifically the `project`, the `instance-type` and the `location`.

## Deploy

Navigate to the folder containing the `main.tf` file. Run `terraform init`.

Check your deployment with `terraform plan`.

You can create your instance with `terraform apply`.

This will create a GCP Compute instance, and save in your local machine a private ssh key (in `.ssh/`), and a series of `.vm-X` files containing identity information for your instance. **Do not delete or modify this files!**

## `make` tools

You can now use the set of tools included in the `Makefile`. Adapt this file if needed in case you want to change the remote and local path to copy files into the instance.

- `make ssh`: connects to your instance in your shell. This also maps the port 8888 in the instance to your localhost, allowing you to serve a jupyter instance via this ssh tunnel (for instance by running `jupyter lab --allow-root`).
- `make start`, `make stop`, `make status` : Start, stop and check the status of your instance. **Important: if you are not using your instance, make sure to run `make stop` to avoid excessive costs! Don't worry, your instance state and files are safe.**
- `make syncup` and `make syncdown`: Copies files in your folder from and to your instance.

## Destroy

When you finish all work associated with this instance make sure to run `terraform destroy`. This will delete the ssh key in `.ssh` and all `.vm-X` files.

**Important: when you destroy your instance, all files and instance state are deleted with it so make sure to back them up to GCS or locally if needed!**