import UIKit

class RecentSearchView: UIView {
    
    // 🔥 외부(ViewController)로 전달
    var onSelectItem: ((String) -> Void)?
    var onDeleteItem: ((String) -> Void)?
    
    

    
    @objc private func didTapItem(_ gesture: UITapGestureRecognizer) {

        // 🔥 터치된 위치
        let location = gesture.location(in: gesture.view)

        // 🔥 X 버튼 영역이면 아이템 선택 무시
        if let itemView = gesture.view {
            for subview in itemView.subviews {
                if let button = subview as? UIButton {
                    if button.frame.contains(location) {
                        return   // ⛔️ 여기서 끝 (선택 안 됨)
                    }
                }
            }
        }

        // 🔹 여기까지 왔으면 "아이템 선택"
        guard let text = gesture.view?.accessibilityLabel else { return }
        onSelectItem?(text)
    }
    
    private var items: [String] = []
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최근검색"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .black
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    func update(list: [String]) {

        // 1️⃣ 기존에 그려져 있던 최신검색 전부 제거
        listContainer.arrangedSubviews.forEach {
            listContainer.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // 2️⃣ 최신순(내림차순) 리스트 다시 그리기
        for text in list {
            addRecentItem(text)
        }
    }


    
    private let deleteAllButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("전부삭제", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    
    private let listContainer: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 10
        st.alignment = .fill      // ✅ 이걸로 변경
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
      
        
    }

    

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        return sv
    }()


    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(deleteAllButton)
        addSubview(scrollView)
        scrollView.addSubview(listContainer)
      

   
        NSLayoutConstraint.activate([
            // 제목
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            // 삭제버튼
            deleteAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            deleteAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            // 🔹 스크롤뷰 영역
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // 🔹 스택뷰를 스크롤뷰 안에 고정
            listContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            listContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            listContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            listContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // 🔥 세로 스크롤 고정 (이 줄 매우 중요)
            listContainer.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -32
            )
        ])
        
        
    }
    @objc private func deleteItemTapped(_ sender: UITapGestureRecognizer) {
        guard let text = sender.view?.accessibilityLabel else { return }
        onDeleteItem?(text)
    }
    private func addRecentItem(_ text: String) {

        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.isUserInteractionEnabled = true

        // 🔹 텍스트
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        // 🔹 X 버튼
        let deleteButton = UIButton(type: .system)

    
        // 🔥 아이콘 크기 조절
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        deleteButton.setImage(
        UIImage(systemName: "xmark", withConfiguration: config),
        for: .normal
        )


        deleteButton.tintColor = .systemGray
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        // 🔥 X 버튼 터치 영역 (크게)
        let deleteHitArea = UIView()
        deleteHitArea.translatesAutoresizingMaskIntoConstraints = false
        deleteHitArea.isUserInteractionEnabled = true
        // 🔹 삭제 이벤트
        deleteHitArea.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(deleteItemTapped(_:)))
        )
        deleteHitArea.accessibilityLabel = text
        
        itemView.addSubview(label)
        itemView.addSubview(deleteHitArea)
        deleteHitArea.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            // label
            label.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),

            // 🔥 deleteHitArea (터치 영역 크게)
            deleteHitArea.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -4),
            deleteHitArea.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            deleteHitArea.widthAnchor.constraint(equalToConstant: 44),
            deleteHitArea.heightAnchor.constraint(equalToConstant: 44),

            // 🔥 실제 X 아이콘은 가운데
            deleteButton.centerXAnchor.constraint(equalTo: deleteHitArea.centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: deleteHitArea.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 12),
            deleteButton.heightAnchor.constraint(equalToConstant: 12),

            // label이 X 영역 침범 안 하게
            label.trailingAnchor.constraint(lessThanOrEqualTo: deleteHitArea.leadingAnchor, constant: -12),

            // 행 높이
            itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        // 🔥 행 선택 (X 버튼 제외 영역)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapItem(_:)))
        tap.cancelsTouchesInView = false   // 중요
        itemView.addGestureRecognizer(tap)

        itemView.accessibilityLabel = text
        listContainer.addArrangedSubview(itemView)
    }
    
} //  최근검색 페이지 (SearchBar 터치 시 보여지는 레이어)

