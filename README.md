# Sosuzagram iOS 26

Sosuzagram iOS is an unofficial iOS client project based on Telegram-iOS.

Current status:

- `SosuzagramIOSCore` exists and is tested.
- Unsigned shell IPA pipeline works.
- Real Telegram-iOS upstream bootstrap is now added.
- Next step is wiring the core into Telegram-iOS message/update handling.

## Workflows

- `Sosuzagram iOS 26 Core` — tests the Swift core package.
- `Build Sosuzagram IPA` — builds the temporary shell IPA.
- `Release unsigned IPA` — creates a release for the temporary unsigned IPA.
- `Prepare Telegram iOS upstream` — clones Telegram-iOS and prepares the Sosuzagram overlay artifact.

## Real client path

Run:

```bash
bash scripts/bootstrap_telegram_ios.sh
bash scripts/prepare_sosuzagram_overlay.sh
```

Then follow `docs/TELEGRAM_IOS_INTEGRATION.md`.

A real Telegram-iOS IPA needs your own Telegram `api_id/api_hash` and Apple signing values.
