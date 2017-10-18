import Quick
import Nimble
import PromiseKit

@testable import NexosisApiClientiOS

class NexosisRequesterSpec: QuickSpec {
    override func spec() {
        fdescribe("NexosisRequster") {
            
            var subject: NexosisRequester!
            var mockRestRequester: MockRestRequester!
            
            context("when created") {

                let expectedHeaders = [
                    "api-key": SpecHelper.ApiKey,
                    "api-client-id": SpecHelper.ApiClientId
                ]

                let queryParameters = [
                    QueryParameter(name: "name", value: "Sasquatch"),
                    QueryParameter(name: "quantity", value: "42"),
                    QueryParameter(name: "someArray", values: "foo", "bar", "baz")
                ]

                let body = [ "cryptids" : [ "sasquatch", "chupacabra", "yeti" ] ]

                var stubbedResponse: RestResponse!

                var actualRequest: RestRequest?
                var actualResponse: RestResponse?

                beforeEach {
                    stubbedResponse = RestResponse(
                        statusCode: 200,
                        headers: ["someHeader": "some value"],
                        body: body
                    )
                    
                    mockRestRequester = MockRestRequester()
                    mockRestRequester.stub(function: "request", return: Promise<RestResponse>(value: stubbedResponse))
                    RestRequester.shared = mockRestRequester
                    
                    subject = NexosisRequester(apiKey: SpecHelper.ApiKey, baseUrl: SpecHelper.BaseUrl)
                }
                
                describe("get") {
                    
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

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "GET",
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).to(beEmpty())
                        }
                        
                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }
                        
                    }
                    
                    context("when getting with query parameters") {

                        beforeEach {
                            waitUntil { done in
                                subject
                                    .get(urlPath: "/some/url", parameters: queryParameters)
                                    .then { response -> Void in
                                        actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                                        actualResponse = response
                                        done()
                                    }
                                    .catch { error in print(error) }
                            }
                        }

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "GET",
                                parameters: queryParameters,
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).to(beEmpty())
                        }

                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }
                    }
                }

                describe("put") {

                    context("when putting with no query paramenters") {

                        beforeEach {
                            waitUntil { done in
                                subject
                                    .put(urlPath: "/some/url", body: body)
                                    .then { response -> Void in
                                        actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                                        actualResponse = response
                                        done()
                                    }
                                    .catch { error in print(error) }
                            }
                        }

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "PUT",
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).notTo(beEmpty())
                        }

                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }

                    }

                    context("when getting with query parameters") {

                        beforeEach {
                            waitUntil { done in
                                subject
                                    .put(urlPath: "/some/url", parameters: queryParameters, body: body)
                                    .then { response -> Void in
                                        actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                                        actualResponse = response
                                        done()
                                    }
                                    .catch { error in print(error) }
                            }
                        }

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "PUT",
                                parameters: queryParameters,
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).notTo(beEmpty())
                        }

                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }
                    }
                }

                describe("delete") {

                    context("when deleting with no query paramenters") {

                        beforeEach {
                            waitUntil { done in
                                subject
                                    .delete(urlPath: "/some/url")
                                    .then { response -> Void in
                                        actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                                        actualResponse = response
                                        done()
                                    }
                                    .catch { error in print(error) }
                            }
                        }

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "DELETE",
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).to(beEmpty())
                        }

                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }

                    }

                    context("when deleting with query parameters") {

                        beforeEach {
                            waitUntil { done in
                                subject
                                    .delete(urlPath: "/some/url", parameters: queryParameters)
                                    .then { response -> Void in
                                        actualRequest = mockRestRequester.parameters(forFunction: "request")[0] as? RestRequest
                                        actualResponse = response
                                        done()
                                    }
                                    .catch { error in print(error) }
                            }
                        }

                        it("passes the expected request") {
                            let expectedRequest = RestRequest(
                                url: SpecHelper.BaseUrl(tail: "/some/url"),
                                method: "DELETE",
                                parameters: queryParameters,
                                headers: expectedHeaders)
                            expect(actualRequest).to(equal(expectedRequest))
                            expect(actualRequest?.body).to(beEmpty())
                        }

                        it("returns the stubbed response") {
                            expect(actualResponse).to(equal(stubbedResponse))
                        }
                    }
                }
            }
        }
    }
}
