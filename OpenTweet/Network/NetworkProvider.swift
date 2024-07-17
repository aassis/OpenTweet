import Foundation
import Combine

protocol NetworkProviderProtocol {
    typealias NetworkResponse = URLSession.DataTaskPublisher.Output
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError>
}

extension URLSession: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}

struct NetworkProvider: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return URLSession.shared.networkResponse(for: request)
    }
}
