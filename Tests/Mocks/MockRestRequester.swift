import Moxie
import PromiseKit

@testable import NexosisApiClientiOS

class MockRestRequester: RestRequester, Mock {
    var moxie = Moxie()
    
    override func request(_ request: RestRequest) -> Promise<RestResponse> {
        record(function: "request", wasCalledWith: [request])
        return value(forFunction: "request") ?? Promise(value: RestResponse(statusCode: 999))
    }
}
