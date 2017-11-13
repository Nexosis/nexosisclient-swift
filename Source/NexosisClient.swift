import PromiseKit

public class NexosisClient: ApiClient {
    
    private var datasetClient: DatasetClient?
    
    public var datasets: DatasetClient {
        if datasetClient == nil {
            datasetClient = DatasetClient(apiKey: apiKey, baseUrl: baseUrl)
        }
        return datasetClient!
    }
    
    public func fetchAccountBalance() -> Promise<AccountBalance> {
        
        return requester
            .get(urlPath: "/data", parameters: [
                QueryParameter(name: "page", value: String(0)),
                QueryParameter(name: "pageSize", value: String(1))
                ])
            .then { self.processResponse(response: $0) }
    }
    
    private func processResponse(response: RestResponse) -> Promise<AccountBalance> {
        let accountBalanceHeader = response.headers["nexosis-account-balance"] ?? ""
        return Promise<AccountBalance>(value: AccountBalance(data: accountBalanceHeader))
    }
}

