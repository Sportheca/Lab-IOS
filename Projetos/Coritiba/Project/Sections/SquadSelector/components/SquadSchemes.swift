//
//  SquadSchemes.swift
//  
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum SquadScheme:Int {
    
    case s343 = 1
    case s352 = 2
    case s4132 = 3
    case s41212 = 4
    case s4141 = 5
    case s4222 = 6
    case s4231 = 7
    case s424 = 8
    case s433 = 9
    case s433falso9 = 10
    case s4411 = 11
    case s442 = 12
    case s451 = 13
    case s5212 = 14
    case s523 = 15
    case s532 = 16
    case s541 = 17
    
    
    func title() -> String {
        switch self {
        case .s343: return "3-4-3"
        case .s352: return "3-5-2"
        case .s4132: return "4-1-3-2"
        case .s41212: return "4-1-2-1-2"
        case .s4141: return "4-1-4-1"
        case .s4222: return "4-2-2-2"
        case .s4231: return "4-2-3-1"
        case .s424: return "4-2-4"
        case .s433: return "4-3-3"
        case .s433falso9: return "4-3-3 (falso 9)"
        case .s4411: return "4-4-1-1"
        case .s442: return "4-4-2"
        case .s451: return "4-5-1"
        case .s5212: return "5-2-1-2"
        case .s523: return "5-2-3"
        case .s532: return "5-3-2"
        case .s541: return "5-4-1"
        }
    }
    
    
    
    func positionAt(index:Int) -> CGPoint {
        switch self {
        case .s343:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.2, y: 0.25),
                3: CGPoint(x: 0.5, y: 0.25),
                4: CGPoint(x: 0.8, y: 0.25),
                5: CGPoint(x: 0.11, y: 0.5),
                6: CGPoint(x: 0.35, y: 0.5),
                7: CGPoint(x: 0.65, y: 0.5),
                8: CGPoint(x: 0.89, y: 0.5),
                9: CGPoint(x: 0.2, y: 0.75),
                10: CGPoint(x: 0.5, y: 0.8),
                11: CGPoint(x: 0.8, y: 0.75),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s352:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.2, y: 0.25),
                3: CGPoint(x: 0.5, y: 0.25),
                4: CGPoint(x: 0.8, y: 0.25),
                5: CGPoint(x: 0.11, y: 0.5),
                6: CGPoint(x: 0.35, y: 0.5),
                7: CGPoint(x: 0.65, y: 0.5),
                8: CGPoint(x: 0.89, y: 0.5),
                9: CGPoint(x: 0.32, y: 0.82),
                10: CGPoint(x: 0.5, y: 0.63),
                11: CGPoint(x: 0.68, y: 0.82),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s4132:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.5, y: 0.43),
                7: CGPoint(x: 0.2, y: 0.62),
                8: CGPoint(x: 0.5, y: 0.62),
                9: CGPoint(x: 0.8, y: 0.62),
                10: CGPoint(x: 0.32, y: 0.82),
                11: CGPoint(x: 0.68, y: 0.82),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s41212:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.5, y: 0.41),
                7: CGPoint(x: 0.25, y: 0.53),
                8: CGPoint(x: 0.5, y: 0.65),
                9: CGPoint(x: 0.75, y: 0.53),
                10: CGPoint(x: 0.32, y: 0.82),
                11: CGPoint(x: 0.68, y: 0.82),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s4141:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.5, y: 0.41),
                7: CGPoint(x: 0.11, y: 0.6),
                8: CGPoint(x: 0.35, y: 0.6),
                9: CGPoint(x: 0.65, y: 0.6),
                10: CGPoint(x: 0.89, y: 0.6),
                11: CGPoint(x: 0.5, y: 0.8),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s4222:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.33, y: 0.42),
                7: CGPoint(x: 0.67, y: 0.42),
                8: CGPoint(x: 0.22, y: 0.63),
                9: CGPoint(x: 0.78, y: 0.63),
                10: CGPoint(x: 0.33, y: 0.82),
                11: CGPoint(x: 0.67, y: 0.82),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s4231:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.33, y: 0.42),
                7: CGPoint(x: 0.67, y: 0.42),
                8: CGPoint(x: 0.22, y: 0.63),
                9: CGPoint(x: 0.5, y: 0.63),
                10: CGPoint(x: 0.78, y: 0.63),
                11: CGPoint(x: 0.5, y: 0.82),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s424:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.33, y: 0.5),
                7: CGPoint(x: 0.67, y: 0.5),
                8: CGPoint(x: 0.11, y: 0.78),
                9: CGPoint(x: 0.35, y: 0.82),
                10: CGPoint(x: 0.65, y: 0.82),
                11: CGPoint(x: 0.89, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s433:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.31, y: 0.52),
                7: CGPoint(x: 0.5, y: 0.45),
                8: CGPoint(x: 0.69, y: 0.52),
                9: CGPoint(x: 0.2, y: 0.75),
                10: CGPoint(x: 0.5, y: 0.8),
                11: CGPoint(x: 0.8, y: 0.75),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s433falso9:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.31, y: 0.52),
                7: CGPoint(x: 0.5, y: 0.45),
                8: CGPoint(x: 0.69, y: 0.52),
                9: CGPoint(x: 0.2, y: 0.75),
                10: CGPoint(x: 0.5, y: 0.71),
                11: CGPoint(x: 0.8, y: 0.75),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s4411:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.11, y: 0.5),
                7: CGPoint(x: 0.35, y: 0.5),
                8: CGPoint(x: 0.65, y: 0.5),
                9: CGPoint(x: 0.89, y: 0.5),
                10: CGPoint(x: 0.5, y: 0.62),
                11: CGPoint(x: 0.5, y: 0.8),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s442:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.11, y: 0.5),
                7: CGPoint(x: 0.35, y: 0.5),
                8: CGPoint(x: 0.65, y: 0.5),
                9: CGPoint(x: 0.89, y: 0.5),
                10: CGPoint(x: 0.32, y: 0.78),
                11: CGPoint(x: 0.68, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s451:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.35, y: 0.22),
                4: CGPoint(x: 0.65, y: 0.22),
                5: CGPoint(x: 0.89, y: 0.25),
                6: CGPoint(x: 0.11, y: 0.5),
                7: CGPoint(x: 0.33, y: 0.54),
                8: CGPoint(x: 0.5, y: 0.45),
                9: CGPoint(x: 0.67, y: 0.54),
                10: CGPoint(x: 0.89, y: 0.5),
                11: CGPoint(x: 0.5, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s5212:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.32, y: 0.22),
                4: CGPoint(x: 0.5, y: 0.18),
                5: CGPoint(x: 0.68, y: 0.22),
                6: CGPoint(x: 0.89, y: 0.25),
                7: CGPoint(x: 0.33, y: 0.44),
                8: CGPoint(x: 0.67, y: 0.44),
                9: CGPoint(x: 0.5, y: 0.62),
                10: CGPoint(x: 0.32, y: 0.78),
                11: CGPoint(x: 0.68, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s523:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.32, y: 0.22),
                4: CGPoint(x: 0.5, y: 0.18),
                5: CGPoint(x: 0.68, y: 0.22),
                6: CGPoint(x: 0.89, y: 0.25),
                7: CGPoint(x: 0.33, y: 0.44),
                8: CGPoint(x: 0.67, y: 0.44),
                9: CGPoint(x: 0.2, y: 0.73),
                10: CGPoint(x: 0.5, y: 0.78),
                11: CGPoint(x: 0.8, y: 0.73),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s532:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.32, y: 0.22),
                4: CGPoint(x: 0.5, y: 0.18),
                5: CGPoint(x: 0.68, y: 0.22),
                6: CGPoint(x: 0.89, y: 0.25),
                7: CGPoint(x: 0.2, y: 0.5),
                8: CGPoint(x: 0.5, y: 0.48),
                9: CGPoint(x: 0.8, y: 0.5),
                10: CGPoint(x: 0.33, y: 0.78),
                11: CGPoint(x: 0.67, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        case .s541:
            let positions:[Int:CGPoint] = [
                1: CGPoint(x: 0.5, y: 0.06),
                2: CGPoint(x: 0.11, y: 0.25),
                3: CGPoint(x: 0.32, y: 0.22),
                4: CGPoint(x: 0.5, y: 0.18),
                5: CGPoint(x: 0.68, y: 0.22),
                6: CGPoint(x: 0.89, y: 0.25),
                7: CGPoint(x: 0.11, y: 0.5),
                8: CGPoint(x: 0.35, y: 0.5),
                9: CGPoint(x: 0.65, y: 0.5),
                10: CGPoint(x: 0.89, y: 0.5),
                11: CGPoint(x: 0.5, y: 0.78),
            ]
            return positions[index] ?? CGPoint.zero
            
            
        }
    }
    
    
    
}
