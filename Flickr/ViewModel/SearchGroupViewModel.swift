//
//  SearchGroupViewModel.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import Foundation
import os.log

final class SearchGroupViewModel {
    var iconURLs = [String]()
    var groupName = [String]()
    var page = 1
    var pageNumber: Int {
        if page == 1 {
            return 1
        } else {
            return page
        }
    }
    
    func getNextPage(searchText: String, completion: @escaping ([String],[String], Double) -> Void) {
        os_log("Network Request", log: OSLog.network, type: .info)
        page += 1
        getGroupsList(searchText: searchText,pageNo: page, success: { (photosList,iconsURLs, photosCount) in
            completion(photosList,iconsURLs, photosCount)
        }) { (error) in
            os_log("Failed request", log: OSLog.data, type: .error)
        }
    }
    
    func getGroupsList(searchText: String,pageNo: Int = 1, success: @escaping ([String],[String], Double) -> Void, failure: @escaping (Error) -> Void) {
        SearchNetworkRequest().request(searchMethod: .groups, searchText: searchText, pageNo: pageNo, success: { (response) in
            print(response)
            let myResposnse = response["groups"] as! [String: Any]
            let allGroups = myResposnse["group"] as! [Any]
            let totalGroups = (myResposnse["total"] as! NSString).doubleValue
            for group in allGroups {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: group, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let group = try jsonDecoder.decode(Group.self, from: data!)
                    self.iconURLs.append(Helper.getGroupURL(group: group))
                    self.groupName.append(group.name ?? "")
                }
                catch {
                    print(error)
                }
            }
            success(self.groupName,self.iconURLs, totalGroups)
        }, failure: { error in
            os_log("Failed request", log: OSLog.data, type: .error)
            failure(error)
        })
        os_log("Network Request", log: OSLog.network, type: .info)
        os_log("Request parameters: %{SearchText}@ ", log: OSLog.network, searchText)
    }
    
}
