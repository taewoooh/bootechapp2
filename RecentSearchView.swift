import UIKit

class RecentSearchView: UIView {
    
    // 🔥 외부(ViewController)로 전달
    var onSelectItem: ((String) -> Void)?
    var onDeleteItem: ((String) -> Void)?
    
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

    

    


    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(deleteAllButton)
        addSubview(listContainer)
      

   
        NSLayoutConstraint.activate([
            // 제목
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // 삭제버튼
            deleteAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            deleteAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // 리스트 영역
            listContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            listContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            listContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])
        
        
    }
    
    private func addRecentItem(_ text: String) {

        let row = RecentSearchRowView(text: text)

        // 🔹 검색어 선택
        row.onTap = { [weak self] in
            self?.onSelectItem?(text)
        }

        // 🔹 X 버튼 삭제
        row.onDelete = { [weak self] in
            self?.onDeleteItem?(text)
        }

        listContainer.addArrangedSubview(row)
    }
    
} //  최근검색 페이지 (SearchBar 터치 시 보여지는 레이어)

