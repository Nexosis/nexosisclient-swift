import PromiseKit

public class NexosisRequester {

  private let apiClientId = "Swift/v1.0.0"
  private let apiKey: String
  private let baseUrl: String

  init(apiKey: String, baseUrl: String) {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
  }

  func get(urlPath: String, parameters: [String : String] = [:]) -> Promise<RestResponse> {
    return makeRequest(urlPath: urlPath, method: "GET", parameters: parameters)
  }

  private func makeRequest(urlPath: String, method: String, parameters: [String : String]) -> Promise<RestResponse> {
    let url = "\(baseUrl)\(urlPath)"
    let headers = ["api-key" : apiKey, "api-client-id" : apiClientId]
    let request = RestRequest(url: url, method: "GET", parameters: parameters, headers: headers)

    return RestRequester.shared.request(request)
  }

}
