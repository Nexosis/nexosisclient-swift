import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class NexosisRequesterSpec: QuickSpec {
  override func spec() {
    describe("NexosisRequster") {

      var subject: NexosisRequester!
      var mockRestRequester: MockRestRequester!

      context("when created") {

        var stubbedResponse: RestResponse!

        beforeEach {
          stubbedResponse = RestResponse(
            statusCode: 200,
            headers: ["someHeader": "some value"],
            body: [ "someKey": "some value" ]
          )

          mockRestRequester = MockRestRequester()
          mockRestRequester.stub(function: "request", return: Promise<RestResponse>(value: stubbedResponse))
          RestRequester.shared = mockRestRequester

          subject = NexosisRequester(apiKey: SpecHelper.ApiKey, baseUrl: SpecHelper.BaseUrl)
        }

        describe("get") {

          var actualRequest: RestRequest?
          var actualResponse: RestResponse?

          context("when getting with no query paramenters") {

            beforeEach {
              waitUntil { done in
                subject
                  .get(urlPath: "/some/url")
                  .then { response -> Void in
                    actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                    actualResponse = response
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            describe("rest request") {
              it("calls the expected url and method") {
                expect(actualRequest?.url).to(equal(SpecHelper.BaseUrl(tail: "/some/url")));
                expect(actualRequest?.method).to(equal("GET"));
              }

              it("has no query parameters") {
                expect(actualRequest?.parameters).to(beEmpty())
              }

              it("has the expected headers") {
                expect(actualRequest?.headers).to(haveCount(2))
                expect(actualRequest?.headers["api-key"]).to(equal(SpecHelper.ApiKey))
                expect(actualRequest?.headers["api-client-id"]).to(equal(SpecHelper.ApiClientId))
              }

              it("has no body") {
                expect(actualRequest?.body).to(beEmpty())
              }
            }

            it("returns the stubbed response") {
              expect(actualResponse).to(be(stubbedResponse))
            }

          }

          context("when getting with query parameters") {

            beforeEach {
              waitUntil { done in
                subject
                  .get(urlPath: "/some/url", parameters: [
                    QueryParameter(name: "name", value: "Sasquatch"),
                    QueryParameter(name: "quantity", value: "42"),
                    QueryParameter(name: "someArray", values: "foo", "bar", "baz")
                  ])
                  .then { response -> Void in
                    actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                    actualResponse = response
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            describe("rest request") {
              it("calls the expected url and method") {
                expect(actualRequest?.url).to(equal(SpecHelper.BaseUrl(tail: "/some/url")));
                expect(actualRequest?.method).to(equal("GET"));
              }

              it("has the expected number of query parameters") {
                expect(actualRequest?.parameters).to(haveCount(3))
              }

              it("has the simple query parameters") {
                expect(actualRequest?.parameters).to(contain(QueryParameter(name: "name", value: "Sasquatch")))
                expect(actualRequest?.parameters).to(contain(QueryParameter(name: "quantity", value: "42")))
              }

              it("has the array query parameter") {
                expect(actualRequest?.parameters).to(contain(QueryParameter(name: "someArray", values: "foo", "bar", "baz")))
              }

              it("has the expected headers") {
                expect(actualRequest?.headers).to(haveCount(2))
                expect(actualRequest?.headers["api-key"]).to(equal(SpecHelper.ApiKey))
                expect(actualRequest?.headers["api-client-id"]).to(equal(SpecHelper.ApiClientId))
              }

              it("has no body") {
                expect(actualRequest?.body).to(haveCount(0))
              }
            }

            it("returns the stubbed response") {
              expect(actualResponse).to(be(stubbedResponse))
            }
          }
        }
      }
    }
  }
}
