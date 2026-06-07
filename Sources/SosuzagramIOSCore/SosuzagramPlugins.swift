import Foundation

private let sosuzagramPluginEnabledPrefix = "sosuzagram_plugin_enabled_"
private let sosuzagramPluginSettingPrefix = "sosuzagram_plugin_setting_"

public func sosuzagramPluginEnabledKey(_ pluginId: String) -> String {
    return sosuzagramPluginEnabledPrefix + pluginId
}

public func sosuzagramPluginSettingKey(_ pluginId: String, _ key: String) -> String {
    return "\(sosuzagramPluginSettingPrefix)\(pluginId)_\(key)"
}

public func sosuzagramPluginEnabled(_ pluginId: String) -> Bool {
    return UserDefaults.standard.object(forKey: sosuzagramPluginEnabledKey(pluginId)) as? Bool ?? true
}

public func sosuzagramSetPluginEnabled(_ pluginId: String, _ value: Bool) {
    UserDefaults.standard.set(value, forKey: sosuzagramPluginEnabledKey(pluginId))
}

public func sosuzagramPluginSettingBool(pluginId: String, key: String, defaultValue: Bool) -> Bool {
    return UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? Bool ?? defaultValue
}

public func sosuzagramPluginSettingString(pluginId: String, key: String, defaultValue: String) -> String {
    return UserDefaults.standard.string(forKey: sosuzagramPluginSettingKey(pluginId, key)) ?? defaultValue
}

public func sosuzagramPluginSettingInt(pluginId: String, key: String, defaultValue: Int) -> Int {
    if let stored = UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? Int {
        return stored
    }
    if let stored = UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? String, let value = Int(stored) {
        return value
    }
    return defaultValue
}

public func sosuzagramPluginSettingDouble(pluginId: String, key: String, defaultValue: Double) -> Double {
    if let stored = UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? Double {
        return stored
    }
    if let stored = UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? String, let value = Double(stored) {
        return value
    }
    if let stored = UserDefaults.standard.object(forKey: sosuzagramPluginSettingKey(pluginId, key)) as? Int {
        return Double(stored)
    }
    return defaultValue
}

enum SosuzagramPluginSettingControl {
    case toggle(defaultValue: Bool)
    case selector(defaultIndex: Int, options: [String])
    case input(defaultValue: String, numeric: Bool)
}

struct SosuzagramPluginSettingRow {
    let key: String
    let title: String
    let subtitle: String?
    let control: SosuzagramPluginSettingControl
}

enum SosuzagramPluginSettingsContent {
    case header(String)
    case info(String)
    case setting(SosuzagramPluginSettingRow)
}

struct SosuzagramPluginDescriptor {
    let id: String
    let name: String
    let desc: String
    let settingsBuilder: () -> [SosuzagramPluginSettingsContent]

    func settings() -> [SosuzagramPluginSettingsContent] {
        return self.settingsBuilder()
    }
}

func sosuzagramBuiltInPlugin(id: String) -> SosuzagramPluginDescriptor? {
    return sosuzagramBuiltInPlugins().first(where: { $0.id == id })
}

func sosuzagramBuiltInPlugins() -> [SosuzagramPluginDescriptor] {
    return [
        SosuzagramPluginDescriptor(
            id: "forwards",
            name: "Forwards",
            desc: "Показывает количество пересылок рядом со временем сообщения.",
            settingsBuilder: {
                [
                    .info("Плагин нативно отображает количество пересылок возле времени сообщения. Отдельных параметров у оригинального плагина нет.")
                ]
            }
        ),
        SosuzagramPluginDescriptor(
            id: "in_app_notifications",
            name: "In-App Notifications",
            desc: "Гибкие локальные уведомления Telegram внутри приложения.",
            settingsBuilder: inAppNotificationsSettings
        ),
        SosuzagramPluginDescriptor(
            id: "server_status",
            name: "Server Status",
            desc: "Показывает текущий пинг датацентра Telegram в заголовке списка чатов.",
            settingsBuilder: {
                [
                    .header("Мониторинг"),
                    .info("Нативная iOS-адаптация показывает статус в заголовке списка чатов и обновляет пинг в фоне.")
                ]
            }
        ),
        SosuzagramPluginDescriptor(
            id: "text_animation",
            name: "Text Animation",
            desc: "Анимация появления текста с эффектами Blur, Slide, Scale, Rotate и Thanos.",
            settingsBuilder: textAnimationSettings
        ),
        SosuzagramPluginDescriptor(
            id: "text_toolbar",
            name: "Text Toolbar",
            desc: "Нативное меню быстрого редактирования текста с настройками как в Extera.",
            settingsBuilder: textToolbarSettings
        )
    ]
}

private func toggleRow(_ key: String, _ title: String, _ subtitle: String? = nil, defaultValue: Bool) -> SosuzagramPluginSettingsContent {
    return .setting(SosuzagramPluginSettingRow(key: key, title: title, subtitle: subtitle, control: .toggle(defaultValue: defaultValue)))
}

private func selectorRow(_ key: String, _ title: String, _ options: [String], defaultIndex: Int, subtitle: String? = nil) -> SosuzagramPluginSettingsContent {
    return .setting(SosuzagramPluginSettingRow(key: key, title: title, subtitle: subtitle, control: .selector(defaultIndex: defaultIndex, options: options)))
}

private func inputRow(_ key: String, _ title: String, defaultValue: String, subtitle: String? = nil, numeric: Bool = true) -> SosuzagramPluginSettingsContent {
    return .setting(SosuzagramPluginSettingRow(key: key, title: title, subtitle: subtitle, control: .input(defaultValue: defaultValue, numeric: numeric)))
}

private func textToolbarSettings() -> [SosuzagramPluginSettingsContent] {
    let binaryOptions = ["Скрыть", "Показать"]
    let fullOptions = ["Скрыть", "Свернуть", "Показать"]

    return [
        .info("На iOS плагин встроен в меню форматирования текста и адаптирован под системный ввод."),
        .header("Кнопки"),
        selectorRow("set_30", "Растянуть на весь экран", binaryOptions, defaultIndex: 1),
        selectorRow("set_0", "Упомянуть", binaryOptions, defaultIndex: 1),
        selectorRow("set_10", "Форматирование", fullOptions, defaultIndex: 1),
        selectorRow("set_20", "Управление текстом", fullOptions, defaultIndex: 1),
        selectorRow("set_60", "Недавние эмодзи", fullOptions, defaultIndex: 1),
        selectorRow("set_40", "Повторить сообщение", binaryOptions, defaultIndex: 1),
        selectorRow("set_50", "Скрыть клавиатуру", binaryOptions, defaultIndex: 1)
    ]
}

private func inAppNotificationsSettings() -> [SosuzagramPluginSettingsContent] {
    let notifyAll = sosuzagramPluginSettingBool(pluginId: "in_app_notifications", key: "notify_all", defaultValue: false)
    let sourcePrivate = sosuzagramPluginSettingBool(pluginId: "in_app_notifications", key: "source_2", defaultValue: true)
    let duration = sosuzagramPluginSettingInt(pluginId: "in_app_notifications", key: "notification_duration", defaultValue: 0)
    let vibrator = sosuzagramPluginSettingBool(pluginId: "in_app_notifications", key: "vibrator", defaultValue: true)

    var rows: [SosuzagramPluginSettingsContent] = [
        .header("Настройки"),
        toggleRow("notify_all", "Все уведомления", defaultValue: false)
    ]

    if !notifyAll {
        rows.append(toggleRow("notify_mentions", "Упоминания", defaultValue: true))
        rows.append(toggleRow("notify_unmuted", "Не заглушенные", defaultValue: true))
        if sourcePrivate {
            rows.append(toggleRow("notify_only_private", "Все ЛС", defaultValue: true))
            rows.append(toggleRow("notify_archive", "Архив", defaultValue: true))
        }
    }

    rows.append(contentsOf: [
        .header("Чаты"),
        toggleRow("source_0", "Группы", defaultValue: true),
        toggleRow("source_1", "Каналы", defaultValue: true),
        toggleRow("source_2", "Приватные чаты", defaultValue: true),
        toggleRow("source_3", "Боты", defaultValue: true),
        .header("Кастомизация"),
        toggleRow("notification_position", "Отображать уведомление наверху", defaultValue: true),
        selectorRow("notification_duration", "Длительность", ["1.5 сек", "2.75 сек", "5 сек", "Своя"], defaultIndex: 0),
    ])

    if duration == 3 {
        rows.append(inputRow("notification_duration_custom", "Кастомная длительность", defaultValue: "5", subtitle: "Указывается в секундах."))
    }

    rows.append(contentsOf: [
        inputRow("notification_lines", "Количество строк", defaultValue: "2", subtitle: "Максимальное число строк текста в уведомлении."),
        selectorRow("button_action", "Действие", ["Открыть", "Прочитать", "Реакция"], defaultIndex: 0),
        toggleRow("vibrator", "Вибрация", "Может работать по-разному в зависимости от устройства.", defaultValue: true)
    ])

    if vibrator {
        rows.append(selectorRow("vibrator_power", "Сила вибрации", ["Слабая вибрация", "Средняя вибрация", "Сильная вибрация"], defaultIndex: 0))
    }

    rows.append(contentsOf: [
        toggleRow("ignore_system_notifications", "Игнорировать системные уведомления", "Работает только пока приложение открыто.", defaultValue: true),
        toggleRow("current_account_only", "Только текущий аккаунт", "Игнорировать уведомления остальных аккаунтов.", defaultValue: true),
        toggleRow("show_topics", "Отображать имя топика", defaultValue: true),
        toggleRow("blur_animation", "Блюр-анимация", defaultValue: true),
        .info("Часть параметров Extera адаптирована под нативную iOS-логику уведомлений и применяется только внутри Sosuzagram.")
    ])

    return rows
}

private func textAnimationSettings() -> [SosuzagramPluginSettingsContent] {
    let spoilerEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "spoiler_enabled", defaultValue: false)
    let slideEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "slide_enabled", defaultValue: true)
    let scaleEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "scale_enabled", defaultValue: false)
    let rotateEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "rotate_enabled", defaultValue: false)
    let deleteEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "delete_anim_enabled", defaultValue: true)
    let assembleEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "assemble_anim_enabled", defaultValue: false)
    let liquidEnabled = sosuzagramPluginSettingBool(pluginId: "text_animation", key: "liquid_cursor_enabled", defaultValue: false)

    var rows: [SosuzagramPluginSettingsContent] = [
        .info("Плагин нативно адаптирован для iOS. Основные параметры анимации применяются к появлению и удалению bubble-элементов."),
        .header("Основные"),
        toggleRow("animate_all_lines", "Анимировать все строки", "Не сбрасывать анимацию при переходе на новую строку.", defaultValue: false),
        .header("Спойлер"),
        toggleRow("spoiler_enabled", "Эффект спойлера", "Скрывать текст шумом перед анимацией.", defaultValue: false)
    ]

    if spoilerEnabled {
        rows.append(contentsOf: [
            inputRow("spoiler_duration", "Длительность спойлера (мс)", defaultValue: "1000"),
            inputRow("spoiler_particle_speed", "Скорость частиц", defaultValue: "50"),
            inputRow("spoiler_particle_count", "Количество частиц", defaultValue: "15"),
            inputRow("spoiler_fade_in", "Плавное появление (мс)", defaultValue: "150"),
            inputRow("spoiler_fade_out", "Плавное исчезновение (мс)", defaultValue: "200")
        ])
    }

    rows.append(contentsOf: [
        .header("Тайминги"),
        inputRow("duration", "Длительность (мс)", defaultValue: "300"),
        inputRow("blur_duration", "Длительность размытия (мс)", defaultValue: "300"),
        .header("Размытие"),
        toggleRow("blur_enabled", "Включить размытие", "Размытие при появлении.", defaultValue: true),
        inputRow("blur_radius", "Радиус размытия", defaultValue: "10"),
        inputRow("blur_text_delay", "Задержка текста (%)", defaultValue: "20"),
        .header("Слайд"),
        toggleRow("slide_enabled", "Включить слайд", "Буквы появляются сверху.", defaultValue: true)
    ])

    if slideEnabled {
        rows.append(inputRow("slide_dist", "Дистанция слайда", defaultValue: "20"))
    }

    rows.append(contentsOf: [
        .header("Масштаб"),
        toggleRow("scale_enabled", "Включить масштаб", "Масштабирование при появлении.", defaultValue: false)
    ])

    if scaleEnabled {
        rows.append(inputRow("scale_start", "Начальный масштаб", defaultValue: "0.0", subtitle: "0.0 - рост, больше 1.0 - уменьшение.", numeric: false))
    }

    rows.append(contentsOf: [
        .header("Поворот"),
        toggleRow("rotate_enabled", "Включить поворот", "Вращение при появлении.", defaultValue: false)
    ])

    if rotateEnabled {
        rows.append(inputRow("rotate_angle", "Угол поворота", defaultValue: "-15", numeric: false))
    }

    rows.append(contentsOf: [
        .header("Эффект Таноса"),
        toggleRow("delete_anim_enabled", "Эффект удаления", "Частицы при удалении.", defaultValue: true)
    ])

    if deleteEnabled {
        rows.append(contentsOf: [
            inputRow("particle_count", "Количество частиц", defaultValue: "5"),
            inputRow("particle_speed", "Скорость частиц", defaultValue: "50"),
            inputRow("particle_size", "Размер частиц", defaultValue: "50"),
            toggleRow("ignore_mass_delete", "Игнорировать при отправке", "Отключать эффект на массовом удалении текста.", defaultValue: true),
            inputRow("mass_delete_threshold", "Порог символов", defaultValue: "3")
        ])
    }

    rows.append(contentsOf: [
        .header("Обратный Танос"),
        toggleRow("assemble_anim_enabled", "Эффект появления", "Частицы собираются в символы.", defaultValue: false)
    ])

    if assembleEnabled {
        rows.append(contentsOf: [
            inputRow("assemble_particle_count", "Количество частиц", defaultValue: "5"),
            inputRow("assemble_particle_speed", "Скорость частиц", defaultValue: "50"),
            inputRow("assemble_particle_size", "Размер частиц", defaultValue: "50"),
            inputRow("assemble_spread", "Радиус разброса", defaultValue: "50")
        ])
    }

    rows.append(contentsOf: [
        .header("Курсор"),
        toggleRow("cursor_enabled", "Плавный курсор", "Плавное движение курсора.", defaultValue: true),
        inputRow("cursor_speed", "Скорость курсора (10-100)", defaultValue: "25"),
        inputRow("cursor_width", "Ширина курсора", defaultValue: "5"),
        toggleRow("liquid_cursor_enabled", "Жидкий курсор", "Деформация при движении.", defaultValue: false)
    ])

    if liquidEnabled {
        rows.append(inputRow("liquid_scale_factor", "Сила растяжения", defaultValue: "15"))
    }

    rows.append(contentsOf: [
        .header("Дополнительно"),
        toggleRow("ignore_spaces", "Игнорировать пробелы", "Не анимировать пробелы и частицы.", defaultValue: true),
        toggleRow("debug_mode", "Режим отладки", "Логирование ошибок анимации.", defaultValue: false)
    ])

    return rows
}
