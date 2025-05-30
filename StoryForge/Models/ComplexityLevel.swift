//
//  ComplexityLevel.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import Foundation

struct ComplexityLevel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let complexityDescription: String
    let temperature: Double
    
    static let all: [ComplexityLevel] = [
        .init(
            id: "simple",
            name: "Simple",
            complexityDescription: "Basic character outline",
            temperature: 0.7
        ),
        .init(
            id: "detailed",
            name: "Detailed",
            complexityDescription: "Rich character with depth",
            temperature: 1.0
        ),
        .init(
            id: "complex",
            name: "Complex",
            complexityDescription: "Intricate character with nuanced layers",
            temperature: 1.2
        )
    ]
}
