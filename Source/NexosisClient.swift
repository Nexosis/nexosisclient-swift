import PromiseKit
import Alamofire

public class NexosisClient {

  private let apiKey: String
  private let baseUrl: String

  init(apiKey: String, baseUrl: String = "https://ml.nexosis.com/v1") {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
  }

  func fetchAccountBalance() -> Promise<AccountBalance> {

    let requester = RestRequester()
    let url = "\(baseUrl)/data?page=0&pageSize=1"
    let headers = [ "api-key" : apiKey ]
    let request = RestRequest(url: url, method: .get, headers: headers, body: [:])

    return requester
      .request(request)
      .then { response in

        if let accountBalanceHeader = response.headers["Nexosis-Account-Balance"] {
          let parts = accountBalanceHeader.components(separatedBy: " ")

          let result = AccountBalance(
            amount: Double(parts.first ?? "") ?? 0.0,
            currency: parts.last ?? ""
          )

          return Promise<AccountBalance>(value: result)
        }

        throw NexosisClientError.parsingError

      }
  }
}

public enum NexosisClientError: Error {
  case parsingError
}

public struct AccountBalance {
  var amount: Double
  var currency: String
}
