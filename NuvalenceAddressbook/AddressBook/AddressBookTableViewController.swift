//
//  AddressBookTableViewController.swift
//  NuvalenceAddressbook
//
//  Created by Mshiozaki on 2021-06-03.
//

import UIKit

class AddressBookTableViewController: UITableViewController {
    var addressBookModel = AddressBookModel() 
    private let personItem = "PersonCell"
    
    var peopleList: [Person] = [] {
        didSet {
            updateTable()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        
        addressBookModel.getPeople { person, error  in
            if let people = person {
                self.peopleList = people
            }
        }

        // API Call and handle 
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddressBookTableViewCell", bundle: nil), forCellReuseIdentifier: personItem)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: personItem, for: indexPath) as? AddressBookTableViewCell else {fatalError("Cells not found for table")}
        
        cell.configure(data: peopleList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = peopleList[indexPath.row]
        
        if let personVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            
            personVC.detailsModel.selectedPerson = selectedPerson
            self.navigationController?.pushViewController(personVC, animated: true)
        }
    }
    
    @objc func handleRefreshControl() {
        // pulldown refresh -> fetches new list of people
        addressBookModel.getPeople { person, error  in
            if let people = person {
                self.peopleList = people
            }
        }
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
