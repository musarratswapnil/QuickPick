//
//  LivePollsWidgetAttributes.swift
//  QuickPick
//
//  Created by Nahian Zarif on 3/1/25.
//

import ActivityKit
import Foundation

struct LivePollsWidgetAttributes: ActivityAttributes {
    
    typealias ContentState = Poll

    public var pollId: String
    init(pollId: String) {
        self.pollId = pollId
    }
}
