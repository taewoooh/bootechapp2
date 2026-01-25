import UIKit

final class RecentSearchRowView: UIView {

    private let label = UILabel()
    private let deleteButton = UIButton()

    // 🔥 콜백
    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?

    init(text: String) {
        super.init(frame: .zero)
        setupUI(text)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI(_ text: String) {

        // 🔹 검색어 텍스트
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRow))
        label.addGestureRecognizer(tap)

        // 🔹 X 버튼
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .systemGray2
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)

        // 🔹 Spacer (이게 핵심)
        let spacer = UIView()

        // 🔹 가로 스택
        let hStack = UIStackView(arrangedSubviews: [
            label,
            spacer,        // 👈 공간 다 먹음
            deleteButton   // 👈 항상 맨 오른쪽
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center

        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    @objc private func didTapRow() {
        onTap?()
    }

    @objc private func didTapDelete() {
        onDelete?()
    }
}
