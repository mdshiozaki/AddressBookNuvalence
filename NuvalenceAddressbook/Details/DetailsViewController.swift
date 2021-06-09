//
//  DetailsViewController.swift
//  NuvalenceAddressbook
//
//  Created by Mshiozaki on 2021-06-03.
//

import Foundation
import UIKit

class DetailsViewController : UIViewController {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personEmail: UILabel!
    @IBOutlet weak var personPhoneNumber: UILabel!
    
    var detailsModel = DetailsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        let person = detailsModel.selectedPerson
        
        if let url = URL(string: person.imageURL) {
            personImage.image = try? UIImage(data: Data(contentsOf: url))
            personImage.layer.cornerRadius = personImage.frame.height / 2
            personImage.layer.borderColor = UIColor.white.cgColor
            personImage.clipsToBounds = true
        }
        
        personName.text = person.name
        personEmail.text = person.email
        personPhoneNumber.text = person.phone
    }
}
