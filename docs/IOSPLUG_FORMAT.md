# .iosplug draft

`.iosplug` — это zip-пакет для будущих sandboxed-плагинов Sosuzagram iOS.

## Структура

```text
Example.iosplug
├── manifest.json
├── main.js
├── icon.png
└── resources/
```

## manifest.json

```json
{
  "id": "com.sosuzagram.example",
  "name": "Example Plugin",
  "version": "1.0.0",
  "entry": "main.js",
  "permissions": ["ui.read", "ui.modify", "storage.local"],
  "minClientVersion": "1.0.0"
}
```

На iOS такие плагины должны быть скриптами/конфигами в sandbox. Нативные Android `.dex/.jar/.so` не запускаются напрямую.
