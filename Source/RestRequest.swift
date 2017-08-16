import PromiseKit
import Alamofire

internal struct RestRequest {
  var url: String
  var method: HTTPMethod
  var headers: [String : String]
  var body: [String : Any]
}

internal struct RestResponse {
  var statusCode: Int
  var headers: [String : String]
  var body: Any
}

internal protocol RestRequester {
  func request(_ request: RestRequest) -> Promise<RestResponse>
}

internal class SimpleRestRequester: RestRequester {

  static let shared = SimpleRestRequester()

  func request(_ request: RestRequest) -> Promise<RestResponse> {

    return Alamofire
      .request(request.url, method: request.method, headers: request.headers)
      .validate(contentType: ["application/json"])
      .responseJSON(with: .response)
      .then { value, response in
        let statusCode = response.response?.statusCode ?? 500
        let headers = self.headersToString(headers: response.response?.allHeaderFields ?? [:])
        let restResponse = RestResponse(statusCode: statusCode, headers: headers, body: value)

        return Promise<RestResponse>(value: restResponse)
      }
  }

  private func headersToString(headers: [AnyHashable: Any]) -> [String:String] {
    var result: [String: String] = [:]
    for (key, value) in headers {
      result[key as? String ?? ""] = value as? String ?? ""
    }
    return result
  }

}
