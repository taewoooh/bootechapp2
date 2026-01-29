import UIKit

final class PullToRefresh {

    private let refreshControl = UIRefreshControl()
    private let onRefresh: () -> Void

    init(
        tintColor: UIColor = .systemGray,
        onRefresh: @escaping () -> Void
    ) {
        self.onRefresh = onRefresh
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    // UITableView / UICollectionView / UIScrollView 전부 대응
    func attach(to scrollView: UIScrollView) {
        scrollView.refreshControl = refreshControl
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    @objc private func handleRefresh() {
        onRefresh()
    }
}
