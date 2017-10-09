import PromiseKit
import Moxie

@testable import NexosisApiClientiOS

class MockNexosisRequester: NexosisRequester, Mock {
    var moxie = Moxie()
    
    init() {
        super.init(apiKey: "", baseUrl: "")
    }
    
    override func get(urlPath: String, parameters: [QueryParameter] = []) -> Promise<RestResponse> {
        record(function: "get", wasCalledWith: [urlPath, parameters])
        return value(forFunction: "get") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }
    
    override func delete(urlPath: String, parameters: [QueryParameter] = []) -> Promise<RestResponse> {
        record(function: "delete", wasCalledWith: [urlPath, parameters])
        return value(forFunction: "delete") ?? Promise<RestResponse>(value: RestResponse(statusCode: 999))
    }
}
