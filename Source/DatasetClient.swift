import PromiseKit

public class DatasetClient: ApiClient {

  func list(partialName: String = "", page: Int = 0, pageSize: Int = 1000) -> Promise<[Dataset]> {

    var parameters: [QueryParameter] = []

    if partialName != "" { parameters.append(QueryParameter(name: "partialName", value: partialName)) }
    if page != 0 { parameters.append(QueryParameter(name: "page", value: String(page))) }
    if pageSize != 1000 { parameters.append(QueryParameter(name: "pageSize", value: String(pageSize))) }

    return requester
      .get(urlPath: "/data", parameters: parameters)
      .then { try self.processListResponse(response: $0) }
  }

  func retrieve(datasetName: String, startDate: String = "", endDate: String = "", page: Int = 0, pageSize: Int = 1000, include: [String] = []) -> Promise<Dataset> {

    var parameters: [QueryParameter] = []

    if (startDate != "") { parameters.append(QueryParameter(name: "startDate", value: startDate)) }
    if (endDate != "") { parameters.append(QueryParameter(name: "endDate", value: endDate)) }
    if (page != 0) { parameters.append(QueryParameter(name: "page", value: String(page))) }
    if (pageSize != 1000) { parameters.append(QueryParameter(name: "pageSize", value: String(pageSize))) }
    if (!include.isEmpty) { parameters.append(QueryParameter(name: "include", value: include)) }

    return requester
      .get(urlPath: "/data/\(datasetName)", parameters: parameters)
      .then { try self.processRetrieveResponse(response: $0) }
  }

  private func processListResponse(response: RestResponse) throws -> Promise<[Dataset]> {
    try throwIfError(response: response)

    let datasets = response.body["items"] as? [Any] ?? []
    let result = datasets.map { dataset in
      return Dataset(data: dataset as? [String: Any] ?? [:])
    }
    return Promise<[Dataset]>(value: result)
  }

  private func processRetrieveResponse(response: RestResponse) throws -> Promise<Dataset> {
    try throwIfError(response: response)
    return Promise<Dataset>(value: Dataset(data: response.body))
  }

  private func throwIfError(response: RestResponse) throws {
    if (response.statusCode >= 400) {
      throw NexosisClientError(data: response.body)
    }
  }
}
