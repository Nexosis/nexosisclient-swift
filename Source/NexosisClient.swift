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

    let requester = RestRequester()
    let url = "\(baseUrl)/data?page=0&pageSize=1"
    let headers = [ "api-key": apiKey ]
    let request = RestRequest(url: url, method: .get, headers: headers, body: [:])

    requester.request( request,
      success: { response in
        var result = AccountBalance(amount: 0.0, currency: "")

        if let accountBalanceHeader = response.headers["Nexosis-Account-Balance"] {

          let parts = accountBalanceHeader.components(separatedBy: " ")
          result.amount = Double(parts.first ?? "") ?? 0.0
          result.currency = parts.last ?? ""
        }
        
        completion(result)
      },
      failure: { error in
      }
    )
  }
}

public struct AccountBalance {
  var amount: Double
  var currency: String
}
