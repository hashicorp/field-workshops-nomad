/*******************************************************************************

    file:           populate.sql
    author:         Patrick Gryzan
    date:           02/14/20
    description:    Used for populating the demo application Postgres database

********************************************************************************/

/*  Create the Table    */
CREATE TABLE hashistack (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    image_link VARCHAR NOT NULL,
    site_link VARCHAR NOT NULL,
    is_enterprise BOOLEAN NOT NULL
);

/*  Nomad   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Nomad',
    'Nomad is a flexible workload orchestrator that enables an organization to easily deploy and manage any containerized or legacy application using a single, unified workflow. Nomad can run a diverse workload of Docker, non-containerized, microservice, and batch applications.',
    '/css/img/Nomad_PrimaryLogo_FullColor.png',
    'https://nomadproject.io',
    true
);

/*  Consul   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Consul',
    'Consul is a service mesh solution providing a full featured control plane with service discovery, configuration, and segmentation functionality. Each of these features can be used individually as needed, or they can be used together to build a full service mesh.',
    '/css/img/Consul_PrimaryLogo_FullColor.png',
    'https://www.consul.io',
    true
);

/*  Vault   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Vault',
    'Vault is a tool for securely accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, or certificates. Vault provides a unified interface to any secret, while providing tight access control and recording a detailed audit log.',
    '/css/img/Vault_PrimaryLogo_FullColor.png',
    'https://www.vaultproject.io',
    true
);

/*  Terraform   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Terraform',
    'Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.',
    '/css/img/Terraform_PrimaryLogo_FullColor.png',
    'https://www.terraform.io',
    true
);

/*  Packer   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Packer',
    'Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel.',
    '/css/img/Packer_PrimaryLogo_FullColor.png',
    'https://packer.io',
    false
);

/*  Vagrant   */
INSERT INTO hashistack (name, description, image_link, site_link, is_enterprise) VALUES (
    'Vagrant',
    'Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases production parity, and makes the "works on my machine" excuse a relic of the past.',
    '/css/img/Vagrant_PrimaryLogo_FullColor.png',
    'https://www.vagrantup.com',
    false
);