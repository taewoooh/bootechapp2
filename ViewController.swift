import UIKit
import SwiftUI

// 🔹 1. SearchBarView는 ViewController 밖에 따로 정의
class SearchBarView: UIView , UITextFieldDelegate{
    
    //    var onBeginEditing: (() -> Void)?
    //    var onEndEditing: (() -> Void)?
    var onTextChanged: ((String) -> Void)?   // 🔥 텍스트 변경 콜백 추가
    
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
        tf.font = UIFont.systemFont(ofSize: Dimens.Font.FontSmall) // ← 텍스트 사이즈 클래스에서 불러오기
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let clearButton: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular)  // 크기 + 굵기
        
        iv.image = UIImage(named: "deletex")// 🔥 X 버튼
        
        iv.tintColor = .black
        iv.isHidden = true                      // 처음엔 숨김
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let clearHitArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
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
        textField.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textField.delegate = self
        setupUI()
    }

    private func setupUI() {
        backgroundColor = AppColors.editbackground
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        addSubview(searchIcon)
        addSubview(textField)
        addSubview(listsetUp)
        addSubview(clearHitArea)
        clearHitArea.addSubview(clearButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearText))
        clearHitArea.addGestureRecognizer(tap)
        
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 22),
            searchIcon.heightAnchor.constraint(equalToConstant: 22),
            
            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // 🔥 텍스트필드 오른쪽은 clearButton 왼쪽
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -8),
            
            clearHitArea.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearHitArea.widthAnchor.constraint(equalToConstant: 35),
            clearHitArea.heightAnchor.constraint(equalToConstant: 35),
            
            // 기존 clearButton 위치는 hitArea 안에서 가운데
            clearButton.centerXAnchor.constraint(equalTo: clearHitArea.centerXAnchor),
            clearButton.centerYAnchor.constraint(equalTo: clearHitArea.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 18),
            clearButton.heightAnchor.constraint(equalToConstant: 18),
            
            // 🔥 HitArea를 listsetUp 왼쪽에 배치 (기존 clearButton 위치 대체)
            clearHitArea.trailingAnchor.constraint(equalTo: listsetUp.leadingAnchor, constant: -20),
            // 🔥 리스트 셋업은 우측 끝
            listsetUp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            listsetUp.centerYAnchor.constraint(equalTo: centerYAnchor),
            listsetUp.widthAnchor.constraint(equalToConstant: 22),
            listsetUp.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    @objc private func clearText() {
        textField.text = ""
        clearButton.isHidden = true
        onTextChanged?("")  // 텍스트 변경 콜백 실행
    }
    
    @objc private func textDidChange() {
        let text = textField.text ?? ""
        clearButton.isHidden = text.isEmpty   // 🔥 text 길이에 따라 X 버튼 show/hide
        onTextChanged?(text)
    }
    
} //상단 검색 툴바 (법정동,아파트명
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
class TransactionInfoView: UIView {
    
    private let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemBlue
        v.layer.cornerRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = .black
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .darkGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let extraLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let extraLabel2: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    // 🔵 Horizontal: ● date info
    private lazy var topRow: UIStackView = {
        let st = UIStackView(arrangedSubviews: [dotView, dateLabel, infoLabel])
        st.axis = .horizontal
        st.spacing = 6   // 👉 날짜와 '전국' 사이 간격 추가
        st.alignment = .center
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    private lazy var bottomRow: UIStackView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let st = UIStackView(arrangedSubviews: [spacer, extraLabel, extraLabel2])
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .fill
        st.spacing = 4
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    
    
    // 🔵 전체 vertical 레이아웃 묶음
    private lazy var allStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [topRow, bottomRow])
        st.axis = .vertical
        st.spacing = 6
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
        addSubview(allStack)
        
        NSLayoutConstraint.activate([
            // 전체 스택을 오른쪽 정렬(trailing)
            allStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            allStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 8)
            
            
            
        ])
    }
    
    
    func setData(
        dateString: String,
        totalCount: Int,
        highPriceCount: Int,
        highPriceRate: Double,
        recoveryRate: Double
    ) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        
        dotView.isHidden = (dateString != fmt.string(from: Date()))
        
        dateLabel.text = dateString
        infoLabel.text = "전국 / 등록건수 : \(totalCount)건 / 신고가 : \(highPriceCount)건 ▼"
        extraLabel.text = "( 신고가율 : \(String(format: "%.1f", highPriceRate))% )"
        extraLabel2.text = "( 최고가대비 회복률 : \(String(format: "%.1f", recoveryRate))% )"
    }
}//전국/등록건수 : 1890건 .. 신고가율:6.0% 등등ㅋ
class RecentSearchView: UIView {
    
    private var closeButtonBottomConstraint: NSLayoutConstraint?
    
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최근검색"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .black
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)
        btn.setImage(UIImage(named: "deletex")?.withConfiguration(config), for: .normal)
        
        btn.tintColor = .darkGray
        btn.backgroundColor = .white
        
        // 🔥 반드시 버튼 크기의 절반
        btn.layer.cornerRadius = 26
        btn.layer.masksToBounds = false
        
        // 🔥 그림자는 작고 또렷하게
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.15
        btn.layer.shadowRadius = 8
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
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
        registerKeyboardNotifications()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        registerKeyboardNotifications()
        
    }
    @objc private func keyboardWillShow(_ noti: Notification) {
        guard
            let info = noti.userInfo,
            let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        // 🔥 여기서 "원하는 위치" 조정
        closeButtonBottomConstraint?.constant = -frame.height - 6
    }

    
    @objc private func keyboardWillHide(_ noti: Notification) {
        closeButtonBottomConstraint?.constant = -20
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func didTapCloseButton() { //최신검색 노출시 x 버튼 눌렀을때
        // 예시 1: 키보드 내리기
        window?.endEditing(true)   // 🔥 키보드 확실히 내림

        // 예시 2: 최근검색 뷰 숨기기
        isHidden = true
    }

    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(deleteAllButton)
        addSubview(listContainer)
        addSubview(closeButton)
        
        // 🔥 bottom constraint는 변수로 들고 있어야 함
        closeButtonBottomConstraint = closeButton.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        )
        closeButton.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )

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
            listContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            closeButtonBottomConstraint!,
            closeButton.widthAnchor.constraint(equalToConstant: 52),
            closeButton.heightAnchor.constraint(equalToConstant: 52)
            
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







class ViewController: BaseViewController {
    override var recentSearchView: UIView? { recentView }   // 🔥 BaseVC에 연결
    let searchBar = SearchBarView()
    let cardScroll = HorizontalCardScrollView()
    let infoView = TransactionInfoView()
    let recentView = RecentSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.mainBackground
        
        // 🔥 이 화면에서만 키보드 백버튼 활성화
        enableKeyboardBackButton = false
        
        // UI 세팅
        [searchBar, cardScroll, infoView, recentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        recentView.isHidden = true   // 초기 숨김
        
        
        // 🔥 SearchBar 텍스트 변화 예외 규칙
        searchBar.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            
            if text.isEmpty {
                // 텍스트 없음 → 최근검색 반드시 보이기
                self.recentSearchView?.isHidden = false
            } else {
                // 텍스트 있음 → 최근검색 반드시 숨기기
                self.recentSearchView?.isHidden = true
            }
        }
        
        // 카드 세팅
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
        
        // 레이아웃
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            cardScroll.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            cardScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardScroll.heightAnchor.constraint(equalToConstant: Dimens.Height.HeightButton),
            
            infoView.topAnchor.constraint(equalTo: cardScroll.bottomAnchor, constant: 9),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 80),
            
            recentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            recentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    // 🔥 백버튼 눌렀을 때 기능 덮어쓰기
    
    override func backAction() {
        view.endEditing(true)       // 키보드 내려감 → recentView도 자동 숨김
    }
}
