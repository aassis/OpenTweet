import Foundation
import Combine

protocol NetworkProviderProtocol {
    typealias NetworkResponse = URLSession.DataTaskPublisher.Output
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError>
}

extension URLSession: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

struct NetworkProvider: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}

struct TimelineProviderMock: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = FileReader.getFileData(forFileName: "timeline", fileExtension: "json")!
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
