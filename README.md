A Docker container with very basic provisioning of Ubuntu + Apache + PHP7.0 + MySQL

# Usage
## OSX / Ubuntu:
`docker run -it --rm --name lamp -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/lamp`

## Windows:
`docker run -it --rm --name lamp -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/lamp`
