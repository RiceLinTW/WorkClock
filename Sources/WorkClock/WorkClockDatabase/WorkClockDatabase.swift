import CoreLocation
import Dependencies
import Foundation
import SwiftData

@ModelActor
public actor WorkClockDatabase {
  // Job
  public func addJob(title: String, companyName: String) throws {
    let company = WCCompany(name: companyName)
    let job = WCJob(title: title, company: company)
    modelContext.insert(job)
    try modelContext.save()
  }

  public func fetchAllJobs() throws -> [WCJob] {
    let descriptor: FetchDescriptor<WCJob> = .init(sortBy: [SortDescriptor(\.createdAt)])
    return try modelContext.fetch(descriptor)
  }

  public func update(_ job: WCJob, title: String? = nil, companyName: String? = nil) throws {
    if let title {
      job.title = title
    }
    if let companyName {
      job.company.name = companyName
    }
    try modelContext.save()
  }

  public func delete(_ job: WCJob) throws {
    modelContext.delete(job)
    try modelContext.save()
  }

  // Work Region
  public func addWorkRegion(
    for job: WCJob, name: String, coordinate: CLLocationCoordinate2D, radius: Double,
    buffer: Double, color: Int
  ) throws {
    let workRegion = WCWorkRegion(
      name: name, longitude: coordinate.longitude, latitude: coordinate.latitude,
      radius: radius, buffer: buffer, color: color)
    job.workRegions.append(workRegion)
    try modelContext.save()
  }

  // For MapView Display
  public func fetchAllWorkRegions() throws -> [WCWorkRegion] {
    let descriptor: FetchDescriptor<WCWorkRegion> = .init(sortBy: [SortDescriptor(\.createdAt)])
    return try modelContext.fetch(descriptor)
  }

  public func update(
    _ workRegion: WCWorkRegion, name: String? = nil, coordinate: CLLocationCoordinate2D? = nil,
    radius: Double? = nil, buffer: Double? = nil, color: Int? = nil
  ) throws {
    if let name {
      workRegion.name = name
    }
    if let coordinate {
      workRegion.longitude = coordinate.longitude
      workRegion.latitude = coordinate.latitude
    }
    if let radius {
      workRegion.radius = radius
    }
    if let buffer {
      workRegion.buffer = buffer
    }
    if let color {
      workRegion.color = color
    }
    try modelContext.save()
  }

  public func delete(_ workRegion: WCWorkRegion) throws {
    modelContext.delete(workRegion)
    try modelContext.save()
  }

  // Work Log
  public func addWorkLog(for job: WCJob, at workRegion: WCWorkRegion, startTime: Date) throws {
    let workLog = WCWorkLog(startTime: startTime)
    workRegion.workLogs.append(workLog)
    try modelContext.save()
  }

  public func update(_ workLog: WCWorkLog, startTime: Date? = nil, endTime: Date? = nil) throws {
    if let startTime {
      workLog.startTime = startTime
    }
    if let endTime {
      workLog.endTime = endTime
    }
    try modelContext.save()
  }

  public func delete(_ workLog: WCWorkLog) throws {
    modelContext.delete(workLog)
    try modelContext.save()
  }

  // Work Log
  public func fetchWorkLogs(for dateRange: ClosedRange<Date>) throws -> [WCWorkLog] {
    let descriptor: FetchDescriptor<WCWorkLog> = .init(
      predicate: #Predicate<WCWorkLog> { log in
        log.startTime >= dateRange.lowerBound && log.startTime < dateRange.upperBound
      },
      sortBy: [SortDescriptor(\.startTime)])
    return try modelContext.fetch(descriptor)
  }
}

extension WorkClockDatabase: DependencyKey {
  public static var liveValue: WorkClockDatabase {
    WorkClockDatabase(modelContainer: .live)
  }

  public static var previewValue: WorkClockDatabase {
    WorkClockDatabase(modelContainer: .preview)
  }

  public static var testValue: WorkClockDatabase {
    WorkClockDatabase(modelContainer: .test)
  }
}

public extension DependencyValues {
  var workClockDatabase: WorkClockDatabase {
    get { self[WorkClockDatabase.self] }
    set { self[WorkClockDatabase.self] = newValue }
  }
}