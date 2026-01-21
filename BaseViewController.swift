import UIKit

class BaseViewController: UIViewController {
    
    /// 🔹 키보드 상태에 따라 표시/숨김 처리할 뷰
      weak var keyboardResponsiveView: UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDismissKeyboardOnTap()
        registerKeyboardNotifications()
        
    }

    /// 🔹 키보드 노출/숨김 Notification 등록
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// 🔹 키보드 올라올 때
     @objc private func keyboardWillShow(_ notification: Notification) {
         keyboardResponsiveView?.isHidden = false
     }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("🟥 keyboardWillHide CALLED")
        guard let text = currentSearchText(),
              !text.isEmpty else {
            
            print("🟥 text is nil or empty → return")
            return }

        RecentSearchStorage.save(text)
       // reloadRecentSearch()

    
    }

     // ⬇️ 자식 VC가 구현할 메서드
     func currentSearchText() -> String? { nil }
     func reloadRecentSearch() {}
    
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
    
    /// 🔹 화면 탭 시 키보드 내리기 공통 기능
    private func setupDismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// 🔹 키보드 숨기기
    @objc func dismissKeyboard() {
        view.endEditing(true)
        keyboardResponsiveView?.isHidden = true

    }
}
