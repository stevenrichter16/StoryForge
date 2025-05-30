import Foundation

struct Genre: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let color: String // Store as hex string
    let worldElements: [String]
    
    static let all: [Genre] = [
        .init(
            id: "fantasy",
            name: "Fantasy",
            color: "#8B5CF6",
            worldElements: ["magic", "kingdoms", "mythical creatures", "quests"]
        ),
        .init(
            id: "scifi",
            name: "Sci-Fi",
            color: "#3B82F6",
            worldElements: ["technology", "space", "AI", "future societies"]
        ),
        .init(
            id: "historical",
            name: "Historical",
            color: "#A78BFA",
            worldElements: ["period accuracy", "social customs", "historical events"]
        ),
        .init(
            id: "contemporary",
            name: "Contemporary",
            color: "#10B981",
            worldElements: ["modern life", "current issues", "relationships"]
        ),
        .init(
            id: "mystery",
            name: "Mystery",
            color: "#6B7280",
            worldElements: ["secrets", "investigations", "clues", "revelations"]
        ),
        .init(
            id: "horror",
            name: "Horror",
            color: "#DC2626",
            worldElements: ["fear", "supernatural", "suspense", "darkness"]
        )
    ]
}
