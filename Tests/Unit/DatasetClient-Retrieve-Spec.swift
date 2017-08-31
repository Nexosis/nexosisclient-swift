import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetClientRetreieveSpec: QuickSpec {
  override func spec() {
    describe("DatasetClient - Retrieve") {

      var subject: DatasetClient!
      var mockNexosisRequester: MockNexosisRequester!

      var actualDataset: DatasetSummary!

      beforeEach {
        mockNexosisRequester = MockNexosisRequester()

        subject = DatasetClient(apiKey: SpecHelper.ApiKey)
        subject.requester = mockNexosisRequester

        mockNexosisRequester.stubGet(response: RestResponse(
          statusCode: 200,
          body: [
            "dataSetName": "Sasquatch"
          ]
        ))
      }

      context("happy path") {

        beforeEach {
          waitUntil { done in
            subject
              .retrieve(
                datasetName: "squatch",
                startDate: "1955-08-13", endDate: "1972-03-09",
                page: 3, pageSize: 42,
                include: ["foo", "bar", "baz"])
              .then { dataset -> Void in
                done()
              }
              .catch { error in print(error) }
          }
        }

        it("calls the expected url with the dataset name in it") {
          expect(mockNexosisRequester.urlPathParameter).to(equal("/data/squatch"));
        }

        it("has the start and end date in the parameters") {
          let parameters = mockNexosisRequester.parametersParameter
          expect(parameters).to(contain(QueryParameter(name: "startDate", value: "1955-08-13")))
          expect(parameters).to(contain(QueryParameter(name: "endDate", value: "1972-03-09")))
        }

        it("has the page and page size in the parameters") {
          let parameters = mockNexosisRequester.parametersParameter
          expect(parameters).to(contain(QueryParameter(name: "page", value: "3")))
          expect(parameters).to(contain(QueryParameter(name: "pageSize", value: "42")))
        }

        it("has the included columns in the parameters") {
//          let parameters = mockNexosisRequester.parametersParameter
//          expect(parameters?["include"]).to(haveCount(3))
//          expect(parameters?["include"][0]).to(equal("foo"))
//          expect(parameters?["include"][1]).to(equal("foo"))
//          expect(parameters?["include"][2]).to(equal("foo"))
        }
      }
    }
  }
}
