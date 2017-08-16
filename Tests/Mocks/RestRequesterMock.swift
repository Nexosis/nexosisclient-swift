import PromiseKit

@testable import NexosisApiClientiOS

class MockRestRequester: RestRequester {

  private var stubbedResponse: Promise<RestResponse>!

  var requestParameter: RestRequest?

  func stubRequest(response: RestResponse) {
    stubbedResponse = Promise<RestResponse>(value: response)
  }

  func request(_ request: RestRequest) -> Promise<RestResponse> {
    requestParameter = request
    return stubbedResponse;
  }

}
