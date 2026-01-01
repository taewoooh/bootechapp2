import UIKit

class ViewController: UIViewController {
    //   override var recentSearchView: UIView? { recentView }   // 🔥 BaseVC에 연결
    let searchBar = SearchBarView1()
    let recentView = RecentSearchView()
    let cardScroll = HorizontalCardScrollView()
    let infoView = TransactionInfoView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.mainBackground
        

        
        // UI 세팅 순서대로 상위 포지션이 정해진다
        [searchBar, cardScroll, infoView, recentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            
        }
        // 🔥 최초 진입 시 숨김
        recentView.isHidden = true
        // 🔥 화면 탭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
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
        
        searchBar.onBeginEditing = { [weak self] in
            guard let self = self else { return }

            // 🔥 텍스트필드 터치 시
            // (아직 입력 안 했으면)
            self.recentView.isHidden = false
        }

        searchBar.onTextChanged = { [weak self] text in
            guard let self = self else { return }

            if text.count > 0 {
                // 🔥 글자 하나라도 입력되면 → 숨김
                self.recentView.isHidden = true
            } else {
                // 🔥 다시 비면 → 노출
                self.recentView.isHidden = false
            }
        }
        
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
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            cardScroll.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            cardScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardScroll.heightAnchor.constraint(equalToConstant: Dimens.Height.HeightButton),
            
            infoView.topAnchor.constraint(equalTo: cardScroll.bottomAnchor, constant: 1),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 80),
            
            
            recentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            recentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        // 🔹 1. 예시 데이터 생성 (지금은 하드코딩)
           let infoData = TransactionInfoData(
               dateString: "20260101",
               totalCount: 128,
               highPriceCount: 7,
               highPriceRate: 5.5,
               recoveryRate: 92.3
           )

           // 🔹 2. 재활용 View에 데이터 주입
           infoView.configure(with: infoData)

        searchBar.setPlaceholder("법정동, 아파트명 검색")

        
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        print("키보드 올라옴")
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("키보드 내려감")
        recentView.isHidden = true
        
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
