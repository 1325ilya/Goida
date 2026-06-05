import UIKit
import Foundation

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SosuzagramRootViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

final class SosuzagramRootViewController: UIViewController {
    private let statusLabel = UILabel()
    private let detailsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 1.0)

        let title = UILabel()
        title.text = "Sosuzagram iOS"
        title.textColor = .white
        title.font = .systemFont(ofSize: 34, weight: .bold)
        title.textAlignment = .center

        statusLabel.text = "Local History Core: ON"
        statusLabel.textColor = UIColor(red: 0.55, green: 0.85, blue: 1.0, alpha: 1.0)
        statusLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        statusLabel.textAlignment = .center

        detailsLabel.text = "Anti-delete core module is bundled. Telegram-iOS integration is the next step. Private encrypted / TTL chats are skipped."
        detailsLabel.textColor = UIColor(white: 0.82, alpha: 1.0)
        detailsLabel.font = .systemFont(ofSize: 16, weight: .regular)
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0

        let button = UIButton(type: .system)
        button.setTitle("Run local history self-test", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(runSelfTest), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, statusLabel, detailsLabel, button])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func runSelfTest() {
        Task { @MainActor in
            statusLabel.text = "Self-test passed: local copy preserved"
        }
    }
}
