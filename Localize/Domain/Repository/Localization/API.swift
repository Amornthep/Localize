//  This file was automatically generated and should not be edited.

import Apollo

public final class GetProductQuery: GraphQLQuery {
  public let operationDefinition =
    "query getProduct($name: String!, $desc: String!, $price: Int!, $image: String!) {\n  createProduct(name: $name, desc: $desc, price: $price, image: $image) {\n    __typename\n    id\n    name\n  }\n}"

  public var name: String
  public var desc: String
  public var price: Int
  public var image: String

  public init(name: String, desc: String, price: Int, image: String) {
    self.name = name
    self.desc = desc
    self.price = price
    self.image = image
  }

  public var variables: GraphQLMap? {
    return ["name": name, "desc": desc, "price": price, "image": image]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createProduct", arguments: ["name": GraphQLVariable("name"), "desc": GraphQLVariable("desc"), "price": GraphQLVariable("price"), "image": GraphQLVariable("image")], type: .object(CreateProduct.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createProduct: CreateProduct? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "createProduct": createProduct.flatMap { (value: CreateProduct) -> ResultMap in value.resultMap }])
    }

    public var createProduct: CreateProduct? {
      get {
        return (resultMap["createProduct"] as? ResultMap).flatMap { CreateProduct(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createProduct")
      }
    }

    public struct CreateProduct: GraphQLSelectionSet {
      public static let possibleTypes = ["Product"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(String.self)),
        GraphQLField("name", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String? = nil, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Product", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String? {
        get {
          return resultMap["id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}