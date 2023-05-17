# simple-vm-tf

"As a developer, I want to quickly stand up and tear down a Linux server with some sane defaults so I can have a reasonably secure sandbox to play around in and get on with my projects."

Deploy a [DigitalOcean](https://www.digitalocean.com/) droplet (Linux VM) with some basic security using terraform and cloud-init.

This will create a droplet in its own VPC with a static IP and a network firewall with an ssh inbound rule tied to your local public IP.  The droplet will also have a passwordless sudo user, and the following will be disabled:
- password auth
- root login
- x11 forwarding

The default SSH port is also changed, and the OS packages should be fully up to date. Everything is variable-ized so feel free to change anything you want.  The `cloud-init.sh` file can be expanded quite a lot (for example, add as many packages as you want in the `apt install` line).

Note: this assumes you're going to run a Debian or Ubuntu VM. If you want to run a different distro, further changes may be needed in `cloud-init.sh` and `variables.tf`

I intentionally chose the cheapest droplet ($4/month) as a starting point, feel free to change the droplet size to whatever you want (see Helpful Stuff at the bottom).

## Prereqs
1. Create a [Digital Ocean account](https://cloud.digitalocean.com/registrations/new)
2. Create a [Personal Access Token (PAT)](https://docs.digitalocean.com/reference/api/create-personal-access-token/) and store it somewhere safe
3. Create a local ssh key pair (defaults are fine): `ssh-keygen`
4. Install [terraform](https://www.terraform.io/downloads) and make sure it's in your `$PATH`

## How to Deploy

1. Clone repo, and go into directory `cd simple-vm-tf`
2. Change variables as needed in `variables.tf` and `cloud-init.sh`
3. Set a local environment variable for your DO PAT (optional) `export TF_VAR_do_pat=<PASTE PAT HERE>`
4. Initialize terraform `terraform init`
5. Run the plan `terraform plan`
6. Create all resources `terraform apply # enter yes to confirm`
7. Log into the [DO web console](https://cloud.digitalocean.com), and copy the reserved IP located in Networking > Reserved IPs
8. Connect to the instance (change values as needed)
```
ssh -p <SSH PORT> <USERNAME>@<RESERVED IP>

# e.g. given the defaults in the scripts:
ssh -p 55022 yoloadmin@<RESERVED IP>
```
Note: It might take a couple minutes for everything to be provisioned and cloud-init to complete all its tasks before you can ssh in.

9. Once connected, check if cloud-init completed successfully: `cloud-init status`.  You can also check the cloud-init logs with `less /var/log/cloud-init-output.log`

## How to Tear Everything Down

`terraform destroy # enter yes to confirm`

## Helpful Stuff

#### SSH Config
On your local machine, create a new file in this location: `~/.ssh/config`

And paste the following (change values as needed):
```
Host do
  HostName <RESERVED IP>
  User <USERNAME>
  Port <SSH PORT>
  IdentityFile /path/to/private/ssh/key
```
Then you can run this to connect to your droplet: `ssh do`

#### How to get a list of droplet sizes/images/regions

You can view all this information [here](https://slugs.do-api.dev) or alternatively, do the following:

- Install [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
- Authenticate with your PAT: `doctl auth init`
- To get droplet size name list: `doctl compute size list`
- To get droplet image name list: `doctl compute image list --public`
- To get droplet region name list: `doctl compute region list`
