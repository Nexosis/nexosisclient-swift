import PromiseKit
import Alamofire

internal struct RestRequest {

  init(url: String, method: String = "GET", headers: [String : String] = [:], body: [String : Any] = [:]) {
    self.url = url
    self.method = method
    self.headers = headers
    self.body = body
  }

  var url: String
  var method: String
  var headers: [String : String]
  var body: [String : Any]
}

internal struct RestResponse {

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

    return Alamofire
      .request(request.url, method: method, headers: request.headers)
      .validate(contentType: ["application/json"])
      .responseJSON(with: .response)
      .then { value, response in
        let statusCode = response.response?.statusCode ?? 500
        let headers = self.headersToString(headers: response.response?.allHeaderFields ?? [:])
        let restResponse = RestResponse(statusCode: statusCode, headers: headers, body: value as? [String: Any] ?? [:])

        return Promise<RestResponse>(value: restResponse)
      }
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
