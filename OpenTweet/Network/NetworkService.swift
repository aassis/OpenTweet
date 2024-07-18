import Foundation
import Combine

struct NetworkService<NetworkEndpointType: NetworkEndpoint> {
    var provider: NetworkProviderProtocol

    init(provider: NetworkProviderProtocol) {
        self.provider = provider
    }

    func request<T: Decodable>(_ endpoint: NetworkEndpointType, type: T.Type) -> AnyPublisher<T, Error> {
        let url = endpoint.baseURL.appending(path: endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod

        return provider.networkResponse(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
