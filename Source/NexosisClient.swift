import PromiseKit

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

