import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientDeleteSpec: QuickSpec {
    override func spec() {
        describe("DatasetClient - Delete") {

            var subject: DatasetClient!
            var mockNexosisRequester: MockNexosisRequester!

            beforeEach {
                mockNexosisRequester = MockNexosisRequester()

                subject = DatasetClient(apiKey: SpecHelper.ApiKey)
                subject.requester = mockNexosisRequester
            }

            context("when delete succeeds") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                startDate: "1955-08-13", endDate: "1972-03-09",
                                cascade: [.forecast, .sessions])
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[0] as? String).to(equal("/data/squatch"))
                }

                it("has the start and end date in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "startDate", value: "1955-08-13")))
                    expect(parameters).to(contain(QueryParameter(name: "endDate", value: "1972-03-09")))
                }

                it("has the expected cascade  parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "cascade", values: "forecast", "sessions")))
                }
            }

            context("when no parameters are provided") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(datasetName: "squatch")
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[0] as? String).to(equal("/data/squatch"))
                }

                it("has no parameters") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]).to(beEmpty())
                }
            }

            context("when retrieval fails") {

                var actualError: NexosisClientError?

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 400,
                        body: [ "statusCode": 400, "message": "error message", "errorType": "error type" ]
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                startDate: "1955-08-13", endDate: "1972-03-09",
                                cascade: [.forecast, .sessions])
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
