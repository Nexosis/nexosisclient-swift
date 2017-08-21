import PromiseKit

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
