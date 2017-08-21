import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class NexosisClientSpec: QuickSpec {
  override func spec() {
    describe("NexosisClient") {

      var subject: NexosisClient!
      var mockRestRequester: MockRestRequester!

      context("when created") {

        beforeEach {
          subject = SpecHelper.Client()
        }

        describe("fetch account balance") {

          var stubbedResponse: RestResponse!

          beforeEach {
            stubbedResponse = RestResponse(
              statusCode: 200,
              headers: ["nexosis-account-balance" : "12345.67 USD"]
            )
          }

          context("when it returns a result with an account balance header") {

            var actualRequest: RestRequest?
            var actualAccountBalance: AccountBalance?

            beforeEach {

              mockRestRequester = MockRestRequester()
              mockRestRequester.stubRequest(response: stubbedResponse)
              RestRequester.shared = mockRestRequester

              waitUntil { done in
                subject
                  .fetchAccountBalance()
                  .then { accountBalance -> Void in
                    actualRequest = mockRestRequester.requestParameter
                    actualAccountBalance = accountBalance
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            describe("rest request") {
              it("calls the expected url and method") {
                expect(actualRequest?.url).to(equal(SpecHelper.BaseUrl(tail: "/data?page=0&pageSize=1")));
                expect(actualRequest?.method).to(equal("GET"));
              }

              it("includes the api key") {
                expect(actualRequest?.headers["api-key"]).to(equal(SpecHelper.ApiKey))
              }

              it("has no body") {
                expect(actualRequest?.body).to(haveCount(0))
              }
            }

            describe("account balance") {
              it("fetches the amount") {
                expect(actualAccountBalance?.amount).to(equal(12345.67))
              }

              it("fetches the currency type") {
                expect(actualAccountBalance?.currency).to(equal("USD"))
              }
            }
          }

          context("when it returns a result without an account balance header") {

            var actualRequest: RestRequest?
            var actualError: Error?

            beforeEach {

              stubbedResponse.headers = [:]

              mockRestRequester = MockRestRequester()
              mockRestRequester.stubRequest(response: stubbedResponse)
              RestRequester.shared = mockRestRequester

              waitUntil { done in
                subject
                  .fetchAccountBalance()
                  .catch { error in
                    actualRequest = mockRestRequester.requestParameter
                    actualError = error
                    done()
                }
              }
            }

            describe("rest request") {
              it("calls the expected url and method") {
                expect(actualRequest?.url).to(equal(SpecHelper.BaseUrl(tail: "/data?page=0&pageSize=1")));
                expect(actualRequest?.method).to(equal("GET"));
              }

              it("includes the api key") {
                expect(actualRequest?.headers["api-key"]).to(equal(SpecHelper.ApiKey))
              }

              it("has no body") {
                expect(actualRequest?.body).to(haveCount(0))
              }
            }

            describe("error") {
              it("returns a parsing error") {
                expect(actualError as? NexosisClientError).to(equal(NexosisClientError.parsingError))
              }
            }
          }
        }
      }
    }
  }
}