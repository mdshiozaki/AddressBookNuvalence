//
//  DataModel.swift
//  NuvalenceAddressbook
//
//  Created by Mshiozaki on 2021-06-03.
//

import Foundation

struct Person : Encodable, Decodable, Equatable {
    let name : String
    var phone : String
    var email : String
    var imageURL : String
}
    
