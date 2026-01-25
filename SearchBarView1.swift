import UIKit

class SearchBarView1: UIView , UITextFieldDelegate{
    
    var onClearTapped: ((Bool) -> Void)?
    
    var onTextChanged: ((String) -> Void)?   // 🔥 텍스트 변경 콜백 추가
    // 🔥 텍스트필드 터치(포커스) 콜백
    var onBeginEditing: (() -> Void)?
    
    
    // 🔹 외부에서 주입받는 최신검색뷰
    weak var recentSearchView: UIView?



    // 🔥 외부에서 검색어 가져오기용
    var text: String {
        return textField.text ?? ""
    }
    // 🔥 외부에서 검색어 세팅용
    // - 최신검색 아이템 클릭 시 호출됨
    // - 프로그램적으로 텍스트를 넣어도
    // 사용자 입력과 동일하게 처리하기 위함
    func setText(_ text: String) {
    textField.text = text


    // 🔥 중요
    // textField.text를 코드로 바꾸면
    // editingChanged 이벤트가 자동으로 발생하지 않음
    // 그래서 수동으로 호출해줘야 함
    onTextChanged?(text)
    }
    
    // 🔑 키보드가 올라와 있는지 여부
    var isKeyboardVisible: Bool {
        return textField.isFirstResponder
    }
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass") // 돋보기
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.textColor = AppColors.edittextcolor1   // ← 텍스트 색상 설정
        tf.font = UIFont.systemFont(ofSize: Dimens.Font.FontSmall) // ← 텍스트 사이즈 클래스에서 불러오기
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private func setupEvents() {
        // 🔥 이게 없으면 절대 안 불림
        textField.addTarget(
            self,
            action: #selector(beginEditing),
            for: .editingDidBegin
        )
    }
    
    @objc private func beginEditing() {
        print("🔥 textField touched")   // ← 디버그용
        onBeginEditing?()
    }
    
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }
    
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
        setupEvents()   // ✅ 이거 추가

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textField.delegate = self
        setupUI()
        setupEvents()   // ✅ 이거 추가

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
        
        let keyboardVisible = textField.isFirstResponder
        
        onTextChanged?("")
        onClearTapped?(keyboardVisible)
    }
    
    @objc private func textDidChange() {
        let text = textField.text ?? ""
        clearButton.isHidden = text.isEmpty
        onTextChanged?(text)

        // 🔑 텍스트가 비어있는지 (nil, 공백 포함)
        let isTextEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        // 🔥 최신검색뷰 활성 / 비활성 컨셉
        if isKeyboardVisible && isTextEmpty {
            recentSearchView?.isHidden = false
        } else {
            recentSearchView?.isHidden = true
        }
    }

    
} //상단 검색 툴바 (법정동,아파
