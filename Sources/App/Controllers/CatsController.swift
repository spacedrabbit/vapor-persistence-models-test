//
//  CatsController.swift
//  cat-controllers
//
//  Created by Louis Tur on 5/18/17.
//
//

import Foundation
import Vapor
import HTTP

final class CatsController {
  
  func addRoutes(drop: Droplet) {
    drop.get("", handler: version)
    drop.get("cats", handler: getAllCats)
    drop.get("cats", ":type", handler: getSomeCats)
    
    let error = drop.grouped("error")
    error.get("no-cats", handler: noCatsError)
    error.get("sleeping-cats", handler: sleepingCatsError)
  }
  
  func version(request: Request) throws -> ResponseRepresentable {
    return "Cat API v1.0"
  }
  
  func getAllCats(request: Request) throws -> ResponseRepresentable {
    return "Here are all the catssssssss"
  }
  
  func getSomeCats(request: Request) throws -> ResponseRepresentable {
    
    guard let catType = request.parameters["type"]?.string else {
      throw Abort.badRequest
    }
    
    return "Only some cats of a type here: \(catType)"
  }
  
  
  // MARK - Errors!
  func noCatsError(request: Request) throws -> ResponseRepresentable {
    throw Abort(.other(statusCode: 900, reasonPhrase: "I can guarantee:<br>NO CATS HERE!"))
  }
  
  func sleepingCatsError(request: Request) throws -> ResponseRepresentable {
    throw Abort(.other(statusCode: 901, reasonPhrase: "shhh...:<br>they're all asleep"))
  }

}
