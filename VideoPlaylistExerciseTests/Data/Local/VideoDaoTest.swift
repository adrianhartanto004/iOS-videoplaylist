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
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    let exp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    let publishers = expectedVideos.map { video in
      sut.insertOrReplace(video)
    }

    Publishers.MergeMany(publishers)
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

    let publishers = expectedVideos.map { video in
      sut.insertOrReplace(video)
    }
    Publishers.MergeMany(publishers)
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

    let publishers = expectedVideos.map { video in
      sut.insertOrReplace(video)
    }
    Publishers.MergeMany(publishers)
    .flatMap { _ -> AnyPublisher<VideoENT?, Error> in
      return self.sut.findByItem(expectedVideos.last!.id, expectedVideos.last!.title)
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
}
