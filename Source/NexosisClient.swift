import PromiseKit

public class NexosisClient: ApiClient {

  private var datasetClient: DatasetClient?

  var datasets: DatasetClient {
    if datasetClient == nil {
      datasetClient = DatasetClient(apiKey: apiKey, baseUrl: baseUrl)
    }
    return datasetClient!
  }

  func fetchAccountBalance() -> Promise<AccountBalance> {

    let url = "\(baseUrl)/data"
    let parameters = ["page" : "0", "pageSize" : "1"]
    let headers = ["api-key" : apiKey, "api-client-id" : apiClientId]
    let request = RestRequest(url: url, method: "GET", parameters: parameters, headers: headers)

    return RestRequester.shared
      .request(request)
      .then { self.processResponse(response: $0) }
  }

  private func processResponse(response: RestResponse) -> Promise<AccountBalance> {
    let accountBalanceHeader = response.headers["nexosis-account-balance"] ?? ""
    return Promise<AccountBalance>(value: AccountBalance(data: accountBalanceHeader))
  }
}

