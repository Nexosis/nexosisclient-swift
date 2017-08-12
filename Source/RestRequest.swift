import Alamofire

internal typealias RestSuccessHandler = (RestResponse) -> Void
internal typealias RestFailureHandler = (Error) -> Void

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

internal class RestRequester {

  func request(_ request: RestRequest, success: @escaping RestSuccessHandler, failure: @escaping RestFailureHandler) {
    Alamofire
      .request(request.url, method: request.method, headers: request.headers)
      .validate(contentType: ["application/json"])
      .responseJSON { self.handleResponse($0, success: success, failure: failure) }
  }

  private func handleResponse(_ response: DataResponse<Any>, success: @escaping RestSuccessHandler, failure: RestFailureHandler) {
    switch response.result {
      case .success:
        self.handleSuccess(response, success: success)
      case .failure(let error):
        self.handleFailure(error, failure: failure)
    }
  }

  private func handleSuccess(_ response: DataResponse<Any>, success: RestSuccessHandler) {
    let statusCode = response.response?.statusCode ?? 500
    let headers = headersToString(headers: response.response?.allHeaderFields ?? [:])
    let body = response.result.value ?? [:]

    success(RestResponse(statusCode: statusCode, headers: headers, body: body))
  }

  private func handleFailure(_ error: Error, failure: RestFailureHandler) {
    failure(error)
  }

  private func headersToString(headers: [AnyHashable: Any]) -> [String:String] {
    var result: [String: String] = [:]
    for (key, value) in headers {
      result[key as? String ?? ""] = value as? String ?? ""
    }
    return result
  }

}
