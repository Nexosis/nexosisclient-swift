import Moxie
import PromiseKit

@testable import NexosisApiClientiOS

class MockNexosisRequester: NexosisRequesterProtocol, Mock {
    var moxie = Moxie()
    
    func get(urlPath: String, parameters: [QueryParameter]) -> Promise<RestResponse> {
        record(function: "get", wasCalledWith: [urlPath, parameters])
        return value(forFunction: "get") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }
    
    func delete(urlPath: String, parameters: [QueryParameter]) -> Promise<RestResponse> {
        record(function: "delete", wasCalledWith: [urlPath, parameters])
        return value(forFunction: "delete") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }
}
