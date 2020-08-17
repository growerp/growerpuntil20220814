# growerp ecommerce

Growerp flutter frontend multicompany ecommerce for external ordering for an ecommerce company.
Runs on Android, IOS and the web, demo at: https://ecommerce.growerp.com

It needs the Moqui.org backend system, more detail to install see the repository at: https://github.com/growerp/growerp-backend-mobile

A docker component can be created with the following command after docker is installed.

In the Dockerfile add --release for release version.

In this home directory execute:
docker build -t ecommerce .
docker run -d -p 5001:80 --name ecommerce ecommerce

in browser http://localhost:5001

