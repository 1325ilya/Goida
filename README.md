# AyuGram iOS 26 Starter

Стартовый каркас для AyuGram-like iOS клиента на базе Telegram-iOS.

Цель первого этапа: сделать безопасный локальный модуль **Anti-delete / Deleted Messages Archive** — клиент сохраняет копию уже полученных сообщений и помечает их как удалённые, когда приходит событие удаления.

> Важно: это не официальный Telegram/AyuGram. Нельзя использовать имя Telegram и стандартный логотип так, будто приложение официальное.

## Что уже заложено

- Swift Package `AyuGramIOSCore`
- модуль `DeletedMessageArchiveService`
- локальное хранилище-интерфейс для будущей SQLite-интеграции
- In-memory store для тестов
- unit-тесты anti-delete логики
- GitHub Actions workflow для проверки на macOS/Xcode
- черновой формат `.iosplug`
- инструкция, как потом вшивать это в Telegram-iOS

## Что делает Anti-delete

```text
Новое сообщение пришло
→ если фича включена
→ сохраняем локальный snapshot

Telegram прислал delete update
→ не удаляем snapshot
→ помечаем message.isDeleted = true
→ UI потом показывает deleted badge / раскрытие оригинала
```

## Ограничения

- Работает только с сообщениями, которые клиент уже получил.
- Не восстанавливает сообщения, удалённые до установки мода.
- Медиа сохраняется только если оно уже было скачано/закэшировано.
- Secret chats / self-destruct / TTL сообщения намеренно не архивируются.
- Архив локальный, без отправки на сервер.

## GitHub Actions

Открой вкладку **Actions** → запусти `AyuGram iOS 26 Core`.

Workflow сейчас проверяет Swift-код и тесты. Реальная сборка Telegram-iOS/IPA будет отдельным шагом после добавления:

- `TELEGRAM_API_ID`
- `TELEGRAM_API_HASH`
- Apple Team ID
- provisioning profile / certificate, если нужна IPA на устройство

## Следующий этап

1. Форкнуть/подключить `Telegram-iOS`.
2. Найти место обработки `updateDeleteMessages` / `updateDeleteChannelMessages`.
3. Перед штатным удалением вызывать `DeletedMessageArchiveService.handleDeletion(...)`.
4. В Message UI добавить badge `deleted` и экран просмотра сохранённого текста.
5. Добавить `Extra Settings → Privacy Mods → Anti-delete`.
