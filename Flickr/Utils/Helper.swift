//
//  Helper.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import Foundation

class Helper {
    class func getPhotoURL(photo: Photo?, size: String) -> String {
        var photoSize: String = size
        if photoSize.isEmpty {
            photoSize = "m"
        }
        
        if let farm = photo?.farm, let server = photo?.server, let id = photo?.id, let secret = photo?.secret {
            return "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(photoSize).jpg"
        } else {
            return ""
        }
        
    }
    
    class func getGroupURL(group: Group?) -> String {
        if let server = group?.iconserver, let id = group?.nsid {
            return "http://live.staticflickr.com/\(server)/buddyicons/\(id).jpg"
        } else {
            return ""
        }
    }
}
