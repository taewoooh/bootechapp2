import UIKit

class RecentSearchView: UIView {
    

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
        st.alignment = .leading
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
    
    // 👇 최근검색을 추가하는 함수
    func addRecentItem(_ text: String) {
        let lb = UILabel()
        lb.text = text
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = .darkGray
        listContainer.addArrangedSubview(lb)
    }
} //  최근검색 페이지 (SearchBar 터치 시 보여지는 레이어)

