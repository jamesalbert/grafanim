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
