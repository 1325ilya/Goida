# Sosuzagram iOS 26 Starter

Стартовый каркас для **Sosuzagram iOS** — неофициального iOS-клиента на базе Telegram-iOS.

Первый модуль: **Local Message History**. Клиент сохраняет локальный snapshot уже полученных сообщений и может показать их в UI, если в основном чате сообщение больше не отображается.

> Это не официальный Telegram. Для реального форка нужен свой `api_id/api_hash`, другое имя/иконка и соблюдение лицензий Telegram-iOS.

## Что внутри

- Swift Package `SosuzagramIOSCore`
- минимальное iOS-приложение `App/SosuzagramApp.swift`
- настройки privacy-модов
- модели message snapshot / archived item
- сервис локальной истории
- in-memory store для тестов
- GitHub Actions CI
- GitHub Actions build для `.ipa` artifact

## IPA

Actions -> `Build Sosuzagram IPA` -> artifact `Sosuzagram-ios26-unsigned-ipa`.

Это unsigned/resignable IPA. Для установки на iPhone его надо подписать своим сертификатом через SideStore / AltStore / Sideloadly / Xcode / Apple Developer certificate.

## Ограничения

- Работает только с сообщениями, которые клиент уже получил.
- Не достаёт старые сообщения с сервера.
- Медиа доступно только если уже было скачано/закэшировано.
- Private encrypted / TTL-чаты пропускаются.
- Всё хранится локально.

## Следующий этап

1. Подключить Telegram-iOS как upstream.
2. В обработке message updates вызывать `recordIncomingMessage`.
3. В обработке remove-events вызывать `recordMessageRemoval`.
4. Добавить `Extra Settings -> Privacy Mods -> Local History`.
5. В UI добавить badge и экран просмотра локальной копии.
