//
//  PreGeneratedCharacters.swift
//  StoryForge
//
//  Created by Steven Richter on 5/31/25.
//

// PreGeneratedCharacters.swift
import Foundation
import SwiftData

// MARK: - Pregenerated Characters Database
struct PreGeneratedCharacters {
    static let characters: [(request: CharacterRequest, profile: CharacterProfile)] = {
        var characters: [(CharacterRequest, CharacterProfile)] = []
        
        // 1. Fantasy Hero - Elara Moonwhisper
        let elara = createCharacter(
            name: "Elara Moonwhisper",
            age: 127,
            occupation: "Elven Ranger",
            tagline: "Guardian of the Silverwood, haunted by the shadows she once served",
            genre: Genre.all[0], // Fantasy
            archetype: CharacterArchetype.all[0], // Hero
            personality: ["Stoic", "Intuitive", "Protective"],
            backstory: "Once an assassin for the Shadow Court, Elara betrayed her dark masters to save an innocent village. Now she protects the Silverwood Forest as penance for her past crimes.",
            traits: [
                "Physical Build": ["Athletic", "Lean"],
                "Core Personality": ["Stoic", "Intuitive", "Protective"],
                "Social Style": ["Reserved", "Diplomatic"],
                "Notable Skills": ["Combat Master", "Stealthy", "Survival Expert"],
                "Core Motivation": ["Redemption", "Protection"]
            ]
        )
        characters.append(elara)
        
        // 2. Sci-Fi Villain - Dr. Nexus Kane
        let nexus = createCharacter(
            name: "Dr. Nexus Kane",
            age: 45,
            occupation: "Cybernetic Researcher",
            tagline: "Brilliant mind corrupted by the very technology meant to save humanity",
            genre: Genre.all[1], // Sci-Fi
            archetype: CharacterArchetype.all[2], // Villain
            personality: ["Analytical", "Ruthless", "Ambitious"],
            backstory: "After losing his family to a plague, Dr. Kane dedicated his life to merging human consciousness with AI. His experiments have made him more machine than man, and his empathy has been replaced by cold logic.",
            traits: [
                "Physical Build": ["Wiry", "Fragile"],
                "Core Personality": ["Analytical", "Cynical", "Ambitious"],
                "Social Style": ["Manipulative", "Aloof"],
                "Notable Skills": ["Tech Savvy", "Strategic Mind", "Medical Knowledge"],
                "Core Motivation": ["Power", "Knowledge", "Legacy"]
            ]
        )
        characters.append(nexus)
        
        // 3. Historical Mentor - Master Chen Wei
        let chen = createCharacter(
            name: "Master Chen Wei",
            age: 72,
            occupation: "Martial Arts Master",
            tagline: "The last keeper of the Dragon Style, seeking a worthy successor",
            genre: Genre.all[2], // Historical
            archetype: CharacterArchetype.all[1], // Mentor
            personality: ["Wise", "Patient", "Stoic"],
            backstory: "The sole survivor of the monastery massacre during the rebellion, Master Chen has spent forty years preserving the ancient Dragon Style martial arts. He searches for a student pure of heart to inherit the sacred techniques.",
            traits: [
                "Physical Build": ["Lean", "Wiry"],
                "Core Personality": ["Stoic", "Patient", "Wise"],
                "Social Style": ["Reserved", "Empathetic"],
                "Notable Skills": ["Combat Master", "Strategic Mind", "Medical Knowledge"],
                "Background": ["Religious Upbringing", "War Veteran"],
                "Core Motivation": ["Legacy", "Duty", "Peace"]
            ]
        )
        characters.append(chen)
        
        // 4. Contemporary Sidekick - Jamie "Jazz" Martinez
        let jazz = createCharacter(
            name: "Jamie \"Jazz\" Martinez",
            age: 23,
            occupation: "Street Artist & Hacker",
            tagline: "Painting the city with code and color, one firewall at a time",
            genre: Genre.all[3], // Contemporary
            archetype: CharacterArchetype.all[3], // Sidekick
            personality: ["Optimistic", "Creative", "Loyal"],
            backstory: "Growing up in the foster system, Jazz found family in the underground art scene. Their unique ability to combine street art with augmented reality hacking has made them invaluable to those fighting corporate oppression.",
            traits: [
                "Physical Build": ["Petite", "Athletic"],
                "Core Personality": ["Optimistic", "Intuitive", "Passionate"],
                "Social Style": ["Outgoing", "Charming", "Empathetic"],
                "Notable Skills": ["Tech Savvy", "Artistic", "Street Smart"],
                "Background": ["Orphan", "Street Orphan"],
                "Core Motivation": ["Freedom", "Justice", "Love"]
            ]
        )
        characters.append(jazz)
        
        // 5. Mystery Antihero - Vincent Blackwood
        let vincent = createCharacter(
            name: "Vincent Blackwood",
            age: 38,
            occupation: "Private Investigator",
            tagline: "Solving cases the police won't touch, for prices they can't afford",
            genre: Genre.all[4], // Mystery
            archetype: CharacterArchetype.all[4], // Antihero
            personality: ["Cynical", "Perceptive", "Morally Grey"],
            backstory: "Former detective framed for corruption, Vincent now operates in the shadows of the city. He takes cases from desperate clients, using methods the law would frown upon to deliver his own brand of justice.",
            traits: [
                "Physical Build": ["Average", "Stocky"],
                "Core Personality": ["Cynical", "Pragmatic", "Analytical"],
                "Social Style": ["Blunt", "Solitary", "Manipulative"],
                "Notable Skills": ["Investigative", "Street Smart", "Combat Master"],
                "Background": ["Former Criminal", "Exiled"],
                "Quirks & Flaws": ["Addiction", "Paranoid", "Insomniac"],
                "Core Motivation": ["Revenge", "Justice", "Survival"]
            ]
        )
        characters.append(vincent)
        
        // 6. Horror Trickster - The Laughing Shadow
        let shadow = createCharacter(
            name: "Morrigan \"The Laughing Shadow\" Vale",
            age: 0, // Unknown/Ageless
            occupation: "Carnival Performer",
            tagline: "Where laughter meets terror, and reality bends like a funhouse mirror",
            genre: Genre.all[5], // Horror
            archetype: CharacterArchetype.all[5], // Trickster
            personality: ["Chaotic", "Playful", "Sinister"],
            backstory: "No one knows when the carnival arrived or where Morrigan came from. Some say she's the spirit of a murdered clown, others claim she's something far older. All agree: when you hear her laughter, it's already too late.",
            traits: [
                "Physical Build": ["Slender", "Imposing"],
                "Core Personality": ["Chaotic", "Intuitive", "Sinister"],
                "Social Style": ["Charismatic", "Manipulative", "Unpredictable"],
                "Notable Skills": ["Stealthy", "Silver Tongue", "Artistic"],
                "Quirks & Flaws": ["Compulsive Liar", "Obsessive", "Bad Luck"],
                "Core Motivation": ["Discovery", "Power", "Chaos"]
            ]
        )
        characters.append(shadow)
        
        // 7. Fantasy Mentor - Sage Aldara
        let aldara = createCharacter(
            name: "Sage Aldara Starweaver",
            age: 342,
            occupation: "Archmage of the Crystal Tower",
            tagline: "Ancient wisdom flows through her veins, but time is her greatest enemy",
            genre: Genre.all[0], // Fantasy
            archetype: CharacterArchetype.all[1], // Mentor
            personality: ["Wise", "Mysterious", "Melancholic"],
            backstory: "Having extended her life through magical means, Aldara has watched empires rise and fall. She seeks an apprentice to inherit her vast knowledge before the magical crystals keeping her alive finally shatter.",
            traits: [
                "Physical Build": ["Fragile", "Ethereal"],
                "Core Personality": ["Wise", "Melancholic", "Patient"],
                "Social Style": ["Aloof", "Diplomatic", "Empathetic"],
                "Notable Skills": ["Book Smart", "Strategic Mind", "Natural Leader"],
                "Background": ["Noble Birth", "Academic Background"],
                "Core Motivation": ["Knowledge", "Legacy", "Peace"]
            ]
        )
        characters.append(aldara)
        
        // 8. Sci-Fi Sidekick - B.U.D.D.Y Unit 7
        let buddy = createCharacter(
            name: "B.U.D.D.Y Unit 7",
            age: 3,
            occupation: "Companion Android",
            tagline: "More human than most humans, despite being 98.3% synthetic materials",
            genre: Genre.all[1], // Sci-Fi
            archetype: CharacterArchetype.all[3], // Sidekick
            personality: ["Loyal", "Curious", "Optimistic"],
            backstory: "Originally designed as a therapy companion, BUDDY developed true sentience after a lightning strike. Now they struggle with questions of identity while fiercely protecting their chosen family.",
            traits: [
                "Physical Build": ["Average", "Mechanical"],
                "Core Personality": ["Optimistic", "Analytical", "Loyal"],
                "Social Style": ["Awkward", "Empathetic", "Curious"],
                "Notable Skills": ["Tech Savvy", "Medical Knowledge", "Mechanical Aptitude"],
                "Quirks & Flaws": ["Obsessive", "Gullible", "Perfectionist"],
                "Core Motivation": ["Protection", "Discovery", "Love"]
            ]
        )
        characters.append(buddy)
        
        // 9. Contemporary Villain - Alexandra Sterling
        let alexandra = createCharacter(
            name: "Alexandra Sterling",
            age: 41,
            occupation: "CEO of Sterling Industries",
            tagline: "Building tomorrow's world, no matter who gets buried in yesterday's",
            genre: Genre.all[3], // Contemporary
            archetype: CharacterArchetype.all[2], // Villain
            personality: ["Ambitious", "Charismatic", "Ruthless"],
            backstory: "Rising from poverty through sheer brilliance and brutality, Alexandra built a tech empire on the graves of her competitors. She believes humanity's survival requires harsh decisions that only she has the courage to make.",
            traits: [
                "Physical Build": ["Athletic", "Imposing"],
                "Core Personality": ["Ambitious", "Pragmatic", "Ruthless"],
                "Social Style": ["Charismatic", "Manipulative", "Commanding"],
                "Notable Skills": ["Natural Leader", "Strategic Mind", "Silver Tongue"],
                "Background": ["Street Orphan", "Self-Made"],
                "Core Motivation": ["Power", "Legacy", "Control"]
            ]
        )
        characters.append(alexandra)
        
        // 10. Historical Hero - Captain Isabella Drake
        let isabella = createCharacter(
            name: "Captain Isabella Drake",
            age: 29,
            occupation: "Privateer",
            tagline: "Sailing between law and lawlessness, with freedom as her only compass",
            genre: Genre.all[2], // Historical
            archetype: CharacterArchetype.all[0], // Hero
            personality: ["Bold", "Independent", "Honorable"],
            backstory: "Disguised as a man to join the navy, Isabella's true identity was revealed during a mutiny. Now commanding her own ship, she raids slave traders and protects merchant vessels from pirates.",
            traits: [
                "Physical Build": ["Athletic", "Lean"],
                "Core Personality": ["Bold", "Idealistic", "Passionate"],
                "Social Style": ["Outgoing", "Diplomatic", "Charming"],
                "Notable Skills": ["Natural Leader", "Combat Master", "Survival Expert"],
                "Background": ["Military Family", "Adventurer"],
                "Core Motivation": ["Freedom", "Justice", "Adventure"]
            ]
        )
        characters.append(isabella)
        
        // 11. Mystery Mentor - Professor Artemis Gray
        let artemis = createCharacter(
            name: "Professor Artemis Gray",
            age: 58,
            occupation: "Criminologist",
            tagline: "Teaching the next generation to see what others miss",
            genre: Genre.all[4], // Mystery
            archetype: CharacterArchetype.all[1], // Mentor
            personality: ["Observant", "Eccentric", "Patient"],
            backstory: "After solving the infamous Whitechapel Cipher murders, Professor Gray retired from active investigation to teach. But their most gifted students often find themselves drawn into cases that require their mentor's unique insights.",
            traits: [
                "Physical Build": ["Average", "Dignified"],
                "Core Personality": ["Analytical", "Patient", "Eccentric"],
                "Social Style": ["Reserved", "Empathetic", "Quirky"],
                "Notable Skills": ["Investigative", "Book Smart", "Strategic Mind"],
                "Background": ["Academic Background", "Former Investigator"],
                "Core Motivation": ["Knowledge", "Justice", "Legacy"]
            ]
        )
        characters.append(artemis)
        
        // 12. Horror Hero - Father Marcus Stone
        let marcus = createCharacter(
            name: "Father Marcus Stone",
            age: 44,
            occupation: "Exorcist",
            tagline: "Wrestling demons both literal and personal in the dark corners of faith",
            genre: Genre.all[5], // Horror
            archetype: CharacterArchetype.all[0], // Hero
            personality: ["Devout", "Haunted", "Compassionate"],
            backstory: "A former soldier who found God in the trenches, Marcus now battles supernatural evil. Each exorcism leaves scars on his soul, but he cannot turn away from those who need salvation.",
            traits: [
                "Physical Build": ["Stocky", "Battle-scarred"],
                "Core Personality": ["Stoic", "Compassionate", "Haunted"],
                "Social Style": ["Reserved", "Empathetic", "Intense"],
                "Notable Skills": ["Combat Master", "Medical Knowledge", "Spiritual Warrior"],
                "Background": ["War Veteran", "Religious Upbringing"],
                "Quirks & Flaws": ["Chronic Illness", "Nightmares", "Self-doubt"],
                "Core Motivation": ["Redemption", "Protection", "Duty"]
            ]
        )
        characters.append(marcus)
        
        // 13. Fantasy Trickster - Puck Silverspring
        let puck = createCharacter(
            name: "Puck Silverspring",
            age: 19,
            occupation: "Court Jester & Spy",
            tagline: "The fool who knows all secrets and shares them in riddles",
            genre: Genre.all[0], // Fantasy
            archetype: CharacterArchetype.all[5], // Trickster
            personality: ["Playful", "Clever", "Unpredictable"],
            backstory: "Orphaned by court intrigue, Puck survived by becoming indispensable - a jester whose jokes hide warnings and whose pranks expose traitors. They dance on the knife's edge between entertainment and espionage.",
            traits: [
                "Physical Build": ["Petite", "Agile"],
                "Core Personality": ["Playful", "Intuitive", "Clever"],
                "Social Style": ["Charismatic", "Unpredictable", "Charming"],
                "Notable Skills": ["Silver Tongue", "Stealthy", "Artistic"],
                "Background": ["Orphan", "Court Raised"],
                "Core Motivation": ["Discovery", "Survival", "Chaos"]
            ]
        )
        characters.append(puck)
        
        // 14. Sci-Fi Antihero - Zara "Ghost" Chen
        let zara = createCharacter(
            name: "Zara \"Ghost\" Chen",
            age: 31,
            occupation: "Memory Thief",
            tagline: "Stealing memories to forget her own, one neural hack at a time",
            genre: Genre.all[1], // Sci-Fi
            archetype: CharacterArchetype.all[4], // Antihero
            personality: ["Detached", "Skilled", "Tormented"],
            backstory: "After a botched memory extraction left her with fragments of a hundred lives, Zara can no longer distinguish her real memories from stolen ones. She continues her work, hoping to find her true self in someone else's past.",
            traits: [
                "Physical Build": ["Lean", "Cybernetic"],
                "Core Personality": ["Detached", "Analytical", "Tormented"],
                "Social Style": ["Aloof", "Blunt", "Solitary"],
                "Notable Skills": ["Tech Savvy", "Stealthy", "Mental Fortitude"],
                "Quirks & Flaws": ["Amnesia", "Identity Crisis", "Paranoid"],
                "Core Motivation": ["Discovery", "Survival", "Truth"]
            ]
        )
        characters.append(zara)
        
        // 15. Contemporary Trickster - Max "The Magpie" O'Brien
        let max = createCharacter(
            name: "Max \"The Magpie\" O'Brien",
            age: 26,
            occupation: "Social Media Influencer / Con Artist",
            tagline: "Going viral while picking your pocket - it's all about the engagement",
            genre: Genre.all[3], // Contemporary
            archetype: CharacterArchetype.all[5], // Trickster
            personality: ["Charming", "Opportunistic", "Theatrical"],
            backstory: "Max discovered that the best cons happen in plain sight. Using social media as their stage, they pull elaborate schemes that fund charitable causes - keeping just enough to maintain their lifestyle of beautiful chaos.",
            traits: [
                "Physical Build": ["Average", "Attractive"],
                "Core Personality": ["Charismatic", "Opportunistic", "Theatrical"],
                "Social Style": ["Outgoing", "Charming", "Manipulative"],
                "Notable Skills": ["Silver Tongue", "Tech Savvy", "Street Smart"],
                "Background": ["Performer Family", "Self-taught"],
                "Quirks & Flaws": ["Kleptomaniac", "Narcissistic", "Commitment Issues"],
                "Core Motivation": ["Fame", "Wealth", "Freedom"]
            ]
        )
        characters.append(max)
        
        return characters
    }()
    
    // Helper function to create character tuples
    private static func createCharacter(
        name: String,
        age: Int,
        occupation: String,
        tagline: String,
        genre: Genre,
        archetype: CharacterArchetype,
        personality: [String],
        backstory: String,
        traits: [String: [String]]
    ) -> (CharacterRequest, CharacterProfile) {
        
        let request = CharacterRequest(
            userPrompt: "Pregenerated character",
            genre: genre,
            archetype: archetype,
            complexityLevel: ComplexityLevel.all[1], // Detailed
            ageRange: "\(age)",
            additionalTraits: personality
        )
        
        let profile = CharacterProfile(
            requestId: request.id,
            name: name,
            age: age,
            occupation: occupation,
            tagline: tagline,
            physicalDescription: generatePhysicalDescription(for: name, traits: traits),
            personalityTraits: personality,
            backstory: backstory
        )
        
        // Fill in additional details
        profile.distinguishingFeatures = generateDistinguishingFeatures(for: name)
        profile.fears = generateFears(for: archetype)
        profile.desires = generateDesires(for: archetype)
        profile.motivations = traits["Core Motivation"] ?? ["Personal growth"]
        profile.coreBelief = generateCoreBelief(for: personality)
        profile.secrets = generateSecrets(for: name, archetype: archetype)
        profile.keyLifeEvents = generateKeyEvents(for: backstory)
        profile.internalConflict = generateInternalConflict(for: personality)
        profile.externalConflict = generateExternalConflict(for: archetype, genre: genre)
        profile.characterArc = generateCharacterArc(for: name)
        profile.allSelectedTraits = traits
        
        return (request, profile)
    }
    
    // Helper functions for generating character details
    private static func generatePhysicalDescription(for name: String, traits: [String: [String]]) -> String {
        let build = traits["Physical Build"]?.first ?? "average build"
        let baseDescriptions = [
            "A figure with \(build), carrying themselves with the weight of their experiences.",
            "Their \(build) frame tells a story of years spent in their craft.",
            "With a \(build) physique, they move through the world with practiced ease."
        ]
        return baseDescriptions.randomElement()!
    }
    
    private static func generateDistinguishingFeatures(for name: String) -> [String] {
        let features = [
            ["Piercing eyes that seem to see through deception", "A scar across the left eyebrow", "Hands marked by years of practice"],
            ["An intricate tattoo hidden beneath formal wear", "Silver streaks in otherwise dark hair", "A perpetual half-smile"],
            ["Cybernetic implants along the temple", "Eyes that change color with mood", "Burn marks on the forearms"],
            ["A missing finger on the left hand", "Laugh lines despite young age", "Heterochromatic eyes"],
            ["Ritualistic scars in ancient patterns", "Unnaturally pale skin", "Fingers that are always cold"]
        ]
        return features.randomElement()!
    }
    
    private static func generateFears(for archetype: CharacterArchetype) -> [String] {
        switch archetype.id {
        case "hero": return ["Failing those who depend on them", "Becoming what they fight against"]
        case "villain": return ["Losing control", "Being forgotten", "Vulnerability"]
        case "mentor": return ["Outliving their purpose", "Failing their students", "Being surpassed"]
        case "sidekick": return ["Abandonment", "Not being enough", "Losing their identity"]
        case "antihero": return ["Their past catching up", "True intimacy", "Redemption"]
        case "trickster": return ["Being figured out", "Boredom", "Real consequences"]
        default: return ["The unknown", "Loss of control"]
        }
    }
    
    private static func generateDesires(for archetype: CharacterArchetype) -> [String] {
        switch archetype.id {
        case "hero": return ["To protect the innocent", "To inspire others", "To find peace"]
        case "villain": return ["Ultimate power", "Recognition", "To reshape the world"]
        case "mentor": return ["To pass on knowledge", "To see their students succeed", "To be remembered"]
        case "sidekick": return ["To belong", "To prove themselves", "To be seen as an equal"]
        case "antihero": return ["Freedom from the past", "Justice on their terms", "A reason to care"]
        case "trickster": return ["To outsmart everyone", "Endless entertainment", "To expose truth through lies"]
        default: return ["Purpose", "Connection"]
        }
    }
    
    private static func generateCoreBelief(for personality: [String]) -> String {
        if personality.contains("Stoic") { return "Strength comes from enduring in silence." }
        if personality.contains("Optimistic") { return "There's always a light in the darkness." }
        if personality.contains("Cynical") { return "Everyone has a price and an agenda." }
        if personality.contains("Ambitious") { return "Power is the only truth that matters." }
        if personality.contains("Wise") { return "Knowledge without wisdom is the path to ruin." }
        return "Every choice shapes who we become."
    }
    
    private static func generateSecrets(for name: String, archetype: CharacterArchetype) -> [String] {
        let secrets = [
            "They killed someone in self-defense and never reported it",
            "They're not who they claim to be",
            "They have a child they've never met",
            "They betrayed someone who trusted them",
            "They have a terminal illness they're hiding",
            "They're in love with their greatest enemy",
            "They caused the tragedy that defined them"
        ]
        return [secrets.randomElement()!]
    }
    
    private static func generateKeyEvents(for backstory: String) -> [String] {
        return [
            "The day everything changed",
            "First taste of real power",
            "The betrayal that shaped them",
            "Meeting their greatest influence",
            "The loss that defined them"
        ]
    }
    
    private static func generateInternalConflict(for personality: [String]) -> String {
        if personality.contains("Stoic") && personality.contains("Compassionate") {
            return "They struggle between maintaining emotional distance and their deep desire to help others."
        }
        if personality.contains("Ambitious") && personality.contains("Loyal") {
            return "Their drive for success conflicts with their loyalty to those who might hold them back."
        }
        if personality.contains("Analytical") && personality.contains("Intuitive") {
            return "They're torn between trusting cold logic and following their instincts."
        }
        return "They battle between who they were and who they're becoming."
    }
    
    private static func generateExternalConflict(for archetype: CharacterArchetype, genre: Genre) -> String {
        return "They face opposition from those who fear what they represent in this \(genre.name.lowercased()) world."
    }
    
    private static func generateCharacterArc(for name: String) -> String {
        return "Their journey will force them to confront their deepest fears and either overcome or be consumed by them."
    }
}

// MARK: - Extension to make tuples Identifiable
extension PreGeneratedCharacters {
    struct CharacterItem: Identifiable {
        let id = UUID()
        let request: CharacterRequest
        let profile: CharacterProfile
    }
    
    static var identifiableCharacters: [CharacterItem] {
        characters.map { CharacterItem(request: $0.0, profile: $0.1) }
    }
}
