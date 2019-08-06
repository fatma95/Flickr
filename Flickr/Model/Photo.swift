//
//  Photo.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import ObjectMapper
import UIKit

class Response: Codable {
    var photos:Photos?
}

class Photos: Codable {
    var photo: [Photo]?
    var total: Int?
}

class Photo: Codable {
    var id: String?
    var farm: Int?
    var server: String?
    var secret: String?
}
