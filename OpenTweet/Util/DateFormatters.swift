import Foundation

extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
}

extension Date {
    static let staticISO8601FormatStyle = Date.ISO8601FormatStyle()
}
