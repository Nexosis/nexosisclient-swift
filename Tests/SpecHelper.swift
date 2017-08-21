@testable import NexosisApiClientiOS

struct SpecHelper {

  static let ApiKey = "BOGUS_API_KEY"

  static let BaseUrl = "http://bogus.nexosis.com"
  static func BaseUrl(tail: String) -> String {
    return "\(self.BaseUrl)\(tail)"
  }

  static func Client() -> NexosisClient {
    return NexosisClient(apiKey: ApiKey, baseUrl: BaseUrl)
  }

  static func Client(overrideUrl: String) -> NexosisClient {
    return NexosisClient(apiKey: ApiKey, baseUrl: overrideUrl)
  }

}
