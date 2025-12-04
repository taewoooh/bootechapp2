import UIKit

class CustomBackButton: UIView {

    var onBack: (() -> Void)?   // 콜백 (VC에서 사용할 용도)

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.backward.circle")    // ← 뒤로가기 아이콘
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22)
        ])

        // 터치 가능하도록
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backPressed))
        addGestureRecognizer(tap)
    }

    @objc private func backPressed() {
        onBack?()
    }
}
