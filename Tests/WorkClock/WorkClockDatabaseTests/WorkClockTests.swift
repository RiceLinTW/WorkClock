import Testing
import CoreLocation
@testable import WorkClockDatabase

@Suite("WorkClockDatabase", .serialized)
struct WorkClockDatabaseTests {

  let database = WorkClockDatabase(modelContainer: .test)

  @Test("Add Job")
  func testAddJob() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)
    #expect(jobs[0].title == "Test Job")
    #expect(jobs[0].company.name == "Test Company")

    try await database.update(jobs[0], title: "Updated Job")
    let updatedJobs = try await database.fetchAllJobs()
    #expect(updatedJobs.count == 1)
    #expect(updatedJobs[0].title == "Updated Job")
    #expect(updatedJobs[0].company.name == "Test Company")
  }

  @Test("Fetch All Jobs")
  func testFetchAllJobs() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)
  }

  @Test("Update Job")
  func testUpdateJob() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)
    #expect(jobs[0].title == "Test Job")
    #expect(jobs[0].company.name == "Test Company")

    try await database.update(jobs[0], title: "Updated Job")
    let updatedJobs = try await database.fetchAllJobs()
    #expect(updatedJobs.count == 1)
    #expect(updatedJobs[0].title == "Updated Job")
    #expect(updatedJobs[0].company.name == "Test Company")
  }

  @Test("Delete Job")
  func testDeleteJob() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await database.delete(jobs[0])
    let deletedJobs = try await database.fetchAllJobs()
    #expect(deletedJobs.count == 0)
  }

  @Test("Add Work Region")
  func testAddWorkRegion() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)
    #expect(workRegions[0].name == "Test Work Region")
    #expect(workRegions[0].latitude == 0)
  }

  @Test("Fetch All Work Regions")
  func testFetchAllWorkRegions() async throws {
    try await addTestJob()

    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)
  }

  @Test("Update Work Region")
  func testUpdateWorkRegion() async throws {
    try await addTestJob()
    
    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)
    #expect(workRegions[0].name == "Test Work Region")
    #expect(workRegions[0].latitude == 0)

    try await database.update(workRegions[0], name: "Updated Work Region", coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1), radius: 2000, buffer: 200, color: 0xFFFFFF_FF)
    let updatedWorkRegions = try await database.fetchAllWorkRegions()
    #expect(updatedWorkRegions.count == 1)
    #expect(updatedWorkRegions[0].name == "Updated Work Region")
    #expect(updatedWorkRegions[0].latitude == 1)
    #expect(updatedWorkRegions[0].longitude == 1)
    #expect(updatedWorkRegions[0].radius == 2000)
    #expect(updatedWorkRegions[0].buffer == 200)
    #expect(updatedWorkRegions[0].color == 0xFFFFFF_FF)
  }

  @Test("Delete Work Region")
  func testDeleteWorkRegion() async throws {
    try await addTestJob()
    
    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)

    try await database.delete(workRegions[0])
    let deletedWorkRegions = try await database.fetchAllWorkRegions()
    #expect(deletedWorkRegions.count == 0)
  }

  @Test("Add Work Log")
  func testAddWorkLog() async throws {
    try await addTestJob()
    
    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)

    let startTime = Date()
    try await addTestWorkLog(for: jobs[0], at: workRegions[0], startTime: startTime)
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    let workLogs = try await database.fetchWorkLogs(for: yesterday...tomorrow)
    #expect(workLogs.count == 1)
    #expect(workLogs[0].startTime == startTime)
    #expect(workLogs[0].endTime == nil)
  }

  @Test("Update Work Log")
  func testUpdateWorkLog() async throws {
    try await addTestJob()
    
    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)

    let startTime = Date()
    try await addTestWorkLog(for: jobs[0], at: workRegions[0], startTime: startTime)
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    let workLogs = try await database.fetchWorkLogs(for: yesterday...tomorrow)
    #expect(workLogs.count == 1)
    #expect(workLogs[0].startTime == startTime)
    #expect(workLogs[0].endTime == nil)

    let endTime = Date()
    try await database.update(workLogs[0], endTime: endTime)
    let updatedWorkLogs = try await database.fetchWorkLogs(for: yesterday...tomorrow)
    #expect(updatedWorkLogs.count == 1)
    #expect(updatedWorkLogs[0].startTime == startTime)
    #expect(updatedWorkLogs[0].endTime == endTime)
  }

  @Test("Delete Work Log")
  func testDeleteWorkLog() async throws {
    try await addTestJob()
    
    let jobs = try await database.fetchAllJobs()
    #expect(jobs.count == 1)

    try await addTestWorkRegion(for: jobs[0])
    let workRegions = try await database.fetchAllWorkRegions()
    #expect(workRegions.count == 1)

    let startTime = Date()
    try await addTestWorkLog(for: jobs[0], at: workRegions[0], startTime: startTime)
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    let workLogs = try await database.fetchWorkLogs(for: yesterday...tomorrow)
    #expect(workLogs.count == 1)
    #expect(workLogs[0].startTime == startTime)
    #expect(workLogs[0].endTime == nil)

    try await database.delete(workLogs[0])
    let deletedWorkLogs = try await database.fetchWorkLogs(for: yesterday...tomorrow)
    #expect(deletedWorkLogs.count == 0)
  }

  func addTestJob() async throws {
    try await database.addJob(
      title: "Test Job",
      companyName: "Test Company"
    )
  }

  func addTestWorkRegion(for job: WCJob) async throws {
    try await database.addWorkRegion(
      for: job,
      name: "Test Work Region",
      coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
      radius: 1000,
      buffer: 100,
      color: 0x000000_FF
    )
  }

  func addTestWorkLog(for job: WCJob, at workRegion: WCWorkRegion, startTime: Date) async throws {
    try await database.addWorkLog(for: job, at: workRegion, startTime: startTime)
  }
}
