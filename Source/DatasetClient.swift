import PromiseKit

public class DatasetClient: ApiClient {

  func list() -> Promise<[DatasetSummary]> {
    return list(parameters: [:])
  }

  func list(partialName: String) -> Promise<[DatasetSummary]> {
    return list(parameters: ["partialName" : partialName])
  }

  private func list(parameters: [String : String]) -> Promise<[DatasetSummary]> {

    let url = "\(baseUrl)/data"
    let headers = ["api-key" : apiKey, "api-client-id" : apiClientId]
    let request = RestRequest(url: url, method: "GET", parameters: parameters, headers: headers)

    return RestRequester.shared
      .request(request)
      .then { self.processResponse(response: $0) }
  }

  private func processResponse(response: RestResponse) -> Promise<[DatasetSummary]> {
    let datasets = response.body["items"] as? [Any] ?? []

    let result = datasets.map { dataset in
      return DatasetSummary(data: dataset as? [String: Any] ?? [:])
    }
    return Promise<[DatasetSummary]>(value: result)
  }
}
