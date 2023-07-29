import XCTest
import Combine
@testable import VideoPlaylistExercise

class VideoDaoTest: XCTestCase {

  private var persistentStore: MockPersistenceStore!
  private var cancellables: Set<AnyCancellable> = []

  private var sut: VideoDao!

  override func setUp() {
    persistentStore = MockPersistenceStore()
    sut = VideoDaoImpl(persistentStore: persistentStore)
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testInsertAndFetchDataSuccess() {
    let expectedVideos = [
      createVideo(id: 1),
      createVideo(id: 2),
      createVideo(id: 3)
    ]
    let exp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    sut
      .insertOrReplace(expectedVideos)
      .flatMap { _ -> AnyPublisher<[Video], Error> in
        return self.sut.fetch()
      }
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { value in
          actualResult = value
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)

    XCTAssertEqual(expectedVideos, actualResult)
  }

  func testInsertAndDeleteAllSuccess() {
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    let exp = XCTestExpectation(description: #function)

    sut
      .insertOrReplace(expectedVideos)
      .flatMap { _ -> AnyPublisher<[Video], Error> in
        return self.sut.fetch()
      }
      .flatMap { videos -> AnyPublisher<Void, Error> in
        XCTAssertFalse(videos.isEmpty)
        return self.sut.deleteAll()
      }
      .flatMap { _ -> AnyPublisher<[Video], Error> in
        return self.sut.fetch()
      }
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { value in
          XCTAssertTrue(value.isEmpty)
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }

  func testFindByItemSuccess() {
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    let exp = XCTestExpectation(description: #function)

    sut
      .insertOrReplace(expectedVideos)
      .flatMap { _ -> AnyPublisher<VideoENT?, Never> in
        return self.sut.findByItemTaskPublisher(expectedVideos.last!.id, expectedVideos.last!.title)
      }
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { value in
          XCTAssertNotNil(value)
          XCTAssertEqual(expectedVideos.last, value?.toVideo())
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }

  func testInsertDuplicateIdItemsWithSameTitlesShouldUpdateDataAndNotInsertNewData() {
    let expectedVideos = [
      createVideo(id: 1),
      createVideo(id: 2, title: "A", description: "old description"),
      createVideo(id: 2, title: "A", description: "new description")
    ]
    let exp = XCTestExpectation(description: #function)

    sut
      .insertOrReplace(expectedVideos)
      .flatMap { _ -> AnyPublisher<[Video], Error> in
        return self.sut.fetch()
      }
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { value in
          XCTAssertEqual(expectedVideos.first, value.first)
          XCTAssertEqual(expectedVideos[1], value[1])
          XCTAssertEqual(value.count, 2)
          XCTAssertEqual(value[1].description, expectedVideos[2].description)
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }
}
