# tls-certificates

Create and manage TLS certificates, either with Let's Encrypt or using
self-signed ones.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `basename`:                  Base name for the TLS certs installation path.

* `common_name`:               Common name for the certificate request.

* `subject_alt_names`:         Subject alt name for the certificate request.

* `base_directory`:            Base installation directory for the TLS
                               certificates.

* `letsencrypt_key_path`:      Path to the Let's Encrypt private key.

* `letsencrypt_account_email`: Email used for the Let's Encrypt account.

* `letsencrypt_agreement_url`: URL to a terms of service document you agree to
                               when using the ACME service.

* `letsencrypt_api_url`:       TODO.

* `self_sign`:                 Boolean. If used, the role will use a self-signed
                               certificate instead of requesting one from Let's
                               Encrypt.

* `csr_path`:                  Path to the place where you want to save your
                               `.csr` file.

* `certificate_path`:          Path to the place where you want to save you
                               certificate file.

* `fullchain_path`:            Path to the place where you want to save your
                               fullchain certificate file.

* `privatekey_path`:           Path to the pace where you want to save you
                               private key file.
