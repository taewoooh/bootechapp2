import UIKit

class HorizontalCardScrollView: UIView {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let hStack: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 12
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
        addSubview(scrollView)
        scrollView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            //            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            //            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            
            hStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            hStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    // 👇 이 함수가 있어야 ViewController에서 쓸 수 있음!
    func setItems(_ items: [(String, UIImage?)]) {
        items.forEach { item in
            let card = CardItemView1(title: item.0, icon: item.1)
            hStack.addArrangedSubview(card)
        }
    }
} //수평 카드뷰 리스트 (일별실거래,아파트찾기,이번 달 실거래 등등..)
