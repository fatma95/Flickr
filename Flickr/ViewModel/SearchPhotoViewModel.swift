//
//  SearchPhotoViewModel.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import Foundation
import os.log

final class SearchPhotoViewModel {
    var photosURLs = [String]()
    var page = 1
    var pageNumber: Int {
        if page == 1 {
            return 1
        } else {
            return page
        }
    }
    
    func getNextPage(searchText: String, completion: @escaping ([String], Double) -> Void) {
        page += 1
        getPhotosList(searchText: searchText,pageNo: page, success: { (photosList, photosCount) in
            completion(photosList, photosCount)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getPhotosList(searchText: String,pageNo: Int = 1, success: @escaping ([String], Double) -> Void, failure: @escaping (Error) -> Void) {
        SearchNetworkRequest().request(searchMethod: .photos, searchText: searchText, pageNo: pageNo, success: { (response) in
            let myResposnse = response["photos"] as! [String: Any]
            let allPhotos = myResposnse["photo"] as! [Any]
            let totalPhotos = (myResposnse["total"] as! NSString).doubleValue
            for photo in allPhotos {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: photo, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let photo = try jsonDecoder.decode(Photo.self, from: data!)
                    self.photosURLs.append(Helper.getPhotoURL(photo: photo, size: "m"))
                }
                catch {
                    print(error)
                }
            }
            success(self.photosURLs, totalPhotos)
        }, failure: { error in
            os_log("Failed request", log: OSLog.data, type: .error)
            failure(error)
        })
        os_log("Network Request", log: OSLog.network, type: .info)
        os_log("Request parameters: %{SearchText}@ ", log: OSLog.network, searchText)
    }
    
}
