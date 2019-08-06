//
//  SearchTextTest.swift
//  FlickrTests
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Flickr
class SearchTextTest: QuickSpec {

    let text = "Testing Text"
    let emptyText = ""
    
    override func spec() {
        let validator = Validator()
        describe("Search Text field value") {
            context("Get photos according to text") {
                it("text field must have a value") {
                    expect(validator.validateSearchText(text: self.text)).to(equal(true))
                }
            }
            context("Show message to user to enter a valid text") {
                it("text field is empty") {
                    expect(validator.validateSearchText(text: self.emptyText)).to(equal(false))
                }
            }
        }
    }
    
}
