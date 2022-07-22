# Overview 
This is a dockerized version of my mtg pricer app. This will almost always be the most recent version, as the docker image gets pushed from the code here.

## How to use
Run `docker pull tanchwa/mtg-card-organizer:latest` on a Linux machine with docker to pull the image. Then `docker run -i mtg-card-organizer` to run the container in interactive mode.
You must run it in interactive mode, otherwise it will error out because it is expecting input.

A short demo is included at run-time with 5 cards. If you would like to run the price scraper without this demo, append `--hush-demo=true` to the end of the docker run command. 

## What I've learned
I still have a little bit of work to write cleaner, and more efficient code. As I understand more about how Python works, I'll be able to trim the fat more. For example, one of my dev friends pointed out that the "replace" command should only do it where that argument is true, thus rendering an IF statement redundant. Moving forward, I'll also write better functions and modules to coincide with Python's idiomatic nature. I.e., calling functions verbs instead of nouns, making classes or modules plural, etc. A good example of this would be to change "card_price_lookup" to "lookup_card_price." 
