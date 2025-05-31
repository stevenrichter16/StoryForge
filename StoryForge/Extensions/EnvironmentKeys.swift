//
//  EnvironmentKeys.swift
//  StoryForge
//
//  Created by Steven Richter on 5/30/25.
//

import SwiftUI

private struct CastContextKey: EnvironmentKey {
    static let defaultValue: CastContext? = nil
}

extension EnvironmentValues {
    var castContext: CastContext? {
        get { self[CastContextKey.self] }
        set { self[CastContextKey.self] = newValue }
    }
}

struct CastContext {
    let cast: Cast
    let filteredRelationships: [CharacterRelationship]
}
