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

    func put(urlPath: String, body: Body) -> Promise<RestResponse> {
        record(function: "put", wasCalledWith: [urlPath, body])
        return value(forFunction: "put") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }

    func post(urlPath: String, body: Body) -> Promise<RestResponse> {
        record(function: "post", wasCalledWith: [urlPath, body])
        return value(forFunction: "post") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }
}
