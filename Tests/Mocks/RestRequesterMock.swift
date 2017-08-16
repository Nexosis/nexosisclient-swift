import Moxie
import PromiseKit

class MockRestRequester: Mock, RestRequester {
  var moxie = Moxie()

  func request(_ request: RestRequest) -> Promise<RestResponse> {
    record(function: "request", wasCalledWith: [request])
    return value(forFunction: "request", whenCalledWith: [request])!
  }

}
