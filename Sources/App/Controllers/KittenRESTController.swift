//
//  KittenRESTController.swift
//  cat-controllers
//
//  Created by Louis Tur on 5/18/17.
//
//

import Foundation
import Vapor
import HTTP

final class KittenRESTController: ResourceRepresentable {
  
  func makeResource() -> Resource<Kitten> {
    return Resource()
  }
  
}
