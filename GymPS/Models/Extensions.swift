//
//  Extensions.swift
//  GymPS
//
//  Created by Reza Gharooni on 06/04/2021.
//

import Foundation

//Extension to give a function to work out the sum of an array
extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
