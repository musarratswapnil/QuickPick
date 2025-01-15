
import Foundation

struct Option: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var count: Int
    var name: String
}
