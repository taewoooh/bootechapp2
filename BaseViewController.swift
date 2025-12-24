import UIKit

class BaseViewController: UIViewController {

    let backButton = CustomBackButton()
    var enableKeyboardBackButton = false   // 특정 화면에서만 활성화

    // 🔥 자식 VC에서 재정의할 예정 (recentSearchView 연결)
    @objc var recentSearchView: UIView? { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupKeyboardNotification()

        backButton.onBack = { [weak self] in
            self?.backAction()
        }
    }

    func setupBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        backButton.isHidden = true
    }

    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if enableKeyboardBackButton { backButton.isHidden = false }
        recentSearchView?.isHidden = false
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if enableKeyboardBackButton { backButton.isHidden = true }
        recentSearchView?.isHidden = true
    }

    @objc func backAction() {
        view.endEditing(true) // 키보드 내림 -> recentView도 자동 숨김
    }
}
