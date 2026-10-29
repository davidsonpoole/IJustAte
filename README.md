# IJustAte

An iOS calorie and macro tracker. One log per day, holding foods picked from a
local catalog that syncs from [ijustate-server](https://github.com/davidsonpoole/ijustate-server).
Foods can also be logged by voice through a Siri shortcut ("Add Food").

SwiftUI + Core Data, iOS 15.5+, no third-party dependencies.

## Setup

Server addresses are not committed. Create your own config before building:

```sh
cp IJustAte/Shared/ServerConfig.example.swift IJustAte/Shared/ServerConfig.swift
```

Then edit it with your server's address and port. `ServerConfig.swift` is
gitignored, and the project will not compile until it exists.

Open `IJustAte.xcodeproj` and run the `IJustAte` scheme.

`ServerConfig.port` must match the port the server binds (default `8000`).

## Targets

| Target | Purpose |
| --- | --- |
| `IJustAte` | The app |
| `IJustAteIntent` | Siri extension handling `AddFoodIntent` |

Both share one Core Data store via the app group
`group.com.davidsonpoole.ijustate`; `PersistentHistoryObserver` keeps the two
processes' contexts in sync.

## Food catalog

Foods are either **local** (`FoodEntity.local == true`, created on-device) or
**global** (synced from the server, approved there first). Creating a food saves
it locally and submits it to the server for approval. When an approved food
arrives with the same name as a local one, `mergeDuplicateFood` promotes it:
existing log entries are repointed at the global copy and the local one is
deleted.

The client sends the last timestamp it received as `?time=` to fetch only what
changed. A `reset` in the response means "replace the global catalog with this
payload"; the client ignores a reset that arrives with no foods.
