import Foundation

struct CharacterArchetype: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let characterArchetypeDescription: String
    let prompt: String
    let icon: String
    
    static let all: [CharacterArchetype] = [
        .init(
            id: "hero",
            name: "Hero",
            characterArchetypeDescription: "The protagonist who overcomes challenges",
            prompt: "Create a heroic character who ",
            icon: "figure.walk"
        ),
        .init(
            id: "mentor",
            name: "Mentor",
            characterArchetypeDescription: "The wise guide who helps others grow",
            prompt: "Create a mentor character who ",
            icon: "person.fill.questionmark"
        ),
        .init(
            id: "villain",
            name: "Villain",
            characterArchetypeDescription: "The antagonist who opposes the hero",
            prompt: "Create a villainous character who ",
            icon: "flame"
        ),
        .init(
            id: "sidekick",
            name: "Sidekick",
            characterArchetypeDescription: "The loyal companion",
            prompt: "Create a sidekick character who ",
            icon: "figure.2"
        ),
        .init(
            id: "antihero",
            name: "Antihero",
            characterArchetypeDescription: "Flawed protagonist with questionable methods",
            prompt: "Create an antihero character who ",
            icon: "person.fill.xmark"
        ),
        .init(
            id: "trickster",
            name: "Trickster",
            characterArchetypeDescription: "The cunning character who creates chaos",
            prompt: "Create a trickster character who ",
            icon: "theatermasks"
        )
    ]
}
