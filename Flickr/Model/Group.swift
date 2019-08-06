//
//  Group.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import ObjectMapper
import UIKit

class GroupsResponse: Codable {
    var groups:Groups?
}

class Groups: Codable {
    var group: [Group]?
    var total: Int?
}

class Group: Codable {
    var name: String?
    var nsid: String?
    var iconfarm: Int?
    var iconserver: String?
}
