//
//  Thread + Extension.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 24/07/23.
//

import Foundation

func printThread(_ description: String) {
  if Thread.isMainThread {
    print("Running \(description) on the main thread.")
  } else {
    print("Running \(description) on a background thread.")
  }
}

func printThreadName(_ description: String) {
  print("Running \(description) on Thread: \(Thread.current)")
}
