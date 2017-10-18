import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientAddSpec: QuickSpec {
    override func spec() {
        describe("DatasetClient - Add") {

            var subject: DatasetClient!
            var datasetToAdd: Dataset!
            var mockNexosisRequester: MockNexosisRequester!

            beforeEach {
                mockNexosisRequester = MockNexosisRequester()

                subject = DatasetClient(apiKey: SpecHelper.ApiKey)
                subject.requester = mockNexosisRequester

                datasetToAdd = Dataset(name: "chupacabra")
            }

            context("when add succeeds") {

                beforeEach {

                    mockNexosisRequester.stub(function: "put", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 200,
                        body: [ "dataSetName": "Sasquatch" ]
                    )))

                    waitUntil { done in
                        subject
                            .add(dataset: datasetToAdd)
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "put")[0] as? String).to(equal("/data/squatch"))
                }
            }

            xcontext("when adding fails") {

                var actualError: NexosisClientError?

                beforeEach {

                    mockNexosisRequester.stub(function: "put", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 400,
                        body: [ "statusCode": 400, "message": "error message", "errorType": "error type" ]
                    )))

                    waitUntil { done in
                        subject
                            .add(dataset: datasetToAdd)
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

