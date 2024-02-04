//
//  MeasurementsUtil.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

class MeasurementsUtil {
    static func formatNumber(value: Int, factor: Double) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f",
                            dValue/factor)
        
        return string
    }
}
