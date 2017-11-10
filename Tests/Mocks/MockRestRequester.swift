import Moxie
import PromiseKit

@testable import NexosisApiClient

class MockRestRequester: RestRequesterProtocol, Mock {
    var moxie = Moxie()
    
    func request(_ request: RestRequest) -> Promise<RestResponse> {
        record(function: "request", wasCalledWith: [request])
        return value(forFunction: "request") ?? Promise(value: RestResponse(statusCode: 999))
    }
}
