import PromiseKit

@testable import NexosisApiClientiOS

class MockRestRequester: RestRequester {

  private var stubbedResponse: Promise<RestResponse>!

  var requestParameter: RestRequest?
  var requestInvoked: Bool = false

  func stubRequest(response: RestResponse) {
    stubbedResponse = Promise<RestResponse>(value: response)
  }

  override func request(_ request: RestRequest) -> Promise<RestResponse> {
    requestInvoked = true
    requestParameter = request
    return stubbedResponse;
  }

}
