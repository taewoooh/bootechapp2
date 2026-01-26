import UIKit

class ViewController: BaseViewController {
    
    // 🔹 커스텀 검색바 (SearchBarView1 내부에 UITextField 존재)
    let searchBar = SearchBarView1()
    
    // 🔹 최신 검색어 목록을 보여주는 뷰
    let recentView = RecentSearchView()
    
    // 🔹 상단 가로 카드 메뉴 (일별실거래, 아파트찾기 등)
    let cardScroll = HorizontalCardScrollView()
    
    // 🔹 실거래 요약 정보 뷰 (총 건수, 신고가 비율 등)
    let infoView = TransactionInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 🔹 최초 진입 시 최신검색뷰는 숨김
        recentView.isHidden = true
        // 🔹 키보드에 반응할 뷰 등록
        keyboardResponsiveView = recentView
        // 🔹 최신검색뷰를 SearchBarView1에 연결
        // - 텍스트 변경, 키보드 상태에 따라
        // - SearchBarView1 내부 로직에서 show / hide 처리됨
        searchBar.recentSearchView = recentView
        
        // 🔹 메인 배경색 설정
        view.backgroundColor = AppColors.mainBackground
        
        // 🔹 UI 컴포넌트들을 화면에 추가
        // ⚠️ 추가 순서가 z-index(겹침 순서)에 영향을 줌
        [searchBar, cardScroll, infoView, recentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
       
        // 🔥 검색바 포커스(터치) 시
        searchBar.onBeginEditing = { [weak self] in
            guard let self = self else { return }

            // ✅ 최신검색뷰가 보일 타이밍 = 무조건 리스트 로드
            let list = RecentSearchStorage.load()
            self.recentView.update(list: list)

            // (이미 노출 로직이 있다면 이 줄은 없어도 됨)
            self.recentView.isHidden = false
        }
   
        // 🔹 상단 카드 메뉴 데이터 설정
        cardScroll.setItems([
            ("일별실거래(매매)", UIImage(named: "daydown")),
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
        
        // 🔹 오토레이아웃 설정
        NSLayoutConstraint.activate([

            // 🔹 검색바 레이아웃
            // - SafeArea 기준 상단 여백 20
            // - 좌우 여백 20으로 중앙 정렬
            // - 고정 높이(50)로 검색 입력 영역 확보
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            // 🔹 상단 카드 스크롤 레이아웃
            // - 검색바 바로 아래 배치
            // - 화면 전체 폭 사용
            // - 고정 높이로 버튼/카드 영역 유지
            cardScroll.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            cardScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardScroll.heightAnchor.constraint(equalToConstant: Dimens.Height.HeightButton),

            // 🔹 실거래 요약 정보 영역
            // - 카드 스크롤 바로 아래 배치
            // - 화면 가로 전체 사용
            // - 고정 높이로 요약 정보 안정적 표시
            infoView.topAnchor.constraint(equalTo: cardScroll.bottomAnchor, constant: 1),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 80),

            // 🔹 최신검색뷰 레이아웃 (오버레이 영역)
            // - 검색바 바로 아래부터 시작
            // - 화면 하단까지 확장
            // - 검색 중일 때 결과/히스토리를 덮어씌우는 용도
            recentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            recentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        
        // 🔹 실거래 요약 정보 예시 데이터 (임시)
        let infoData = TransactionInfoData(
            dateString: "20260101",
            totalCount: 128,
            highPriceCount: 7,
            highPriceRate: 5.5,
            recoveryRate: 92.3
        )
        
        // 🔹 TransactionInfoView에 데이터 주입
        infoView.configure(with: infoData)
        
        // 🔹 검색바 placeholder 설정
        searchBar.setPlaceholder("법정동, 아파트명 검색")
        
        recentView.onSelectItem = { [weak self] text in
            guard let self = self else { return }

            // 1️⃣ 검색바 텍스트 설정
            self.searchBar.setText(text)

            
            // 🔥 2️⃣ 텍스트 길이 기준으로 X 버튼 제어 (이 줄 추가)
            self.searchBar.showClearButton(text.count > 0)
            
            // 2️⃣ 키보드 내리기
            self.view.endEditing(true)

            // 3️⃣ 최신검색뷰 숨김
            self.recentView.isHidden = true

            // 4️⃣ 검색 실행
            self.performSearch(text)
        }
        
        
    }
    override func currentSearchText() -> String? {
        let text = searchBar.text
        print("🟦 currentSearchText =", text)
        return text
    }
    
    override func reloadRecentSearch() {
        let list = RecentSearchStorage.load()
        print("🟣 reloadRecentSearch =", list)
        recentView.update(list: list)
    }

    // 🔍 검색 실행 로직
    func performSearch(_ keyword: String) {
        print("🔍 검색 실행:", keyword)

        // TODO:
        // - API 호출
        // - 필터링
        // - 결과 화면 갱신
    }

  

}
