import Foundation

enum TimelineEndpoint: NetworkEndpoint {
    case getTimeline

    var baseURL: URL {
        /// We're populating this with something just as an example, since we'll be stubbing our response
        return URL(string: "https://www.opentweet.com/api")!
    }

    var path: String {
        switch self {
        case .getTimeline:
            return "/timeline"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTimeline:
            return .get
        }
    }
}
