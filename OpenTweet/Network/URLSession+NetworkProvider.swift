import Foundation
import Combine

extension URLSession: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}
