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

