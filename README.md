# Terraform
##Terraform

This project demonstrates the following technologies.


* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) - Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.
* [hapi](https://hapi.dev) - a wonderful Node.js application framework
* [PostgreSQL](https://www.postgresql.org/) - a popular relational database
* [Postgres](https://github.com/porsager/postgres) - a new PostgreSQL client for Node.js
* [Vue.js](https://vuejs.org/) - a popular front-end library
* [Bulma](https://bulma.io/) - a great CSS framework based on Flexbox
* [EJS](https://ejs.co/) - a great template library for server-side HTML templates


**Requirements:**

* Azure account
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Node.js](https://nodejs.org/) 14.x
* [PostgreSQL](https://www.postgresql.org/) (can be installed on server using Docker)
* [Free Okta developer account](https://developer.okta.com/) for account registration, login
* [pm2](https://pm2.keymetrics.io/)

## Install and Configuration - web application
1. Conncte your Azure CLI to your Azure accont-`az login`.
2. initaliza the code for your project with terraform to create the environment that you wish.
4. Run `terraform init` (in the project directory) and then terraform apply, to apply your code to the portal.
5. once you see your vm you can now connect to them using bastion.

then you can do the next step to apply the app on your vm:

1. connect to the server
1. Clone source files from Github https://github.com/mekdesgid/bootcamp-app.git  to the server
1. Run `npm install` to install dependencies (need to be installed on the server)
1. create with **[nano]** file for your **[.env]** -
1.  inside your .env file you need to add PostgreSQL connection - using PostgreSQL ip adress
1.  change your HOST_URL adding the app external ip to connect
1.  Create a [free Okta developer account](https://developer.okta.com/) and add a web application for this app
1.  Copy `.env.sample` to `.env` and change the `OKTA_*` values to your application , inerst your okta client id + client secret .
             ***do not forget to add .gitignore file for your .env && node_modules***
1. install and update **[node.js --v 14]** on your server 
1. install pm2 - to stay connected to the server.
