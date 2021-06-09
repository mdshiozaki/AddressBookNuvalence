//
//  DetailsViewModelTests.swift
//  DetailsViewModelTests
//
//  Created by Mshiozaki on 2021-06-06.
//

import XCTest
@testable import NuvalenceAddressbook

class DetailsViewModelTests: XCTestCase {

    var sut : DetailsViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailsViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
}
