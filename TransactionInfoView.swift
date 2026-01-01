import UIKit

// MARK: - Model
struct TransactionInfoData {
    let dateString: String
    let totalCount: Int
    let highPriceCount: Int
    let highPriceRate: Double
    let recoveryRate: Double
}

// MARK: - View
class TransactionInfoView: UIView {

    // MARK: UI Components

    private let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 14)
        lb.textColor = .black
        lb.setContentHuggingPriority(.required, for: .horizontal)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        lb.textColor = .darkGray
        lb.numberOfLines = 1
        lb.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let extraLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 13)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let extraLabel2: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 13)
        lb.textColor = .gray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // MARK: StackViews

    /// ● + 날짜 + 메인 정보
    private lazy var topRow: UIStackView = {
        let st = UIStackView(arrangedSubviews: [
            dotView,
            dateLabel,
            infoLabel
        ])
        st.axis = .horizontal
        st.spacing = 6
        st.alignment = .center
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()

    /// 들여쓰기 + 보조 정보
    private lazy var bottomRow: UIStackView = {
        let indent = UIView()
        indent.translatesAutoresizingMaskIntoConstraints = false
        indent.widthAnchor.constraint(equalToConstant: 22).isActive = true
        // dot(8) + spacing 느낌용 들여쓰기

        let st = UIStackView(arrangedSubviews: [
            indent,
            extraLabel,
            extraLabel2
        ])
        st.axis = .horizontal
        st.spacing = 10
        st.alignment = .trailing
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()

    /// 전체 세로 스택
    private lazy var allStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [
            topRow,
            bottomRow
        ])
        st.axis = .vertical
        st.spacing = 6
        st.alignment = .leading
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Layout

    private func setupUI() {
        addSubview(allStack)

        NSLayoutConstraint.activate([
            allStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            allStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 8)
        ])

    }

    // MARK: Data Binding

    func configure(with data: TransactionInfoData) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"

        dotView.isHidden = (data.dateString != fmt.string(from: Date()))
        dateLabel.text = data.dateString

        infoLabel.text =
        "전국 / 등록건수 : \(data.totalCount)건 / 신고가 : \(data.highPriceCount)건 ▼"

        extraLabel.text =
        "( 신고가율 : \(String(format: "%.1f", data.highPriceRate))% )"

        extraLabel2.text =
        "( 최고가대비 회복률 : \(String(format: "%.1f", data.recoveryRate))% )"

        isHidden = false
    }

    func configureEmpty() {
        isHidden = true
    }
}
