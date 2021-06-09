//
//  AddressBookModelTests.swift
//  AddressBookModelTests
//
//  Created by Mshiozaki on 2021-06-05.
//

import XCTest
@testable import NuvalenceAddressbook

fileprivate class MockDataTask: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping() -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

fileprivate class MockURLSession : URLSession {
    var data: Data?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return MockDataTask {
            completionHandler(data, nil, error)
        }
    }
}

fileprivate class MockURLProtocol : URLProtocol {
    static var requestHandler : ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
            return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}

class AddressBookModelTests: XCTestCase {
    private static let SOME_FIRST_NAME = "John"
    private static let SOME_LAST_NAME = "Cena"
    private static let SOME_FULL_NAME = "\(SOME_FIRST_NAME) \(SOME_LAST_NAME)"
    private static let SOME_PHONE_NUMBER = "4169671111"
    private static let SOME_EMAIL = "test@test.com"
    private static let SOME_IMAGE_URL = "test.com/mypic.png"
    
    private var testPerson: Person!
    private var testMockPerson: MockResponse.Person!

    private var sut : AddressBookModel!
    private var urlSession : URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        sut = AddressBookModel(urlSession: urlSession)
        
        self.testPerson = Person(
            name: AddressBookModelTests.SOME_FULL_NAME,
            phone: AddressBookModelTests.SOME_PHONE_NUMBER,
            email: AddressBookModelTests.SOME_EMAIL,
            imageURL: AddressBookModelTests.SOME_IMAGE_URL
        )
        
        self.testMockPerson = MockResponse.Person(
            name: MockResponse.Person.Name(
                first: AddressBookModelTests.SOME_FIRST_NAME,
                last: AddressBookModelTests.SOME_LAST_NAME
            ),
            phone: AddressBookModelTests.SOME_PHONE_NUMBER,
            email: AddressBookModelTests.SOME_EMAIL,
            picture: MockResponse.Person.Picture(thumbnail: AddressBookModelTests.SOME_IMAGE_URL)
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // test for the API call
    func testGetPeopleReturnsPeopleList() throws {
        // given
        var peopleList : [Person]?
        
        let mockPerson = self.testMockPerson!
        let mockData = try JSONEncoder().encode(MockResponse(results: [mockPerson]))
        MockURLProtocol.requestHandler = { request in
            return(HTTPURLResponse(), mockData)
        }
        
        // when
        let expectation = XCTestExpectation(description: "response")
        sut.getPeople { persons, _ in
            peopleList = persons
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        // then
        XCTAssertEqual(peopleList?.count, 1)
        self.equatePersons(expected: self.testPerson, actual: mockPerson)
    }
    
    func testErrorResponse() throws {
        // given
        let error = NSError(domain: "whoops", code: 100, userInfo: nil)
        MockURLProtocol.requestHandler = { request in
            throw error
        }
        
        // when
        let expectation = XCTestExpectation(description: "response")
        sut.getPeople { _, error in
            // then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
    }
    
    // UTILS
    private func equatePersons(expected person: Person, actual mock: MockResponse.Person) {
        XCTAssertEqual(person.name, mock.name.toFullName())
        XCTAssertEqual(person.email, mock.email)
        XCTAssertEqual(person.phone, mock.phone)
        XCTAssertEqual(person.imageURL, mock.picture.thumbnail)
    }
}

// Helper struct to encode randomuser.me responses
fileprivate struct MockResponse: Encodable, Decodable {
    var results: [Person] = []

    // Inner structs
    struct Person: Encodable, Decodable {
        struct Name: Encodable, Decodable {
            var first = ""
            var last = ""

            func toFullName() -> String {
                return "\(first) \(last)"
            }
        }

        struct Picture: Encodable, Decodable {
            var thumbnail = ""
        }
        
        var name: Name = Name()
        var phone = ""
        var email = ""
        var picture = Picture()
    }
}
