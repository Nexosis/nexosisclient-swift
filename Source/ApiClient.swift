import PromiseKit

public class ApiClient {

  let apiClientId = "Swift/v1.0.0"
  let apiKey: String
  let baseUrl: String

  init(apiKey: String, baseUrl: String = "https://ml.nexosis.com/v1") {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
  }

  func makeGetRequest(urlPath: String, parameters: [String : String]) -> Promise<RestResponse> {

    let url = "\(baseUrl)\(urlPath)"
    let headers = ["api-key" : apiKey, "api-client-id" : apiClientId]
    let request = RestRequest(url: url, method: "GET", parameters: parameters, headers: headers)

    return RestRequester.shared.request(request)
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
