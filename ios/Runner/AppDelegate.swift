import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let mapsApiKey = loadEnvValue(for: "MAPS_API_KEY") {
      GMSServices.provideAPIKey(mapsApiKey)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func loadEnvValue(for key: String) -> String? {
    let candidatePaths: [String?] = [
      Bundle.main.path(forResource: ".env", ofType: nil, inDirectory: "flutter_assets"),
      Bundle.main.path(forResource: ".env", ofType: nil)
    ]

    guard let envPath = candidatePaths.compactMap({ $0 }).first,
          let raw = try? String(contentsOfFile: envPath, encoding: .utf8) else {
      return nil
    }

    let lines = raw.components(separatedBy: .newlines)
    for line in lines {
      let trimmed = line.trimmingCharacters(in: .whitespaces)
      if trimmed.isEmpty || trimmed.hasPrefix("#") {
        continue
      }

      let parts = trimmed.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
      if parts.count != 2 {
        continue
      }

      let currentKey = parts[0].trimmingCharacters(in: .whitespaces)
      var value = parts[1].trimmingCharacters(in: .whitespaces)

      if (value.hasPrefix("\"") && value.hasSuffix("\"")) || (value.hasPrefix("'") && value.hasSuffix("'")) {
        value = String(value.dropFirst().dropLast())
      }

      if currentKey == key {
        return value
      }
    }

    return nil
  }
}
