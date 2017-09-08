import PromiseKit

public class DatasetClient: ApiClient {

  // MARK: - delete

  func delete(datasetName: String, startDate: String = "", endDate: String = "", cascade: [Cascade] = []) -> Promise<Void> {
    let parameters = deleteParameters(startDate: startDate, endDate: endDate, cascade: cascade)
    return requester
      .delete(urlPath: "/data/\(datasetName)", parameters: parameters)
      .then { try self.processDeleteResponse(response: $0) }
  }

  private func deleteParameters(startDate: String, endDate: String, cascade: [Cascade]) -> [QueryParameter] {
    var parameters: [QueryParameter] = []
    parameters.append(contentsOf: startAndEndDateParameters(startDate: startDate, endDate: endDate))
    parameters.append(contentsOf: cascadeParameter(cascade: cascade))
    return parameters
  }

  private func processDeleteResponse(response: RestResponse) throws -> Promise<Void> {
    try throwIfError(response: response)
    return Promise<Void>()
  }

  // MARK: - list

  func list(partialName: String = "", page: Int = 0, pageSize: Int = 1000) -> Promise<[Dataset]> {
    let parameters = listParameters(partialName: partialName, page: page, pageSize: pageSize)
    return requester
      .get(urlPath: "/data", parameters: parameters)
      .then { try self.processListResponse(response: $0) }
  }

  private func listParameters(partialName: String, page: Int, pageSize: Int) -> [QueryParameter] {
    var parameters: [QueryParameter] = []
    parameters.append(contentsOf: partialNameParameter(partialName: partialName))
    parameters.append(contentsOf: pageAndSizeParameters(page: page, pageSize: pageSize))
    return parameters
  }

  private func processListResponse(response: RestResponse) throws -> Promise<[Dataset]> {
    try throwIfError(response: response)

    let datasets = response.body["items"] as? [Any] ?? []
    let result = datasets.map { dataset in
      return Dataset(data: dataset as? [String: Any] ?? [:])
    }
    return Promise<[Dataset]>(value: result)
  }

  // MARK: - retrieve

  func retrieve(datasetName: String, startDate: String = "", endDate: String = "", page: Int = 0, pageSize: Int = 1000, include: [String] = []) -> Promise<Dataset> {
    let parameters = retrieveParameters(startDate: startDate, endDate: endDate, page: page, pageSize: pageSize, include: include)
    return requester
      .get(urlPath: "/data/\(datasetName)", parameters: parameters)
      .then { try self.processRetrieveResponse(response: $0) }
  }

  private func retrieveParameters(startDate: String, endDate: String, page: Int, pageSize: Int, include: [String]) -> [QueryParameter] {
    var parameters: [QueryParameter] = []
    parameters.append(contentsOf: startAndEndDateParameters(startDate: startDate, endDate: endDate))
    parameters.append(contentsOf: pageAndSizeParameters(page: page, pageSize: pageSize))
    parameters.append(contentsOf: includeParameter(include: include))
    return parameters
  }

  private func processRetrieveResponse(response: RestResponse) throws -> Promise<Dataset> {
    try throwIfError(response: response)
    return Promise<Dataset>(value: Dataset(data: response.body))
  }

  // MARK: - parameter helpers

  private func partialNameParameter(partialName: String) -> [QueryParameter] {
    return partialName == "" ? [] : [QueryParameter(name: "partialName", value: partialName)]
  }

  private func startAndEndDateParameters(startDate: String, endDate: String) -> [QueryParameter] {
    var parameters: [QueryParameter] = []
    if (startDate != "") { parameters.append(QueryParameter(name: "startDate", value: startDate)) }
    if (endDate != "") { parameters.append(QueryParameter(name: "endDate", value: endDate)) }
    return parameters
  }

  private func pageAndSizeParameters(page: Int, pageSize: Int) -> [QueryParameter] {
    var parameters: [QueryParameter] = []
    if page != 0 { parameters.append(QueryParameter(name: "page", value: String(page))) }
    if pageSize != 1000 { parameters.append(QueryParameter(name: "pageSize", value: String(pageSize))) }
    return parameters
  }

  private func cascadeParameter(cascade: [Cascade]) -> [QueryParameter] {
    let cascadeOfStrings: [String] = cascade.map { $0.rawValue }
    return cascadeOfStrings.isEmpty ? [] : [QueryParameter(name: "cascade", value: cascadeOfStrings)]
  }

  private func includeParameter(include: [String]) -> [QueryParameter] {
    return include.isEmpty ? [] : [QueryParameter(name: "include", value: include)]
  }

  // MARK: - other

  private func throwIfError(response: RestResponse) throws {
    if (response.statusCode >= 400) {
      throw NexosisClientError(data: response.body)
    }
  }
}

public enum Cascade: String {
  case forecast, sessions
}
