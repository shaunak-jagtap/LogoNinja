//
//  Model.swift
//  LogoNinja
//
//  Created by Shaunak Jagtap on 14/08/21.
//

import Foundation

struct Logo: Codable {
    let imgURL: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case imgURL = "imgUrl"
        case name
    }
}

typealias Welcome = [Logo]
