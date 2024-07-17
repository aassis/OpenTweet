import Foundation
import Combine

extension URLSession {
    /// Defining this type so I can detect if the image was already cached in order to decide if an animation will be used to display the image or not
    typealias CachedImageResult = (data: Data, cached: Bool)

    func loadImage(forUrlString urlString: String) -> AnyPublisher<CachedImageResult, URLError>? {
        if let url = URL(string: urlString) {
            /// Setting the cache policy for images so we don't make a new request every time a cell is displayed
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

            /// We're gonna check if this request is already cached, and return the data appropriately
            if let response = URLCache.shared.cachedResponse(for: urlRequest) {
                return Just(CachedImageResult(data: response.data, cached: true))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            }

            /// Dispatching the request to a background thread, whoever uses this convenience function should declare the signal to be received on the main thread to display the image immediately.
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .compactMap({ response in
                    CachedImageResult(data: response.data, cached: false)
                })
                .eraseToAnyPublisher()
        }
        return nil
    }
}
