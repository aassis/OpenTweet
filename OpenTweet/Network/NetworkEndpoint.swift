import Foundation

enum HTTPMethod: String {
    /// We're only adding the GET method cause it's the only one we'll use in this sample. Other methods can be added as needed
    case get = "GET"
}

protocol NetworkEndpoint {
    /// Just like with the HTTPMethod, we're only adding the basics, other relevant properties for an HTTP request like headers and parameters can be added as needed
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension NetworkEndpoint {
    var httpMethod: String {
        method.rawValue
    }
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}
