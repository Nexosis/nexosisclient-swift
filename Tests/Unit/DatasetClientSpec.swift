import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientSpec: QuickSpec {
  override func spec() {
    describe("DatasetClient") {

      var subject: DatasetClient!
      var mockNexosisRequester: MockNexosisRequester!

      context("when created") {

        var actualUrlPath: String?
        var actualParameters: [String: String]?
        var actualDatasets: [DatasetSummary]!

        beforeEach {
          mockNexosisRequester = MockNexosisRequester()

          subject = DatasetClient(apiKey: SpecHelper.ApiKey)
          subject.requester = mockNexosisRequester
        }

        describe("list") {

          beforeEach {
            mockNexosisRequester.stubGet(response: RestResponse(
              statusCode: 200,
              body: [
                "items": [
                  [ "dataSetName": "Sasquatch" ],
                  [ "dataSetName": "Chupacabra" ],
                  [ "dataSetName": "Mothman" ]
                ]
              ]
            ))
          }

          context("happy path") {

            beforeEach {
              waitUntil { done in
                subject
                  .list(partialName: "squatch", page: 3, pageSize: 42)
                  .then { datasets -> Void in
                    actualUrlPath = mockNexosisRequester.urlPathParameter
                    actualParameters = mockNexosisRequester.parametersParameter
                    actualDatasets = datasets
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("calls the expected url") {
              expect(actualUrlPath).to(equal("/data"));
            }

            it("has expected parameters") {
              expect(actualParameters).to(haveCount(3))
              expect(actualParameters?["partialName"]).to(equal("squatch"))
              expect(actualParameters?["page"]).to(equal("3"))
              expect(actualParameters?["pageSize"]).to(equal("42"))
            }

            it("returns datasets from the response") {
              expect(actualDatasets).to(haveCount(3))
              expect(actualDatasets[0].name).to(equal("Sasquatch"))
              expect(actualDatasets[1].name).to(equal("Chupacabra"))
              expect(actualDatasets[2].name).to(equal("Mothman"))
            }
          }

          context("with no parameters") {

            beforeEach {
              waitUntil { done in
                subject
                  .list()
                  .then { datasets -> Void in
                    actualUrlPath = mockNexosisRequester.urlPathParameter
                    actualParameters = mockNexosisRequester.parametersParameter
                    actualDatasets = datasets
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("calls the expected url") {
              expect(actualUrlPath).to(equal("/data"));
            }

            it("has no parameters") {
              expect(actualParameters).to(haveCount(0))
            }

            it("returns datasets from the response") {
              expect(actualDatasets).to(haveCount(3))
              expect(actualDatasets[0].name).to(equal("Sasquatch"))
              expect(actualDatasets[1].name).to(equal("Chupacabra"))
              expect(actualDatasets[2].name).to(equal("Mothman"))
            }
          }

          context("with only partial name") {

            beforeEach {
              waitUntil { done in
                subject
                  .list(partialName: "squatch")
                  .then { datasets -> Void in
                    actualParameters = mockNexosisRequester.parametersParameter
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("has partial name parameter") {
              expect(actualParameters).to(haveCount(1))
              expect(actualParameters?["partialName"]).to(equal("squatch"))
            }
          }

          context("with only page") {

            beforeEach {
              waitUntil { done in
                subject
                  .list(page: 3)
                  .then { datasets -> Void in
                    actualParameters = mockNexosisRequester.parametersParameter
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("has partial name parameter") {
              expect(actualParameters).to(haveCount(1))
              expect(actualParameters?["page"]).to(equal("3"))
            }
          }

          context("with only page size") {

            beforeEach {
              waitUntil { done in
                subject
                  .list(pageSize: 10)
                  .then { datasets -> Void in
                    actualParameters = mockNexosisRequester.parametersParameter
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("has partial name parameter") {
              expect(actualParameters).to(haveCount(1))
              expect(actualParameters?["pageSize"]).to(equal("10"))
            }
          }
        }
      }
    }
  }
}
