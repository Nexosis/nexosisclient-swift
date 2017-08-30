import PromiseKit

public class ApiClient {

  let apiKey: String
  let baseUrl: String
  var requester: NexosisRequester

  init(apiKey: String, baseUrl: String = "https://ml.nexosis.com/v1") {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
    self.requester = NexosisRequester(apiKey: apiKey, baseUrl: baseUrl)
  }
}

public enum NexosisClientError: Error, Equatable {
  case generalError, parsingError
}

public func == (lhs: NexosisClientError, rhs: NexosisClientError) -> Bool {
  switch (lhs, rhs) {
    case (.generalError, .generalError): return true
    case (.parsingError, .parsingError): return true
    case (_, _): return false
  }
}
