import SwiftData
import SwiftUI
@main
struct StoryForgeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CharacterRequest.self,
            CharacterProfile.self,
            Cast.self,
            CharacterRelationship.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            let context = sharedModelContainer.mainContext
            let dataManager = DataManager(context: context)
            let characterService = CharacterService(dataManager: dataManager)
            let appState = AppState()
            
            MainTabView()
                .environmentObject(dataManager)
                .environmentObject(characterService)
                .environmentObject(appState)
        }
        .modelContainer(sharedModelContainer)
    }
}
