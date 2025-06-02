//
//  WCWorkRegion.swift
//  WorkClock
//
//  Created by Rice Lin on 5/24/25.
//

import SwiftData
import Foundation

@Model
public final class WCWorkRegion: @unchecked Sendable {
  public internal(set) var name: String
  public internal(set) var longitude: Double
  public internal(set) var latitude: Double
  public internal(set) var radius: Double
  public internal(set) var buffer: Double
  public internal(set) var color: Int // 0xRRGGBB_ff

  @Relationship(deleteRule: .nullify, inverse: \WCJob.workRegions)
  public internal(set) var job: WCJob?

  @Relationship(deleteRule: .cascade)
  public internal(set) var workLogs: [WCWorkLog] = []

  public internal(set) var createdAt: Date
  public internal(set) var updatedAt: Date?

  public init(
    name: String, longitude: Double, latitude: Double, radius: Double, buffer: Double,
    color: Int
  ) {
    self.name = name
    self.longitude = longitude
    self.latitude = latitude
    self.radius = radius
    self.buffer = buffer
    self.color = color

    self.createdAt = Date()
  }
}

