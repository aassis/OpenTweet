import Foundation

struct Timeline: Codable {
    let timeline: [Tweet]

    enum CodingKeys: String, CodingKey {
        case timeline
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              let timeline = try? container.decode([Tweet].self, forKey: .timeline) else {
            throw NSError(domain: "com.opentable.OpenTweet", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode model"])
        }
        self.timeline = timeline
    }
}
