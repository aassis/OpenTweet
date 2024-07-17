import Foundation
import Combine

struct TimelineProviderMock: NetworkProviderProtocol {
    func networkResponse(for request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = FileReader.getFileData(forFileName: "timeline", fileExtension: "json")!
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
