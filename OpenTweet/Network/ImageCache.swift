import Foundation
import UIKit

/// Defining this type so I can detect if the image was already cached in order to decide if an animation will be used to display the image or not
typealias CachedImageResult = (image: UIImage, cached: Bool)

protocol ImageCacheProtocol {
    func loadImageFor(urlString: String,
                   completionHandler: @escaping ((_ result: CachedImageResult?, _ error: Error?) -> ())) -> URLSessionDataTask?
}

final class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func loadImageFor(urlString: String,
                   completionHandler: @escaping ((_ result: CachedImageResult?, _ error: Error?) -> ())) -> URLSessionDataTask? {
        /// Check if image is in cache and return it
        if let imageCache = self.cache.object(forKey: urlString as NSString) {
            let result = CachedImageResult(image: imageCache, cached: true)
            completionHandler(result, nil)
            return nil
        }

        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: urlRequest) { (data: Data?,
                                                                       response: URLResponse?,
                                                                       error: Error?) in
                           if let err = error {
                               completionHandler(nil, err)
                           } else if let imageData = data, let image = UIImage(data: imageData) {
                               self.cache.setObject(image, forKey: urlString as NSString)
                               let result = CachedImageResult(image: image, cached: false)
                               completionHandler(result, nil)
                           }
                       }

            /// Dispatching the request to a background thread.
            DispatchQueue.global(qos: .background).async {
                task.resume()
            }

            return task
        }

        return nil
    }
}

private var associateKey: Void?
extension UIImageView {
    /// We're gonna relay the responsibility of calling for image load requests to the UIImageView, and in order to track the last request for reusability purposes, we'll store an URLSessionDataTask as an associatedtype in this extension, so we can cancel it as required.
    var lastTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &associateKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &associateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func loadImageFor(urlString: String?) {
        lastTask?.cancel()
        lastTask = nil

        if let urlString = urlString {
            self.lastTask = ImageCache.shared.loadImageFor(urlString: urlString) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        self.alpha = 0.0
                        self.image = result.image
                        UIView.animate(withDuration: result.cached ? 0.0 : 0.2) {
                            self.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
}
