# Sosuzagram -> Telegram-iOS integration map

This document replaces the temporary shell-app plan with a real Telegram-iOS integration path.

## Required external inputs

A real Telegram-iOS build needs user-owned values:

- Telegram `api_id`
- Telegram `api_hash`
- Apple Team ID / signing profile for device IPA

Without those, GitHub Actions can only prepare sources and unsigned/resignable artifacts.

## Current core module

`Sources/SosuzagramIOSCore` contains the local message history core:

- `MessageSnapshot`
- `LocalHistoryItem`
- `LocalHistoryStore`
- `InMemoryLocalHistoryStore`
- `MessageHistoryService`

## Telegram-iOS hooks to wire

The first real integration pass should do this inside Telegram-iOS:

1. On normal cloud message receive/render/store:
   - create `MessageSnapshot`
   - call `recordIncomingMessage(...)`

2. On normal cloud message remove events:
   - collect `peerId` and message ids
   - call `recordMessageRemoval(peerId:messageIds:)`

3. UI layer:
   - if a message is no longer visible but has `localCopy`, show a local marker
   - tap opens local copy viewer

4. Settings:
   - add `Extra Settings -> Privacy Mods -> Local History`
   - expose toggles from `PrivacySettings`

## Boundaries

Do not wire this into private encrypted / TTL flows. The core settings skip those by default.

## Next implementation task

After bootstrapping upstream, search Telegram-iOS for update handling and message storage callsites, then add a small adapter module:

```text
Telegram message object -> Sosuzagram MessageSnapshot
Telegram remove event -> MessageHistoryService.recordMessageRemoval
```
