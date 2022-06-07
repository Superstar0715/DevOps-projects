# Overview 
This is a dockerized version of my mtg pricer app. This will almost always be the most recent version, as the docket image gets pushed from the code here.

## How to use
Run `docker pull tanchwa/mtg-card-organizer:latest` on a Linux machine with docker to pull the image. Then `docker run -i mtg-card-organizer` to run the container in interactive mode.
You must run it in interactive mode, otherwise it will error out because it is expecting input.
