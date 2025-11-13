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
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let listsetUp: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.clockwise") // 새로고침
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
        backgroundColor = UIColor(white: 0.95, alpha: 1)
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
}



// 🔹 2. ViewController는 이렇게 그대로 두면 됨
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let searchBar = SearchBarView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

