//
//  Mockable.swift
//  VideoPlaylistExerciseTests
//
//  Created by Adrian Hartanto on 19/07/23.
//

import Foundation

protocol TestHelper: AnyObject {
  var bundle: Bundle { get }
  func decodeJSONFile<T: Decodable>(filename: String, type: T.Type) -> T
  func encodeObject<T: Encodable>(object: T) -> Data
}

extension TestHelper {
  var bundle: Bundle {
    return Bundle(for: type(of: self))
  }

  func decodeJSONFile<T: Decodable>(filename: String, type: T.Type) -> T {
    guard let path = bundle.url(forResource: filename, withExtension: "json") else {
      fatalError("Failed to load JSON file.")
    }

    do {
      let data = try Data(contentsOf: path)
      let decodedObject = try JSONDecoder().decode(T.self, from: data)

      return decodedObject
    } catch {
      print("Decode JSON failed \(error)")
      fatalError("Failed to decode JSON")
    }
  }

  func encodeObject<T: Encodable>(object: T) -> Data {
    do {
      let encodedObject = try JSONEncoder().encode(object)
      return encodedObject
    } catch {
      print("Failed to encode JSON \(error)")
      fatalError("Failed to encode JSON")
    }
  }
}
