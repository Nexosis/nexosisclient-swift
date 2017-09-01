import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientListSpec: QuickSpec {
  override func spec() {
    describe("DatasetClient - List") {

      var subject: DatasetClient!
      var mockNexosisRequester: MockNexosisRequester!

      var actualUrlPath: String?
      var actualParameters: [QueryParameter]?
      var actualDatasets: [Dataset]!

      beforeEach {
        mockNexosisRequester = MockNexosisRequester()

        subject = DatasetClient(apiKey: SpecHelper.ApiKey)
        subject.requester = mockNexosisRequester

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

      context("when list succeeds") {

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
          expect(actualParameters).to(contain(QueryParameter(name: "partialName", value: "squatch")))
          expect(actualParameters).to(contain(QueryParameter(name: "page", value: "3")))
          expect(actualParameters).to(contain(QueryParameter(name: "pageSize", value: "42")))
        }

        it("returns datasets from the response") {
          expect(actualDatasets).to(haveCount(3))
          expect(actualDatasets[0].name).to(equal("Sasquatch"))
          expect(actualDatasets[1].name).to(equal("Chupacabra"))
          expect(actualDatasets[2].name).to(equal("Mothman"))
        }
      }

      context("when no parameters are provided") {

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
          expect(actualParameters).to(beEmpty())
        }

        it("returns datasets from the response") {
          expect(actualDatasets).to(haveCount(3))
          expect(actualDatasets[0].name).to(equal("Sasquatch"))
          expect(actualDatasets[1].name).to(equal("Chupacabra"))
          expect(actualDatasets[2].name).to(equal("Mothman"))
        }
      }

      context("when list fails") {

        var actualError: NexosisClientError?

        beforeEach {

          mockNexosisRequester.stubGet(response: RestResponse(
            statusCode: 400,
            body: [ "statusCode": 400, "message": "error message", "errorType": "error type" ]
          ))

          waitUntil { done in
            subject
              .list()
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
