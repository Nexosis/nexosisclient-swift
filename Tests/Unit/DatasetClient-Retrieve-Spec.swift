import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClient

class DatasetClientRetreieveSpec: QuickSpec {
    override func spec() {
        describe("DatasetClient - Retrieve") {
            
            var subject: DatasetClient!
            var mockNexosisRequester: MockNexosisRequester!
            
            beforeEach {
                mockNexosisRequester = MockNexosisRequester()
                
                subject = DatasetClient(apiKey: SpecHelper.ApiKey)
                subject.requester = mockNexosisRequester
            }
            
            context("when retrieval succeeds") {
                
                var actualDataset: Dataset?
                
                beforeEach {
                    
                    mockNexosisRequester.stub(function: "get", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 200,
                        body: [ "dataSetName": "Sasquatch" ]
                    )))
                    
                    waitUntil { done in
                        subject
                            .retrieve(
                                datasetName: "squatch",
                                startDate: "1955-08-13", endDate: "1972-03-09",
                                page: 3, pageSize: 42,
                                include: ["foo", "bar", "baz"])
                            .then { dataset -> Void in
                                actualDataset = dataset
                                done()
                            }
                            .catch { error in print(error) }
                    }
                }
                
                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "get")[0] as? String).to(equal("/data/squatch"))
                }
                
                it("has the start and end date in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "get")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "startDate", value: "1955-08-13")))
                    expect(parameters).to(contain(QueryParameter(name: "endDate", value: "1972-03-09")))
                }
                
                it("has the page and page size in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "get")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "page", value: "3")))
                    expect(parameters).to(contain(QueryParameter(name: "pageSize", value: "42")))
                }
                
                it("has the included columns in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "get")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "include", values: "foo", "bar", "baz")))
                }
                
                it("returns the expected dataset") {
                    expect(actualDataset?.name).to(equal("Sasquatch"))
                }
            }
            
            context("when no parameters are provided") {
                
                var actualDataset: Dataset?
                
                beforeEach {
                    
                    mockNexosisRequester.stub(function: "get", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 200,
                        body: [ "dataSetName": "Sasquatch" ]
                    )))
                    
                    waitUntil { done in
                        subject
                            .retrieve(datasetName: "squatch")
                            .then { dataset -> Void in
                                actualDataset = dataset
                                done()
                            }
                            .catch { error in print(error) }
                    }
                }
                
                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "get")[0] as? String).to(equal("/data/squatch"))
                }
                
                it("has no parameters") {
                    expect(mockNexosisRequester.parameters(forFunction: "get")[1] as? [QueryParameter]).to(beEmpty())
                }
                
                it("returns the expected dataset") {
                    expect(actualDataset?.name).to(equal("Sasquatch"))
                }
            }
            
            context("when retrieval fails") {
                
                var actualError: NexosisClientError?
                
                beforeEach {
                    
                    mockNexosisRequester.stub(function: "get", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 400,
                        body: [ "statusCode": 400, "message": "error message", "errorType": "error type" ]
                    )))
                    
                    waitUntil { done in
                        subject
                            .retrieve(
                                datasetName: "squatch",
                                startDate: "1955-08-13", endDate: "1972-03-09",
                                page: 3, pageSize: 42,
                                include: ["foo", "bar", "baz"])
                            .catch { error in
                                actualError = error as? NexosisClientError
                                done()
                        }
                    }
                }
                
                it("throws an error") {
                    expect(actualError?.statusCode).to(equal(400))
                    expect(actualError?.message).to(equal("error message"))
                    expect(actualError?.errorType).to(equal("error type"))
                }
            }
        }
    }
}
