import Foundation

final class FileReader {
    static func getFileData(forFileName fileName: String, fileExtension: String) -> Data? {
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            if let data = try? Data(contentsOf: fileUrl, options: .mappedIfSafe) {
                return data
            }
        }
        return nil
    }
}
