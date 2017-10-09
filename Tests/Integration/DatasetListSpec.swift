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
          stubbedResponse = RestResponse(statusCode: 200)

          mockRestRequester = MockRestRequester()
          mockRestRequester.stub(function: "request", return: Promise<RestResponse>(value: stubbedResponse))
          RestRequester.shared = mockRestRequester

          subject = SpecHelper.Client()
        }

        describe("list") {

          beforeEach {
            waitUntil { done in
              subject.datasets
                .list()
                .then { _ -> Void in
                  done()
                }
                .catch { error in print(error) }
            }
          }

          it("calls calls the rest requester") {
            expect(mockRestRequester.invoked(function: "request")).to(beTrue())
          }
        }
      }
    }
  }
}
