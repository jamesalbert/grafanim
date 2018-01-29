import httpclient, json, base64


type
  GrafanaClient* = object
    cli: HttpClient
    url, key, user, pass: string


proc newGrafanaClient* (host: string, user: string, pass: string): GrafanaClient =
  let url = "http://" & host & "/"
  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Basic " & encode(user & ":" & pass)
  })
  return GrafanaClient(cli: client,
                       url: url)


proc newGrafanaClient* (host: string, key: string): GrafanaClient =
  let url = "http://" & host & "/"
  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer " & key
  })
  return GrafanaClient(cli: client,
                       url: url)


method Request (self: GrafanaClient, route: string): JsonNode {.base.} =
  let resp = self.cli.getContent(self.url & route)
  return parseJson(resp)


method Post (self: GrafanaClient, route: string, body: JsonNode): JsonNode {.base.} =
  let resp = self.cli.postContent(self.url & route, body = $body)
  return parseJson(resp)


method Login (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/login/ping")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


discard """
Get Methods
"""


method AdminSettings* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/admin/settings")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Settings* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/frontend/settings")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Keys* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/auth/keys")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Orgs* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/orgs")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Users* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/users")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


method Dashboards* (self: GrafanaClient): JsonNode {.base.} =
  try:
    return self.Request("api/dashboards/db")
  except HttpRequestError as e:
    return %* {
      "error": e.msg
    }


discard """
Post Methods
"""

method NewDashboard* (self: GrafanaClient, title: string, tags: seq[string] = @[]): JsonNode {.base.} =
  try:
    return self.Post("api/dashboards/db", %* {
      "dashboard": {
        "id": nil,
        "title": title,
        "tags": tags,
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
