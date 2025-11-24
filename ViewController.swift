import UIKit
import SwiftUI

// 🔹 1. SearchBarView는 ViewController 밖에 따로 정의
class SearchBarView: UIView {
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass") // 돋보기
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "법정동, 아파트명 검색"
        tf.borderStyle = .none
        tf.textColor = AppColors.edittextcolor1   // ← 텍스트 색상 설정
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let listsetUp: UIImageView = {
        let imageView = UIImageView()
       // imageView.image = UIImage(systemName: "list") // 새로고침
        imageView.image = UIImage(named: "list_setup")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        backgroundColor = AppColors.editbackground
        layer.cornerRadius = 12
        layer.masksToBounds = true

        addSubview(searchIcon)
        addSubview(textField)
        addSubview(listsetUp)

        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 22),
            searchIcon.heightAnchor.constraint(equalToConstant: 22),

            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: listsetUp.leadingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            listsetUp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            listsetUp.centerYAnchor.constraint(equalTo: centerYAnchor),
            listsetUp.widthAnchor.constraint(equalToConstant: 22),
            listsetUp.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
} //상단 검색 툴바
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
} //수평 카드뷰 리스트



// 🔹 2. ViewController는 이렇게 그대로 두면 됨
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = AppColors.mainBackground
       
        let searchBar = SearchBarView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        let cardScroll = HorizontalCardScrollView()
        cardScroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardScroll)

        cardScroll.setItems([
            ("일별실거래(매매)", UIImage(named : "daydown")),
            ("아파트찾기", UIImage(named: "searchdata")),
            ("이번 달 실거래", UIImage(named: "monthdata")),
            ("부동산뉴스", UIImage(named: "newspaper")),
            ("토지거래허가내역", UIImage(named: "target")),
            ("이번 달 국평순위", UIImage(named: "crown")),
            ("거래량 추이", UIImage(named: "upup")),
            ("앱 이해하기", UIImage(named: "idea2")),
            ("앱 공유하기", UIImage(named: "share2")),
            ("카톡 1:1문의", UIImage(named: "kakaoimage")),
            ("알림 설정", UIImage(named: "noti")),
            ("앱 정보", UIImage(named: "appinfor"))
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            cardScroll.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
                cardScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                cardScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                cardScroll.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

