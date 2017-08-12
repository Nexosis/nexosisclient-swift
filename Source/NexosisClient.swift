import Alamofire
import Foundation

public class NexosisClient {

  private let apiKey: String
  private let baseUrl: String

  init(apiKey: String, baseUrl: String = "https://ml.nexosis.com/v1") {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
  }

  func fetchAccountBalance(completion: @escaping (AccountBalance) -> Void) {

    let url = "\(baseUrl)/data?page=0&pageSize=1"
    let headers: HTTPHeaders = [ "api-key": apiKey ]

    Alamofire
      .request(url, method: HTTPMethod.get, headers: headers)
      .responseJSON { response in

        var result = AccountBalance(amount: 0.0, currency: "")

          if let accountBalanceHeader = response.response?.allHeaderFields["Nexosis-Account-Balance"] as? String {

          let parts = accountBalanceHeader.components(separatedBy: " ")
          result.amount = Double(parts.first ?? "") ?? 0.0
          result.currency = parts.last ?? ""
        }

        completion(result)
      }
  }

}

public struct AccountBalance {
  var amount: Double
  var currency: String
}
