import PromiseKit
import Alamofire

public class ApiClient {

  let apiKey: String
  let baseUrl: String

  init(apiKey: String, baseUrl: String = "https://ml.nexosis.com/v1") {
    self.apiKey = apiKey
    self.baseUrl = baseUrl
  }

}

public class NexosisClient: ApiClient {

  private var datasetClient: DatasetClient?

  func fetchAccountBalance() -> Promise<AccountBalance> {

    let url = "\(baseUrl)/data?page=0&pageSize=1"
    let headers = [ "api-key" : apiKey ]
    let request = RestRequest(url: url, method: "GET", headers: headers, body: [:])

    return RestRequester.shared
      .request(request)
      .then { response in

        if let accountBalanceHeader = response.headers["nexosis-account-balance"] {
          return Promise<AccountBalance>(value: AccountBalance(data: accountBalanceHeader))
        }

        throw NexosisClientError.parsingError

      }
  }

  var datasets: DatasetClient {
    if datasetClient == nil {
      datasetClient = DatasetClient(apiKey: apiKey, baseUrl: baseUrl)
    }
    return datasetClient!
  }

}

public class DatasetClient: ApiClient {

  func list() -> Promise<[DatasetSummary]> {

    let url = "\(baseUrl)/data"
    let headers = [ "api-key" : apiKey ]
    let request = RestRequest(url: url, method: "GET", headers: headers, body: [:])

    return RestRequester.shared
      .request(request)
      .then { response in

        let datasets = response.body["items"] as? [Any] ?? []

        let result = datasets.map { dataset in
          return DatasetSummary(data: dataset as? [String: Any] ?? [:])
        }
        return Promise<[DatasetSummary]>(value: result)
      }
  }

}

public enum NexosisClientError: Error, Equatable {
  case parsingError
  case someOtherError
}

public func == (lhs: NexosisClientError, rhs: NexosisClientError) -> Bool {
  switch (lhs, rhs) {
    case (.parsingError, .parsingError): return true
    case (.someOtherError, .someOtherError): return true
    case (_, _): return false
  }
}
