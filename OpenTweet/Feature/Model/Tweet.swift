import Foundation

struct Tweet: Codable {

    let id: String
    let author: String
    let content: String
    let avatar: String?
    let date: String
    let inReplyTo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case avatar
        case date
        case inReplyTo
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
            let id = try? container.decode(String.self, forKey: .id),
              let author = try? container.decode(String.self, forKey: .author),
              let content = try? container.decode(String.self, forKey: .content),
              let date = try? container.decode(String.self, forKey: .date) else {
            throw NSError(domain: "com.opentable.OpenTweet", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode model"])
        }

        self.id = id
        self.author = author
        self.content = content
        self.avatar = try? container.decode(String.self, forKey: .avatar)
        self.date = date
        self.inReplyTo = try? container.decode(String.self, forKey: .inReplyTo)
    }
}
