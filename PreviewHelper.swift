#if canImport(SwiftUI) && DEBUG
import SwiftUI

// 🔹 모든 UIView / UIViewController 프리뷰를 위한 공통 헬퍼
struct CommonPreview {

    // UIView용 프리뷰
    static func make<T: UIView>(_ type: T.Type,
                                layout: PreviewLayout = .sizeThatFits,
                                builder: (() -> T)? = nil) -> some View {
        UIViewPreview {
            builder?() ?? T(frame: .zero)
        }
        .previewLayout(layout)
        .padding()
    }

    // UIViewController용 프리뷰
    static func makeVC<T: UIViewController>(_ type: T.Type,
                                            layout: PreviewLayout = .device,
                                            builder: (() -> T)? = nil) -> some View {
        UIViewControllerPreview {
            builder?() ?? T()
        }
        .previewLayout(layout)
    }
}

// 🔹 UIView → SwiftUI 변환용 브리지
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    init(_ builder: @escaping () -> View) { view = builder() }
    func makeUIView(context: Context) -> View { view }
    func updateUIView(_ uiView: View, context: Context) {}
}

// 🔹 UIViewController → SwiftUI 변환용 브리지
struct UIViewControllerPreview<VC: UIViewController>: UIViewControllerRepresentable {
    let viewController: VC
    init(_ builder: @escaping () -> VC) { viewController = builder() }
    func makeUIViewController(context: Context) -> VC { viewController }
    func updateUIViewController(_ uiViewController: VC, context: Context) {}
}
#endif
