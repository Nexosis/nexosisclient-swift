import PromiseKit

@testable import NexosisApiClientiOS

class MockNexosisRequester: NexosisRequester {

  private var stubbedGetResponse: Promise<RestResponse>!

  init() {
    super.init(apiKey: "", baseUrl: "")
  }

  var urlPathParameter: String?
  var parametersParameter: [String : String]?

  func stubGet(response: RestResponse) {
    stubbedGetResponse = Promise<RestResponse>(value: response)
  }

  override func get(urlPath: String, parameters: [String : String] = [:]) -> Promise<RestResponse> {
    urlPathParameter = urlPath
    parametersParameter = parameters
    return stubbedGetResponse
  }
  
}
