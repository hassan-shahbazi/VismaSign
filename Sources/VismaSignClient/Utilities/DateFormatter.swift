import Foundation

extension Date {
    static var RFC2822DateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current

        return formatter
    }

    var RFC2822String: String? {
        return Date.RFC2822DateFormatter.string(from: self)
    }
}