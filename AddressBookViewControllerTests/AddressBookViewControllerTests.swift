//
//  AddressBookViewControllerTests.swift
//  AddressBookViewControllerTests
//
//  Created by Mshiozaki on 2021-06-05.
//

import XCTest
@testable import NuvalenceAddressbook

class AddressBookTableViewControllerTests: XCTestCase {
    var sut : AddressBookTableViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AddressBookTableViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewControllerHasTableView() {
        // when
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // given
        guard let viewController = storyboard.instantiateViewController(identifier: "AddressBookTableViewController") as? AddressBookTableViewController else {
            return XCTFail("Failed to instantiate initial view controller")
        }
        viewController.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(viewController.tableView, "TableView exists in controller")
    }
    
    func testTableViewDataSourceDelegateSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // given
        guard let viewController = storyboard.instantiateViewController(identifier: "AddressBookTableViewController") as? AddressBookTableViewController else {
            return XCTFail("Failed to instantiate initial view controller")
        }
        viewController.loadViewIfNeeded()

        // then
        XCTAssertTrue(viewController.tableView.dataSource is AddressBookTableViewController, "Data source is the VC")
        XCTAssertTrue(viewController.tableView.delegate is AddressBookTableViewController, "Delegate is the VC")
    }
    
    func testNumberofTableViewRows() {
        // given
        sut.peopleList = [Person(name: "Test 1", phone: "Phone 1", email: "Email 1", imageURL: "Image 1"), Person(name: "Test 2", phone: "Phone 2", email: "Email 2", imageURL: "Image 2"), Person(name: "Test 3", phone: "Phone 3", email: "Email 3", imageURL: "Image 3")]
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        
        // when
        sut.tableView.reloadData()
        
        // then
        XCTAssertEqual(numberOfRows, 3, "Number of rows is the same as number of test persons")
    }
    
    func testDataInCellForRow() {
        // given
        sut.peopleList = [Person(name: "Test 1", phone: "Phone 1", email: "Email 1", imageURL: "Image 1")]
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: IndexPath(row: 0, section: 0)) as? AddressBookTableViewCell
        
        // when
        cell?.configure(data: sut.peopleList[0])
        
        // then
        XCTAssertEqual(cell?.cellName.text, "Test 1")
    }
}
