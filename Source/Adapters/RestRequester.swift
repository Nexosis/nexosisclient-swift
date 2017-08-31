import PromiseKit
import Alamofire

internal class QueryParameter : Equatable, CustomStringConvertible {

  init(name: String, value: String) {
    self.name = name
    self.values = [value]
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

internal class RestRequest {

  init(url: String, method: String = "GET", parameters: [QueryParameter] = [], headers: [String : String] = [:], body: [String : Any] = [:]) {
    self.url = url
    self.method = method
    self.parameters = parameters
    self.headers = headers
    self.body = body
  }

  var url: String
  var method: String
  var parameters: [QueryParameter]
  var headers: [String : String]
  var body: [String : Any]
}

internal class RestResponse {

  init(statusCode: Int, headers: [String : String] = [:], body: [String : Any] = [:]) {
    self.statusCode = statusCode
    self.headers = headers
    self.body = body
  }

  var statusCode: Int
  var headers: [String : String]
  var body: [String: Any]
}

internal class RestRequester {

  static var shared: RestRequester = RestRequester()

  func request(_ request: RestRequest) -> Promise<RestResponse> {

    let method = HTTPMethod(rawValue: request.method) ?? HTTPMethod.get
    let parameters = parametersToDictionary(parameters: request.parameters)

    return Alamofire
      .request(request.url, method: method, parameters: parameters, headers: request.headers)
      .validate(contentType: ["application/json"])
      .responseJSON(with: .response)
      .then { value, response in
        let statusCode = response.response?.statusCode ?? 500
        let headers = self.headersToString(headers: response.response?.allHeaderFields ?? [:])
        let restResponse = RestResponse(statusCode: statusCode, headers: headers, body: value as? [String: Any] ?? [:])

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
    var result: [String: String] = [:]
    for (key, value) in headers {
      let key = (key as? String ?? "").lowercased()
      let value = value as? String ?? ""
      result[key] = value
    }
    return result
  }

}
