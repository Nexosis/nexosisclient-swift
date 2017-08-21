import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class DatasetListSpec: QuickSpec {
  override func spec() {
    describe("Dataset.list") {

      var subject: NexosisClient!
      var mockRestRequester: MockRestRequester!

      context("when created") {

        var stubbedResponse: RestResponse!


        beforeEach {
          stubbedResponse = RestResponse(
            statusCode: 200,
            body: [
              "items": [
                [ "dataSetName": "Sasquatch" ],
                [ "dataSetName": "Chupacabra" ],
                [ "dataSetName": "Mothman" ]
              ]
            ]
          )

          mockRestRequester = MockRestRequester()
          mockRestRequester.stubRequest(response: stubbedResponse)
          RestRequester.shared = mockRestRequester

          subject = SpecHelper.Client()
        }

        describe("list all") {

          var actualRequest: RestRequest?
          var actualDatasets: [DatasetSummary]!

          beforeEach {
            waitUntil { done in
              subject.datasets
                .list()
                .then { datasets -> Void in
                  actualRequest = mockRestRequester.requestParameter
                  actualDatasets = datasets
                  done()
                }
                .catch { error in print(error) }
            }
          }

          describe("rest request") {
            it("calls the expected url and method") {
              expect(actualRequest?.url).to(equal(SpecHelper.BaseUrl(tail: "/data")));
              expect(actualRequest?.method).to(equal("GET"));
            }

            it("includes the api key") {
              expect(actualRequest?.headers["api-key"]).to(equal(SpecHelper.ApiKey))
            }

            it("has no body") {
              expect(actualRequest?.body).to(haveCount(0))
            }
          }

          describe("datasets") {
            it("returns names of all the datasets") {
              expect(actualDatasets[0].name).to(equal("Sasquatch"))
              expect(actualDatasets[1].name).to(equal("Chupacabra"))
              expect(actualDatasets[2].name).to(equal("Mothman"))
              expect(actualDatasets).to(haveCount(3))
            }
            
          }
        }

        describe("list all containing partial name") {
        }
      }
    }
  }
}
