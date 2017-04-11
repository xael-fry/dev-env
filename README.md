# dev-env

## Vagrant
------

### Install 

1. You need to install [Vagrant](https://www.vagrantup.com/ "Vagrant")  
2. Go to the repository of the Vm of your choice
3. Run `vagrant up` with the provider of your choice ex: `vagrant up --provider=virtualbox` for [VirtualBox](https://www.virtualbox.org/)

### Update

If you already install the VM and you want to update it, just run 

```
vagrant provision
```


### VM description
------

#### LAMP

It is a simple LAMP VM on Debian wit:h **Apache, mySQL, php**.
It also contains additional packages:
- curl
- mod_rewrite

You need to create a file `config.yaml` from `config.default.yaml` and update the path of the folder you wan to share with the VM (it will be use a the root folder of Apache)
