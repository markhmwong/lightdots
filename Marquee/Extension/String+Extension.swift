//
//  String+Extension.swift
//  LightDots
//
//  Created by Mark Wong on 17/11/2022.
//

import Foundation

extension String {
    func trim() -> String {
          return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
