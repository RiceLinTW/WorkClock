//
//  File.swift
//  WorkClock
//
//  Created by Rice Lin on 5/24/25.
//

import SwiftData
import Foundation

package extension ModelContainer {
  static var live: ModelContainer {
    do {
      let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
      let config = ModelConfiguration(url: url)
      let container = try ModelContainer(for: WCJob.self, configurations: config)
      return container
    } catch {
      fatalError("Failed to create container.")
    }
  }

  static var preview: ModelContainer {
    do {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: WCJob.self, configurations: config)
      return container
    } catch {
      fatalError("Failed to create container.")
    }
  }

  static var test: ModelContainer {
    do {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: WCJob.self, configurations: config)
      return container
    } catch {
      fatalError("Failed to create container.")
    }
  }
}
