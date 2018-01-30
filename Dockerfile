FROM nimlang/nim:latest

## Dependencies
RUN apt-get update
RUN apt-get install -y libssl-dev curl
RUN nimble install -y https://github.com/jamesalbert/grafanim.git@#head

RUN mkdir /app
WORKDIR /app
