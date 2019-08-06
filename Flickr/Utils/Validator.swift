//
//  Validator.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import Foundation

final class Validator {
    func validateSearchText(text: String) -> Bool {
        if text.isEmpty {
            return false
        } else { return true }
    }
}
