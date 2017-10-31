import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientAddSpec: QuickSpec {
    override func spec() {
        fdescribe("DatasetClient - Add") {

            var subject: DatasetClient!
            var datasetToAdd: Dataset!
            var mockNexosisRequester: MockNexosisRequester!

            var actualUrlPath: String?
            var actualBody: Body?

            beforeEach {
                mockNexosisRequester = MockNexosisRequester()

                subject = DatasetClient(apiKey: SpecHelper.ApiKey)
                subject.requester = mockNexosisRequester

                datasetToAdd = Dataset(
                    name: "squatch",
                    columns: [
                        Column(name: "date", type: .date, role: .timestamp),
                        Column(name: "class", type: .string, role: .feature),
                        Column(name: "quantity", type: .numeric, role: .target)],
                    rows: [])
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
                    actualUrlPath = mockNexosisRequester.parameters(forFunction: "put")[0] as? String
                    expect(actualUrlPath).to(equal("/data/squatch"))
                }

                it("has the expected body") {
                    actualBody = mockNexosisRequester.parameters(forFunction: "put")[1] as? Body
                    expect(actualBody?.count).to(equal(2))
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

