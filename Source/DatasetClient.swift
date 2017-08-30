import PromiseKit

public class DatasetClient: ApiClient {

  func list(partialName: String = "") -> Promise<[DatasetSummary]> {

    var parameters: [String: String] = [:]

    if partialName != "" { parameters["partialName"] = partialName }

    return list(parameters: parameters)
  }

  private func list(parameters: [String : String]) -> Promise<[DatasetSummary]> {
    return requester
      .get(urlPath: "/data", parameters: parameters)
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
