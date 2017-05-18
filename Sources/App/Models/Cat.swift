//
//  Cat.swift
//  cat-api
//
//  Created by Louis Tur on 5/16/17.
//
//

import Foundation
import Vapor
import HTTP
import FluentProvider

final class Kitten: Model {
  var storage: Storage = Storage()
  var name: String
  var breed: String
  var cuteness: Int
  
  required init(row: Row) throws {
    self.name = try row.get("name")
    self.breed = try row.get("breed")
    self.cuteness = try row.get("cuteness")
  }
  
  init(name: String, breed: String, cuteness: Int) {
    self.name = name
    self.breed = breed
    self.cuteness = cuteness
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("name", name)
    try row.set("breed", breed)
    try row.set("cuteness", cuteness)
    return row
  }
}

extension Kitten: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { kittens in
      kittens.id()
      kittens.string("name")
      kittens.string("breed")
      kittens.int("cuteness")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

class Cat: NodeInitializable {
  var name: String!
  var breed: String!
  var favoriteSnack: String!
  
  required init(node: Node) throws {
    guard
      let catName = node["cat_name"]?.string,
      let catBreed = node["cat_breed"]?.string,
      let catSnack = node["cat_snack"]?.string
    else {
        throw Abort.badRequest
    }
    
    name = catName
    breed = catBreed
    favoriteSnack = catSnack
  }
  
  convenience init(name: String, breed: String, snack: String) throws {
    try self.init(node: ["cat_name":name, "cat_breed":breed, "cat_snack":snack])
  }
}

// MARK: - NodeRepresentable
extension Cat: NodeRepresentable {
  func makeNode(in context: Context?) throws -> Node {
    return try Node(node: ["cat_name": self.name,
                           "cat_breed": self.breed,
                           "cat_snack": self.favoriteSnack])
    }
}

// MARK: - JSONRepresentable
extension Cat: JSONRepresentable {
  // The JSON(node:) signature expects something that is NodeConvertible, so we dont need to do much here
  func makeJSON() throws -> JSON {
    return try JSON(node: self)
  }
}

// MARK: - ResponseRepresentable
extension Cat: ResponseRepresentable {
  func makeResponse() throws -> Response {
    return try Response(status: .ok, json: self.makeJSON())
  }
}

