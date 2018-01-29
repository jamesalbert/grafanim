FROM nimlang/nim:latest

## Dependencies
RUN apt-get update
RUN apt-get install -y libssl-dev curl

RUN mkdir /app
WORKDIR /app
