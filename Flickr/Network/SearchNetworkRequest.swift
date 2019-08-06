//
//  SearchPhotoNetworkRequest.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import os.log

enum SearchTarget: String {
    case photos = "Photos"
    case groups = "Groups"
}

 class SearchNetworkRequest {
    var url = ""
    
    func request(searchMethod: SearchTarget, searchText: String, pageNo: Int ,success: @escaping ([String: Any]) -> Void, failure: @escaping (Error) -> Void) {
        switch searchMethod {
        case .groups:
            url = "https://api.flickr.com/services/rest/?method=\(Constants.groupsSearchMethod)&api_key=\(Constants.key)&text=\(searchText)&per_page=10&format=json&nojsoncallback=1&page=\(pageNo)"
        case .photos:
            url = "https://api.flickr.com/services/rest/?method=\(Constants.photoSearchMethod)&api_key=\(Constants.key)&text=\(searchText)&per_page=10&format=json&nojsoncallback=1&page=\(pageNo)"
        }
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                success(response.result.value! as! [String : Any])
                os_log("Network Request", log: OSLog.network, type: .info)
                os_log("Request parameters: %{SearchMethod}@ %{SearchText}@ ", log: OSLog.network, searchMethod.rawValue, searchText)
            }
            if response.result.isFailure {
                let error : Error = response.result.error!
                os_log("Failed request", log: OSLog.data, type: .error)
                failure(error)
            }
        }
    }
    
 }

