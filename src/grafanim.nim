import httpclient, json, base64


type
  GrafanaClient* = object
    cli: HttpClient
    url, key, user, pass: string


proc newGrafanaClient* (host: string, port: int, user: string, pass: string): GrafanaClient =
  let url = "http://" & host & ":" & $port & "/api/"
  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Basic " & encode(user & ":" & pass)
  })
  return GrafanaClient(cli: client, url: url)


proc newGrafanaClient* (host: string, port: int, key: string): GrafanaClient =
  let url = "http://" & host & ":" & $port & "/api/"
  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer " & key
  })
  return GrafanaClient(cli: client, url: url)


method Request (self: GrafanaClient, route: string): JsonNode {.base, gcsafe.} =
  let resp = self.cli.getContent(self.url & route)
  return parseJson(resp)


method Post (self: GrafanaClient, route: string, body: JsonNode): JsonNode {.base, gcsafe.} =
  let resp = self.cli.postContent(self.url & route, body = $body)
  return parseJson(resp)


method Login (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("login/ping")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


discard """
Get Methods
"""


method AdminSettings* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("admin/settings")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Settings* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("frontend/settings")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Keys* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("auth/keys")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Orgs* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("orgs")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Users* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("users")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Dashboard* (self: GrafanaClient, dashboard: string): JsonNode {.base.} =
  try:
    return self.Request("dashboards/db/" & dashboard)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Dashboards* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("dashboards/home")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method DashboardTags* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("dashboards/tags")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method SearchDashboards* (self: GrafanaClient, query: string, tag: string = "", starred = false, tagcloud = false): JsonNode {.base.} =
  try:
    var query = "?query=" & query
    query.add("&tag=" & tag)
    query.add("&starred=" & $starred)
    query.add("&tagcloud=" & $tagcloud)
    return self.Request("search" & query)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Datasources* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("datasources")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Datasource* (self: GrafanaClient, id: int): JsonNode {.base.} =
  try:
    return self.Request("datasources/" & $id)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Datasource* (self: GrafanaClient, name: string): JsonNode {.base.} =
  try:
    return self.Request("datasources/name/" & name)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method DatasourceId* (self: GrafanaClient, name: string): JsonNode {.base.} =
  try:
    return self.Request("datasources/id/" & name)
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


discard """
Post Methods
"""

method NewDashboard* (self: GrafanaClient, opts: JsonNode): JsonNode {.base, gcsafe.} =
  try:
    return self.Post("dashboards/db", %* {
      "dashboard": {
        "id": nil,
        "title": opts["title"].getStr,
        "tags": if opts.hasKey("tags"): opts["tags"].elems else: @[],
        "timezone": "browser",
        "rows": [ {} ],
        "schemaVersion": 6,
        "version": 0
      },
      "overwrite": true
    })
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method NewInfluxDBDatasource* (self: GrafanaClient, opts: JsonNode): JsonNode {.base, gcsafe.} =
  try:
    return self.Post("datasources", %* {
      "name": opts["name"].getStr,
      "database": opts["database"].getStr,
      "user": opts["user"].getStr,
      "password": opts["pass"].getStr,
      "url": "http://" & opts["host"].getStr & ":8086",
      "type": "influxdb",
      "access": "direct",
      "isDefault": false
    })
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }
