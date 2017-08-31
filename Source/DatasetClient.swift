import PromiseKit

public class DatasetClient: ApiClient {

  func list(partialName: String = "", page: Int = 0, pageSize: Int = 1000) -> Promise<[DatasetSummary]> {

    var parameters: [QueryParameter] = []

    if partialName != "" { parameters.append(QueryParameter(name: "partialName", value: partialName)) }
    if page != 0 { parameters.append(QueryParameter(name: "page", value: String(page))) }
    if pageSize != 1000 { parameters.append(QueryParameter(name: "pageSize", value: String(pageSize))) }

    return requester
      .get(urlPath: "/data", parameters: parameters)
      .then { self.processResponse(response: $0) }
  }

  func retrieve(datasetName: String, startDate: String, endDate: String, page: Int, pageSize: Int, include: [String]) -> Promise<DatasetSummary> {

    var parameters: [QueryParameter] = []

    parameters.append(QueryParameter(name: "startDate", value: startDate))
    parameters.append(QueryParameter(name: "endDate", value: endDate))
    parameters.append(QueryParameter(name: "page", value: String(page)))
    parameters.append(QueryParameter(name: "pageSize", value: String(pageSize)))

    return requester
      .get(urlPath: "/data/\(datasetName)", parameters: parameters)
      .then { self.processRetrieveResponse(response: $0) }
  }

  private func processResponse(response: RestResponse) -> Promise<[DatasetSummary]> {
    let datasets = response.body["items"] as? [Any] ?? []

    let result = datasets.map { dataset in
      return DatasetSummary(data: dataset as? [String: Any] ?? [:])
    }
    return Promise<[DatasetSummary]>(value: result)
  }

  private func processRetrieveResponse(response: RestResponse) -> Promise<DatasetSummary> {
    let result = DatasetSummary(data: response.body)
    return Promise<DatasetSummary>(value: result)
  }
}
