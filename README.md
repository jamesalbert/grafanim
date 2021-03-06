Grafanim
========

Grafana module for nim 🤷‍♂️


## Installing

`nimble install grafanim`

## Development

```sh
$ make up  # bring up docker
$ make test # to run tests/test.nim
$ make ssh # run bash in grafanim container (*air quotes* ssh *end air quotes*)
```

It's not really a "testing environment", just a container to mess around with api calls.

## Examples

Credentials are defaults for InfluxDB and Grafana

```nim
import grafanim, json

let gc = newGrafanaClient("grafana:3000", "admin", "admin") # or ("grafana:3000", "api-key")

echo gc.NewDashboard( %* {
  "title": "new dash"
})

echo gc.NewInfluxDBDatasource( %* {
  "host": "localhost",
  "name": "BTCUSD",
  "database": "btc_usd",
  "user": "root",
  "pass": "root"
})

echo gc.Datasources()
echo gc.Dashboards()

```
