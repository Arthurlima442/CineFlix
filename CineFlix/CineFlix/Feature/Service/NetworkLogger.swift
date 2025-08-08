//
//  NetworkLogger.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

class NetworkLogger {

  static func log(request: URLRequest,
                  response: URLResponse?,
                  data: Data?,
                  error: Error?,
                  verbose: Bool = true,
                  startTime: Date = Date()) {

    let requestID = UUID().uuidString
    logLine("------------ 🚀 START OF REQUEST 🚀 ------------")
    logLine("Request ID: \(requestID)")

    logLine("Timestamp: \(formatterDate())")
    let elapsedTime = Date().timeIntervalSince(startTime)
    logLine("Request Duration: \(String(format: "%.2f", elapsedTime)) seconds")

    if let url = request.url {
      logLine("Request URL: \(url.absoluteString)")

      if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
         let queryItems = components.queryItems,
         !queryItems.isEmpty {
        logLine("Query Items: \(queryItems)")
      }
    }

    if let httpMethod = request.httpMethod {
      logLine("HTTP Method: \(httpMethod)")
    }

    if verbose, let headers = request.allHTTPHeaderFields {
      logLine("Request Headers: \(headers)")
    }

    if verbose,
       let body = request.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
      logLine("Body Request: \(bodyString)")
    }

    if let httpResponse = response as? HTTPURLResponse {
      let statusIcon = (200...299).contains(httpResponse.statusCode) ? "✅" : "❌"
      logLine("Status Code: \(httpResponse.statusCode) \(statusIcon)")
    } else if let error {
      logLine("🔴 Error: \(error.localizedDescription)")
      logDetailedError(error)
    } else {
      logLine("🔴 Error: No Response and no Error")
    }

    if let data {
      if let jsonString = parseJSON(data: data) {
        logLine("JSON Response: ⬇️\n\(jsonString)")
      } else if let rawResponse = String(data: data, encoding: .utf8) {
        logLine("Raw Response: ⬇️\n\(rawResponse)")
      } else {
        logLine("🔴 Error: Could not parse response data")
      }
    } else {
      logLine("🔴 Error: No Data")
    }

    logLine("------------ 🏁 END OF REQUEST 🏁 ------------")
  }

  static func logError(error: Error, url: String) {
    logLine("------------ ❌ START OF ERROR ❌ ------------")
    logLine("Timestamp: \(formatterDate())")
    logLine("Failed URL: \(url)")
    logLine("Error: \(error.localizedDescription)")
    logLine("------------ ❌ END OF ERROR ❌ ------------")
  }

  private static func logDetailedError(_ error: Error) {
    if let urlError = error as? URLError {
      logLine("🔎 URLError Code: \(urlError.code)")
    } else {
      logLine("🔎 Error Type: \(type(of: error))")
    }
  }

  private static func parseJSON(data: Data) -> String? {
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
      return String(data: jsonData, encoding: .utf8)
    } catch {
      logLine("Failed to serialize JSON: \(error.localizedDescription)")
      return nil
    }
  }

  private static func formatterDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale(identifier: "pt_BR")
    return formatter.string(from: Date())
  }

  private static func logLine(_ value: Any) {
    print(value)
  }
}
