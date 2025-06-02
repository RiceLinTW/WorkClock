//
//  WCWorkLog.swift
//  WorkClock
//
//  Created by Rice Lin on 5/24/25.
//

import Foundation
import SwiftData

@Model
public final class WCWorkLog: @unchecked Sendable {
  public internal(set) var startTime: Date
  public internal(set) var endTime: Date?
  public internal(set) var createdAt: Date
  public internal(set) var updatedAt: Date?

  @Relationship(deleteRule: .nullify, inverse: \WCWorkRegion.workLogs)
  public internal(set) var workRegion: WCWorkRegion?

  public init(startTime: Date) {
    self.startTime = startTime
    self.createdAt = Date()
  }
}
