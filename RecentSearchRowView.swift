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

    // 🔹 최근검색 아이템(텍스트) 클릭 시 호출되는 메서드
    // - X 버튼이 아닌 "검색어 텍스트"를 탭했을 때만 실행됨
    // - RecentSearchView → ViewController 로 선택 이벤트를 전달하기 위한 콜백 트리거
    @objc private func didTapRow() {
        print("🟢 [RecentSearchRowView] 아이템 텍스트 클릭")
        
        // 🔥 선택된 검색어를 외부(View)로 전달
        onTap?()
    }

    // 🔹 최근검색 아이템의 X(삭제) 버튼 클릭 시 호출되는 메서드
    // - 해당 검색어 하나만 삭제하기 위한 이벤트
    // - RecentSearchView → ViewController 로 삭제 요청 전달
    @objc private func didTapDelete() {
        print("🔴 [RecentSearchRowView] X 버튼 클릭")
        
        // 🔥 삭제 대상 검색어를 외부(View)로 전달
        onDelete?()
    }
}
