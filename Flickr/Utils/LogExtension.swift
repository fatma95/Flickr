//
//  LogExtension.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import UIKit
import os.log

extension OSLog {
    private static var subSystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subSystem, category: "Fetch Data")
    static let data = OSLog(subsystem: subSystem, category: "Failure")
    static let cycle = OSLog(subsystem: subSystem, category: "cycle")
}
