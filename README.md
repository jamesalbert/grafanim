Grafana for Nim
===============

Grafana module for nim 🤷‍♂️


## Installing

`nimble install grafana-nim`

## Development

```sh
$ make up  # bring up docker
$ make ssh # run bash in grafana-nim container (*air quotes* ssh *end air quotes*)
```

It's not really a "testing environment", just a container to mess around with api calls.

## Examples

```nim
let gc = newGrafanaClient("localhost:3000", "user", "pass") # or ("localhost:3000", "api-key")
gc.Dashboards()
```
