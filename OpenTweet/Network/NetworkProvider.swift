import Foundation
import Combine

protocol NetworkProviderProtocol {
    typealias NetworkResponse = URLSession.DataTaskPublisher.Output
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError>
}

struct NetworkProvider: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return URLSession.shared.networkResponse(for: request)
    }
}
