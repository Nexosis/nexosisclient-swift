import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClient

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

            context("when deleting entire dataset") {

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

            context("when deleting entire dataset with cascade") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                cascade: [.forecast, .session, .model])
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[0] as? String).to(equal("/data/squatch"))
                }

                it("has the expected cascade parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "cascade", values: "forecast", "session", "model")))
                }
            }

            context("when deleting by date range") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                startDate: "1955-08-13", endDate: "1972-03-09",
                                cascade: [.forecast, .session, .model])
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

                it("has the expected cascade parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "cascade", values: "forecast", "session", "model")))
                }
            }

            context("when deleting by keys") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                keys: ["foo", "bar", "baz"],
                                cascade: [.forecast, .session, .model])
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[0] as? String).to(equal("/data/squatch"))
                }

                it("has the expected keys in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "keys", values: "foo", "bar", "baz")))
                }

                it("has the expected cascade parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "cascade", values: "forecast", "session", "model")))
                }
            }

            context("when deleting by key range") {

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 204
                    )))

                    waitUntil { done in
                        subject
                            .delete(
                                datasetName: "squatch",
                                startKey: "bar", endKey: "baz",
                                cascade: [.forecast, .session, .model])
                            .then { done() }
                            .catch { error in print(error) }
                    }
                }

                it("calls the expected url with the dataset name in it") {
                    expect(mockNexosisRequester.parameters(forFunction: "delete")[0] as? String).to(equal("/data/squatch"))
                }

                it("has the expected keys in the parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "startKey", value: "bar")))
                    expect(parameters).to(contain(QueryParameter(name: "endKey", value: "baz")))
                }

                it("has the expected cascade parameters") {
                    let parameters = mockNexosisRequester.parameters(forFunction: "delete")[1] as? [QueryParameter]
                    expect(parameters).to(contain(QueryParameter(name: "cascade", values: "forecast", "session", "model")))
                }
            }

            context("when delete fails") {

                var actualError: NexosisClientError?

                beforeEach {

                    mockNexosisRequester.stub(function: "delete", return: Promise<RestResponse>(value: RestResponse(
                        statusCode: 400,
                        body: [ "statusCode": 400, "message": "error message", "errorType": "error type" ]
                    )))

                    waitUntil { done in
                        subject
                            .delete(datasetName: "squatch")
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
