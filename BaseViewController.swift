import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // 🔥 중앙 로고 이미지
        let imageView = UIImageView()
        imageView.image = UIImage(named: "illustration4")  // 파일명 그대로
        imageView.contentMode = .scaleAspectFit            // 비율 유지 (중요)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400),   // 필요하면 조절
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])

        // 🔥 2초 후 메인 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToMain()
        }
    }

    private func goToMain() {
        let mainVC = ViewController()   // 네 메인 페이지

        // NavigationController 생성
        let nav = UINavigationController(rootViewController: mainVC)

        // NavigationBar 숨기고 싶으면 (선택)
        nav.setNavigationBarHidden(true, animated: false)

        // root 변경 (인트로는 스택에서 제거)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = nav
        }
    }
}
