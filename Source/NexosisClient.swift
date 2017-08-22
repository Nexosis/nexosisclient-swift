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

    return requester
      .get(urlPath: "/data", parameters: ["page" : "0", "pageSize" : "1"])
      .then { self.processResponse(response: $0) }
  }

  private func processResponse(response: RestResponse) -> Promise<AccountBalance> {
    let accountBalanceHeader = response.headers["nexosis-account-balance"] ?? ""
    return Promise<AccountBalance>(value: AccountBalance(data: accountBalanceHeader))
  }
}

