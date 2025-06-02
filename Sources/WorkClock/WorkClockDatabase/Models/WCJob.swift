//
//  WCJob.swift
//  WorkClock
//
//  Created by Rice Lin on 5/24/25.
//

import SwiftData
import Foundation

@Model
public final class WCJob: @unchecked Sendable {
  public internal(set) var title: String

  @Relationship(deleteRule: .cascade)
  public internal(set) var company: WCCompany

  @Relationship(deleteRule: .cascade)
  public internal(set) var workRegions: [WCWorkRegion] = []

  public internal(set) var createdAt: Date
  public internal(set) var updatedAt: Date?

  public init(title: String, company: WCCompany) {
    self.title = title
    self.company = company

    self.createdAt = Date()
  }
}
