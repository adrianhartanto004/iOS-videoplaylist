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
    let videos = Video.videoInfoMockData
    let exp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    let publishers = videos.map { video in
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

    XCTAssertEqual(videos, actualResult)
  }

  func testInsertAndDeleteAllSuccess() {
    let videos = Video.videoInfoMockData
    let exp = XCTestExpectation(description: #function)

    let publishers = videos.map { video in
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
    let videos = Video.videoInfoMockData
    let exp = XCTestExpectation(description: #function)

    let publishers = videos.map { video in
      sut.insertOrReplace(video)
    }
    Publishers.MergeMany(publishers)
    .flatMap { _ -> AnyPublisher<VideoENT?, Error> in
      return self.sut.findByItem(videos[0].id, videos[0].title)
    }
    .sink(
      receiveCompletion: { completion in
        exp.fulfill()
      },
      receiveValue: { value in
        XCTAssertNotNil(value)
        XCTAssertEqual(videos.first, value?.toVideo())
      }
    )
    .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }
}
