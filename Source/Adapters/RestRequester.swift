import PromiseKit
import Alamofire

struct QueryParameter : Equatable, CustomStringConvertible {

    init(name: String, value: String) {
        self.name = name
        self.values = [value]
    }

    init(name: String, value: [String]) {
        self.name = name
        self.values = value
    }

    init(name: String, values: String...) {
        self.name = name
        self.values = values
    }

    var name: String
    var values: [String]
    var value: String { return values.first ?? "" }

    public static func == (lhs: QueryParameter, rhs: QueryParameter) -> Bool {
        return lhs.name == rhs.name && lhs.values == rhs.values
    }

    public var description: String {
        return "QueryParameter: \(name)=\(values)"
    }
}

typealias Headers = [String: String]
typealias Body = [String: Any]

struct RestRequest : Equatable, CustomStringConvertible {

    init(url: String, method: String = "GET", parameters: [QueryParameter] = [], headers: Headers = [:], body: Body = [:]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }

    var url: String
    var method: String
    var parameters: [QueryParameter]
    var headers: Headers
    var body: Body

    public static func == (lhs: RestRequest, rhs: RestRequest) -> Bool {
        return lhs.url == rhs.url &&
            lhs.method == rhs.method &&
            lhs.parameters == rhs.parameters &&
            lhs.headers == rhs.headers
    }

    public var description: String {
        return "RestRequest: \(method) \(url) parameters=\(parameters) headers=\(headers) body=\(body)"
    }
}

struct RestResponse : Equatable, CustomStringConvertible {

    init(statusCode: Int, headers: Headers = [:], body: Body = [:]) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
    }

    var statusCode: Int
    var headers: Headers
    var body: Body

    public static func == (lhs: RestResponse, rhs: RestResponse) -> Bool {
        return lhs.statusCode == rhs.statusCode && lhs.headers == rhs.headers
    }

    public var description: String {
        return "RestResponse: statusCode=\(statusCode) headers=\(headers) body=\(body)"
    }

}

protocol RestRequesterProtocol {
    func request(_ request: RestRequest) -> Promise<RestResponse>
}

struct UrlAndBodyEncoding: ParameterEncoding {
    private let body: Body

    init(body: Body) {
        self.body = body
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var encodedUrlRequest = try URLEncoding.queryString.encode(try urlRequest.asURLRequest(), with: parameters)

        if (!body.isEmpty) {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            encodedUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            encodedUrlRequest.httpBody = data
        }

        return encodedUrlRequest
    }
}

class RestRequester: RestRequesterProtocol {

    static var shared: RestRequesterProtocol = RestRequester()

    func request(_ request: RestRequest) -> Promise<RestResponse> {

        let method = HTTPMethod(rawValue: request.method) ?? HTTPMethod.get
        let parameters = parametersToDictionary(parameters: request.parameters)

        return Alamofire
            .request(request.url, method: method, parameters: parameters, encoding: UrlAndBodyEncoding(request.body), headers: request.headers)
            .validate(contentType: ["application/json"])
            .responseJSON(with: .response)
            .then { value, response in
                let statusCode = response.response?.statusCode ?? 500
                let headers = self.headersToString(headers: response.response?.allHeaderFields ?? [:])
                let restResponse = RestResponse(statusCode: statusCode, headers: headers, body: value as? Body ?? [:])

                return Promise<RestResponse>(value: restResponse)
        }
    }

    private func parametersToDictionary(parameters: [QueryParameter]) -> [String:Any] {
        var result: [String: Any] = [:]
        for parameter in parameters {
            result[parameter.name] = parameter.values
        }
        return result
    }

    private func headersToString(headers: [AnyHashable: Any]) -> [String:String] {
        var result: Headers = [:]
        for (key, value) in headers {
            let key = (key as? String ?? "").lowercased()
            let value = value as? String ?? ""
            result[key] = value
        }
        return result
    }

}
