Grafana for Nim
===============

Grafana module for nim 🤷‍♂️


*note*: not stable enough to release to nimble

## Installing

`nimble install https://github.com/jamesalbert/grafana-nim.git@#head`

## Development

```sh
$ make up  # bring up docker
$ make ssh # run bash in grafana-nim container (*air quotes* ssh *end air quotes*)
```

It's not really a "testing environment", just a container to mess around with api calls.

## Examples

```nim
import grafana

let gc = newGrafanaClient("localhost:3000", "user", "pass") # or ("localhost:3000", "api-key")
gc.Dashboards()
```
