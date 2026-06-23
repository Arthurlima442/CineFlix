//
//  Util.swift
//  Movie
//
//  Created by Arthur Lima on 04/08/2025.
//

import Foundation

final class Util {
    private init() {}

    /// Converte "yyyy-MM-dd" (API) para "dd/MM/yyyy" (exibição).
    /// Retorna "-" se a string for inválida.
    static func formatReleaseDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "-" }

        let apiFormatter = DateFormatter()
        apiFormatter.locale = Locale(identifier: "en_US_POSIX")
        apiFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        apiFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = apiFormatter.date(from: dateString) else { return "-" }

        let displayFormatter = DateFormatter()
        displayFormatter.locale = .current
        displayFormatter.timeZone = .current
        displayFormatter.dateFormat = "dd/MM/yyyy"

        return displayFormatter.string(from: date)
    }
}

extension Array {
    /// Safe subscript to avoid out of bounds access
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
