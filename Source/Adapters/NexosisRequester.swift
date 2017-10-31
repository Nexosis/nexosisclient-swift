import PromiseKit

protocol NexosisRequesterProtocol {
    func get(urlPath: String, parameters: [QueryParameter]) -> Promise<RestResponse>
    func delete(urlPath: String, parameters: [QueryParameter]) -> Promise<RestResponse>
    func put(urlPath: String, body: Body) -> Promise<RestResponse>
    func post(urlPath: String, body: Body) -> Promise<RestResponse>
}

class NexosisRequester: NexosisRequesterProtocol {
    
    private let apiClientId = "Swift/v1.0.0"
    private let apiKey: String
    private let baseUrl: String
    
    init(apiKey: String, baseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    func get(urlPath: String, parameters: [QueryParameter] = []) -> Promise<RestResponse> {
        return makeRequest(urlPath: urlPath, method: "GET", parameters: parameters)
    }

    func delete(urlPath: String, parameters: [QueryParameter] = []) -> Promise<RestResponse> {
        return makeRequest(urlPath: urlPath, method: "DELETE", parameters: parameters)
    }
    
    func put(urlPath: String, body: Body) -> Promise<RestResponse> {
        return makeRequest(urlPath: urlPath, method: "PUT", body: body)
    }

    func post(urlPath: String, body: Body) -> Promise<RestResponse> {
        return makeRequest(urlPath: urlPath, method: "POST", body: body)
    }

    private func makeRequest(urlPath: String, method: String, parameters: [QueryParameter] = [], body: Body = [:]) -> Promise<RestResponse> {
        let url = "\(baseUrl)\(urlPath)"
        let headers = ["api-key" : apiKey, "api-client-id" : apiClientId]
        let request = RestRequest(url: url, method: method, parameters: parameters, headers: headers, body: body)
        
        return RestRequester.shared.request(request)
    }
}
