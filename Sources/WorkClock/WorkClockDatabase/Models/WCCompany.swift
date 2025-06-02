//
//  WCCompany.swift
//  WorkClock
//
//  Created by Rice Lin on 5/24/25.
//

import SwiftData
import Foundation

@Model
public final class WCCompany: @unchecked Sendable {
  public internal(set) var name: String

  public internal(set) var createdAt: Date
  public internal(set) var updatedAt: Date?

  public init(name: String) {
    self.name = name

    self.createdAt = Date()
  }
}
