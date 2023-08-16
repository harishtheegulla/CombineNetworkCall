//
//  Model.swift
//  Combine-NetworkCall
//
//  Created by HarishSupriya on 2023-08-15.
//

import Foundation
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
