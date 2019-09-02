//
//  AppEndpoints.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-24.
//  Copyright © 2018 Genetec. All rights reserved.
//

struct ListEndpoint<Entity: Decodable>: Endpoint {
    typealias RequestModel = NoModel
    typealias ResponseModel = ListResponse<Entity>

    let prefixPath = ""
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.json
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}

struct EntityEndpoint<Entity: Decodable>: Endpoint {
    typealias RequestModel = NoModel
    typealias ResponseModel = Entity

    let prefixPath = ""
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.json
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}

struct SearchEndpoint<Entity: Decodable>: Endpoint {
    typealias RequestModel = NoModel
    typealias ResponseModel = ListResponse<Entity>

    let prefixPath = ""
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.json
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}
