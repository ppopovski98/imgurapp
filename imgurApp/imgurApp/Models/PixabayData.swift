//
//  ImgurData.swift
//  imgurApp
//
//  Created by Petar Popovski on 16.5.23.
//

import Foundation

struct PixabayData: Codable {
    let total: Int
    let hits: [Hit]
}

struct Hit: Codable {
    let id: Int
    let pageURL: String
    let largeImageURL: String
    var likes: Int?
}
