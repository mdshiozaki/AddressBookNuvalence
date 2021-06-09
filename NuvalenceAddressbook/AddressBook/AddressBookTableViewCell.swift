//
//  AddressBookTableViewCell.swift
//  NuvalenceAddressbook
//
//  Created by Mshiozaki on 2021-06-04.
//

import UIKit

class AddressBookTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    
    public func configure(data: Person) {
        cellName.text = data.name
        if let url = URL(string: data.imageURL) {
            cellImage.image = try? UIImage(data: Data(contentsOf: url))
            cellImage.layer.cornerRadius = cellImage.frame.height / 2
            cellImage.layer.borderColor = UIColor.white.cgColor
            cellImage.clipsToBounds = true
        }
        
    }
}
