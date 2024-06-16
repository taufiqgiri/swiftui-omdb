//
//  NullableMap.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import Foundation

protocol NullableMap: Codable {
    init? (dict: [String: Any]?)
    func dictionary() -> [String: Any]?
}
