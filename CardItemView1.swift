import UIKit

// 🌟 하나의 카드뷰(텍스트 + 아이콘)를 구성하는 UIView
// 👉 Android의 CardView + TextView + ImageView 조합과 동일한 개념
class CardItemView1: UIView {

    // 카드의 텍스트를 표시할 Label
    private let titleLabel = UILabel()
    
    // 오른쪽 아이콘 영역
    private let iconView = UIImageView()

    // 외부에서 title과 icon을 넣어서 초기화
    init(title: String, icon: UIImage?) {
        super.init(frame: .zero)
        setupUI(title: title, icon: icon)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 👇 카드뷰 내부 UI 구성하는 함수
    private func setupUI(title: String, icon: UIImage?) {

        // 🟦 카드뷰 기본 스타일 설정 (배경, 라운드, 그림자)
        backgroundColor = .white                // 카드 배경색
        layer.cornerRadius = 15                 // 둥근 카드 모서리
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1               // 그림자 투명도
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4                  // 그림자 번짐 효과

        // 🟨 텍스트(Label) 설정
        titleLabel.text = title                 // 표시할 텍스트
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11)  // 글자 크기
        titleLabel.textColor = .black           // 글자 색상
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // 🟩 아이콘(ImageView) 설정
        iconView.image = icon                   // 아이콘 이미지
        iconView.tintColor = .black             // 아이콘 색상
        iconView.contentMode = .scaleAspectFit  // 이미지 비율 유지
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // 뷰에 추가
        addSubview(titleLabel)
        addSubview(iconView)

        // 🧩 오토레이아웃 제약조건 적용
        NSLayoutConstraint.activate([

            // 텍스트는 카드 왼쪽에서 14pt 떨어져 위치
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            // 아이콘은 텍스트 오른쪽에 6pt 간격으로 배치
            iconView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 6),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // 아이콘 크기 고정 (16x16)
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),

            // 카드뷰 전체 높이 고정 (Android XML의 40dp)
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

