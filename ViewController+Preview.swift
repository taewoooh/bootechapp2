#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        CommonPreview.makeVC(ViewController.self)
    }
}
#endif
