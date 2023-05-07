# simple-vm

"As a developer, I want to be able to quickly stand up and tear down a Linux server with some sane defaults/basic security so that I can have a reasonably secure sandbox to play around in and get on with my projects."

Deploy a [DigitalOcean](https://www.digitalocean.com/) droplet (Linux server) with some basic security using terraform and cloud-init.

This will create a droplet with a static IP and a network firewall with an ssh inbound rule tied to your local public IP.  The droplet will also have a passwordless sudo user, and the following will be disabled:
- password auth
- root login
- x11 forwarding

The default SSH port is also changed, and the OS packages should be fully up to date. Everything is variable-ized so feel free to change anything you want.  The cloud-init.yml file can be expanded quite a lot (for example, add as many packages as you want below the `packages:` line).

I intentionally chose the cheapest droplet ($5/month) as a starting point, feel free to change the droplet size to whatever you want (see Helpful Stuff at the bottom).

## Prereqs
0. This guide works on Linux/MacOS/Windows (either with Git Bash or WSL).
1. Create a [DO account](https://cloud.digitalocean.com/registrations/new)
2. Create a [Personal Access Token (PAT)](https://docs.digitalocean.com/reference/api/create-personal-access-token/) and store it somewhere safe
3. Create a local ssh key pair (defaults are fine):

    `ssh-keygen`
5. Install [terraform](https://www.terraform.io/downloads) and make sure it's in your `$PATH`

## How to Deploy

1. Clone repo, and `cd` into the directory:

    `cd dev-sandbox-starter-pack`
4. Change variables as needed in `variables.tf` and `cloud-init.yml`
5. Set a local environment variable for your DO PAT:

    `export TF_VAR_do_pat=<PASTE PAT HERE>`
7. Initialize terraform:

    `terraform init`
9. If init was successful, run:

    `terraform plan`
11. If plan was successful, run:

    `terraform apply # enter yes to confirm`
13. Log into the [DO web console](https://cloud.digitalocean.com), and copy the floating IP located in Networking > Floating IP
14. Connect to the instance (change values as needed):

```
ssh -p <SSH PORT> <USERNAME>@<FLOATING IP>

# e.g. given the defaults in the scripts:
ssh -p 55022 adminuser@<FLOATING IP>
```

   Note: It might take a couple minutes for everything to be provisioned and cloud-init to complete all its tasks.

9. Once connected, check if cloud-init completed successfully:

    `cloud-init status`

## How to Remove

To delete all resources, run:

`terraform destroy # enter yes to confirm`

## Helpful Stuff

#### SSH Config
On your local machine, create a new file in this location:
`~/.ssh/config`

And paste the following (change values as needed):
```
Host do
  HostName <FLOATING IP>
  User <USERNAME>
  Port <SSH PORT>
  IdentityFile /path/to/private/ssh/key
```
Then you can just run this to connect to your droplet:
`ssh do`

#### How to get a list of droplet sizes/images/regions

You can view all this information [here](https://slugs.do-api.dev) or alternatively, do the following:

1. Install [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
2. Authenticate with your PAT: `doctl auth init`
- To get droplet size name list: `doctl compute size list`
- To get droplet image name list: `doctl compute image list --public`
- To get droplet region name list: `doctl compute region list`
