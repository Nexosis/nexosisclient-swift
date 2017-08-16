import Quick
import Nimble
import PromiseKit

class NexosisClientSpec: QuickSpec {
  override func spec() {
    describe("NexosisClientApi") {

      var subject: NexosisClient!
      var mockRestRequester: MockRestRequester!

      context("when created") {

        beforeEach {
          mockRestRequester = MockRestRequester()

          subject = NexosisClient(apiKey: "f3f040dfa88a4180a33ba16e1090242b", baseUrl: "https://api.uat.nexosisdev.com/v1")
          subject.restRequester = mockRestRequester
        }

        describe("fetch account balance") {

          var expectedRequest: RestRequest!
          var stubbedResponse: RestResponse!

          beforeEach {
            expectedRequest = RestRequest(
              url: "https://api.uat.nexosisdev.com/v1/data?page=0&pageSize=1",
              method: .get,
              headers: [ "api-key" : "f3f040dfa88a4180a33ba16e1090242b" ],
              body: [:]
            )

            stubbedResponse = RestResponse(
              statusCode: 200,
              headers: ["Nexosis-Account-Balance" : "12345.67 USD"],
              body: [:]
            )
          }

          context("when it returns a result with an account balance header") {

            var actualAccountBalance: AccountBalance?
            
            beforeEach {

              mockRestRequester.stub(
                function: "request",
                whenCalledWith: [expectedRequest],
                return: Promise<RestResponse>(value: stubbedResponse)
              )

              waitUntil { done in
                subject
                  .fetchAccountBalance()
                  .then { accountBalance -> Void in
                    actualAccountBalance = accountBalance
                    done()
                  }
                  .catch { error in print(error) }
              }
            }

            it("makes to expected rest call") {
              expect(mockRestRequester.invoked(function: "request", with: [expectedRequest])).to(beTrue());
            }

            it("fetches the amount") {
              expect(actualAccountBalance?.amount).to(equal(12345.67))
            }

            it("fetches the currency type") {
              expect(actualAccountBalance?.currency).to(equal("USD"))
            }

          }

          context("when it returns a result without an account balance header") {

            var actualError: Error?

            beforeEach {

              stubbedResponse.headers = [:]

              mockRestRequester.stub(
                function: "request",
                whenCalledWith: [expectedRequest],
                return: Promise<RestResponse>(value: stubbedResponse)
              )

              waitUntil { done in
                subject
                  .fetchAccountBalance()
                  .catch { error in
                    actualError = error
                    done()
                }
              }
            }

            it("makes to expected rest call") {
              expect(mockRestRequester.invoked(function: "request", with: [expectedRequest])).to(beTrue());
            }

            it("returns a parsing error") {
              expect(actualError as? NexosisClientError).to(equal(NexosisClientError.parsingError))
            }
          }
        }
      }
    }
  }
}
