
import Foundation



final class RecentSearchStorage {

    private static let key = "recent_search_list"

    // 저장
    static func save(_ text: String) {
        var list = load()

        // 중복 제거
        list.removeAll { $0 == text }

        // 최신 → 맨 위
        list.insert(text, at: 0)

        UserDefaults.standard.set(list, forKey: key)
        
        print("✅ [SAVE] recent_search_list =", list)

        
    }

    // 불러오기
    static func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
