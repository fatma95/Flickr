//
//  FetchPhotosTest.swift
//  FlickrTests
//
//  Created by Fatma on 8/6/19.
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Flickr

class FetchPhotosTest: QuickSpec {

    let photoViewModel = SearchPhotoViewModel()
    var list = [String]()
    var error = ""
    override func spec() {
        describe("Get response") {
            context("Get success") {
                it("text field not empty") {
                   self.photoViewModel.getPhotosList(searchText: "Test", pageNo: 1, success: { (list, count) in
                        self.list = list
                        expect(self.list.isEmpty).to(equal(false))
                    }, failure: { (error) in
                        self.error = error.localizedDescription
                    })
                }
            }
            context("Get failure") {
                it("text field empty") {
                    self.photoViewModel.getPhotosList(searchText: "", pageNo: 1, success: { (list, count) in
                        self.list = list
                    }, failure: { (error) in
                        self.error = error.localizedDescription
                        expect(self.error.isEmpty).to(equal(false))
                    })
                }
            }
        }
    }

}
