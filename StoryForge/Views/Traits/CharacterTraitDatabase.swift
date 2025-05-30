//
//  CharacterTraitDatabase.swift
//  StoryForge
//
//  Created by Steven Richter on 5/29/25.
//

// MARK: - Trait Data
struct CharacterTraitDatabase {
    static let categories: [CharacterTraitCategory] = [
        // Physical Traits
        CharacterTraitCategory(
            name: "Physical Build",
            icon: "figure.stand",
            description: "Body type and physical presence",
            traits: [
                CharacterTrait(name: "Athletic", description: "Well-built and physically capable", category: "Physical Build"),
                CharacterTrait(name: "Slender", description: "Thin and graceful build", category: "Physical Build"),
                CharacterTrait(name: "Stocky", description: "Short and solidly built", category: "Physical Build"),
                CharacterTrait(name: "Imposing", description: "Large and intimidating presence", category: "Physical Build"),
                CharacterTrait(name: "Petite", description: "Small and delicate frame", category: "Physical Build"),
                CharacterTrait(name: "Average", description: "Unremarkable build", category: "Physical Build"),
                CharacterTrait(name: "Lean", description: "Thin but strong", category: "Physical Build"),
                CharacterTrait(name: "Heavyset", description: "Large and heavy build", category: "Physical Build"),
                CharacterTrait(name: "Wiry", description: "Thin but surprisingly strong", category: "Physical Build"),
                CharacterTrait(name: "Fragile", description: "Delicate and easily broken", category: "Physical Build")
            ],
            allowsMultiple: false,
            isRequired: false
        ),
        
        // Personality Core
        CharacterTraitCategory(
            name: "Core Personality",
            icon: "brain",
            description: "Fundamental personality traits",
            traits: [
                CharacterTrait(name: "Optimistic", description: "Sees the bright side of life", category: "Core Personality"),
                CharacterTrait(name: "Pessimistic", description: "Expects the worst", category: "Core Personality"),
                CharacterTrait(name: "Pragmatic", description: "Practical and realistic", category: "Core Personality"),
                CharacterTrait(name: "Idealistic", description: "Driven by high ideals", category: "Core Personality"),
                CharacterTrait(name: "Cynical", description: "Distrusts others' motives", category: "Core Personality"),
                CharacterTrait(name: "Naive", description: "Innocent and trusting", category: "Core Personality"),
                CharacterTrait(name: "Stoic", description: "Emotionally controlled", category: "Core Personality"),
                CharacterTrait(name: "Passionate", description: "Intensely emotional", category: "Core Personality"),
                CharacterTrait(name: "Analytical", description: "Logical and methodical", category: "Core Personality"),
                CharacterTrait(name: "Intuitive", description: "Relies on gut feelings", category: "Core Personality"),
                CharacterTrait(name: "Ambitious", description: "Driven to achieve", category: "Core Personality"),
                CharacterTrait(name: "Content", description: "Satisfied with their lot", category: "Core Personality")
            ],
            allowsMultiple: true,
            isRequired: true
        ),
        
        // Social Style
        CharacterTraitCategory(
            name: "Social Style",
            icon: "person.3",
            description: "How they interact with others",
            traits: [
                CharacterTrait(name: "Charismatic", description: "Naturally attractive personality", category: "Social Style"),
                CharacterTrait(name: "Reserved", description: "Quiet and private", category: "Social Style"),
                CharacterTrait(name: "Outgoing", description: "Sociable and extroverted", category: "Social Style"),
                CharacterTrait(name: "Awkward", description: "Uncomfortable in social situations", category: "Social Style"),
                CharacterTrait(name: "Diplomatic", description: "Tactful and peace-making", category: "Social Style"),
                CharacterTrait(name: "Blunt", description: "Direct and honest to a fault", category: "Social Style"),
                CharacterTrait(name: "Manipulative", description: "Controls others for gain", category: "Social Style"),
                CharacterTrait(name: "Empathetic", description: "Deeply understands others' feelings", category: "Social Style"),
                CharacterTrait(name: "Aloof", description: "Emotionally distant", category: "Social Style"),
                CharacterTrait(name: "Gregarious", description: "Loves being around people", category: "Social Style"),
                CharacterTrait(name: "Solitary", description: "Prefers being alone", category: "Social Style"),
                CharacterTrait(name: "Charming", description: "Wins people over easily", category: "Social Style")
            ],
            allowsMultiple: true,
            isRequired: false
        ),
        
        // Moral Compass
        CharacterTraitCategory(
            name: "Moral Alignment",
            icon: "scale.3d",
            description: "Ethical and moral tendencies",
            traits: [
                CharacterTrait(name: "Lawful", description: "Follows rules and order", category: "Moral Alignment"),
                CharacterTrait(name: "Chaotic", description: "Values freedom over order", category: "Moral Alignment"),
                CharacterTrait(name: "Honorable", description: "Strong code of ethics", category: "Moral Alignment"),
                CharacterTrait(name: "Ruthless", description: "Will do anything to succeed", category: "Moral Alignment"),
                CharacterTrait(name: "Compassionate", description: "Cares deeply for others", category: "Moral Alignment"),
                CharacterTrait(name: "Selfish", description: "Puts self first", category: "Moral Alignment"),
                CharacterTrait(name: "Just", description: "Believes in fairness", category: "Moral Alignment"),
                CharacterTrait(name: "Vengeful", description: "Seeks retribution", category: "Moral Alignment"),
                CharacterTrait(name: "Forgiving", description: "Quick to pardon others", category: "Moral Alignment"),
                CharacterTrait(name: "Neutral", description: "Avoids moral extremes", category: "Moral Alignment"),
                CharacterTrait(name: "Protective", description: "Defends the innocent", category: "Moral Alignment"),
                CharacterTrait(name: "Corrupt", description: "Morally compromised", category: "Moral Alignment")
            ],
            allowsMultiple: true,
            isRequired: false
        ),
        
        // Skills & Talents
        CharacterTraitCategory(
            name: "Notable Skills",
            icon: "star.circle",
            description: "Special abilities and talents",
            traits: [
                CharacterTrait(name: "Combat Master", description: "Exceptional fighting skills", category: "Notable Skills"),
                CharacterTrait(name: "Silver Tongue", description: "Persuasive speaker", category: "Notable Skills"),
                CharacterTrait(name: "Tech Savvy", description: "Great with technology", category: "Notable Skills"),
                CharacterTrait(name: "Street Smart", description: "Knows how to survive", category: "Notable Skills"),
                CharacterTrait(name: "Book Smart", description: "Highly educated", category: "Notable Skills"),
                CharacterTrait(name: "Artistic", description: "Creative and expressive", category: "Notable Skills"),
                CharacterTrait(name: "Musical", description: "Talented with instruments/voice", category: "Notable Skills"),
                CharacterTrait(name: "Athletic", description: "Physically gifted", category: "Notable Skills"),
                CharacterTrait(name: "Strategic Mind", description: "Excellent planner", category: "Notable Skills"),
                CharacterTrait(name: "Mechanical Aptitude", description: "Good with machines", category: "Notable Skills"),
                CharacterTrait(name: "Natural Leader", description: "Others follow them", category: "Notable Skills"),
                CharacterTrait(name: "Survival Expert", description: "Thrives in harsh conditions", category: "Notable Skills"),
                CharacterTrait(name: "Medical Knowledge", description: "Can heal and treat", category: "Notable Skills"),
                CharacterTrait(name: "Investigative", description: "Solves mysteries", category: "Notable Skills"),
                CharacterTrait(name: "Stealthy", description: "Moves unseen", category: "Notable Skills")
            ],
            allowsMultiple: true,
            isRequired: false
        ),
        
        // Background Elements
        CharacterTraitCategory(
            name: "Background",
            icon: "clock.arrow.circlepath",
            description: "Past experiences that shaped them",
            traits: [
                CharacterTrait(name: "War Veteran", description: "Served in combat", category: "Background"),
                CharacterTrait(name: "Orphan", description: "Lost parents young", category: "Background"),
                CharacterTrait(name: "Noble Birth", description: "Born to privilege", category: "Background"),
                CharacterTrait(name: "Street Orphan", description: "Raised on the streets", category: "Background"),
                CharacterTrait(name: "Former Criminal", description: "Has a dark past", category: "Background"),
                CharacterTrait(name: "Religious Upbringing", description: "Raised in faith", category: "Background"),
                CharacterTrait(name: "Merchant Family", description: "Grew up in trade", category: "Background"),
                CharacterTrait(name: "Academic Background", description: "Life of study", category: "Background"),
                CharacterTrait(name: "Farming Roots", description: "Rural upbringing", category: "Background"),
                CharacterTrait(name: "Military Family", description: "Tradition of service", category: "Background"),
                CharacterTrait(name: "Artistic Heritage", description: "Family of creators", category: "Background"),
                CharacterTrait(name: "Exiled", description: "Cast out from home", category: "Background"),
                CharacterTrait(name: "Enslaved", description: "Once owned by others", category: "Background"),
                CharacterTrait(name: "Adventurer", description: "Life of exploration", category: "Background"),
                CharacterTrait(name: "Sheltered", description: "Protected from the world", category: "Background")
            ],
            allowsMultiple: true,
            isRequired: false
        ),
        
        // Quirks & Flaws
        CharacterTraitCategory(
            name: "Quirks & Flaws",
            icon: "sparkles",
            description: "Unique characteristics and weaknesses",
            traits: [
                CharacterTrait(name: "Superstitious", description: "Believes in omens", category: "Quirks & Flaws"),
                CharacterTrait(name: "Phobia", description: "Irrational fear", category: "Quirks & Flaws"),
                CharacterTrait(name: "Addiction", description: "Dependent on something", category: "Quirks & Flaws"),
                CharacterTrait(name: "Compulsive Liar", description: "Can't tell the truth", category: "Quirks & Flaws"),
                CharacterTrait(name: "Kleptomaniac", description: "Compulsive thief", category: "Quirks & Flaws"),
                CharacterTrait(name: "Amnesia", description: "Lost memories", category: "Quirks & Flaws"),
                CharacterTrait(name: "Chronic Illness", description: "Ongoing health issue", category: "Quirks & Flaws"),
                CharacterTrait(name: "Bad Luck", description: "Things go wrong", category: "Quirks & Flaws"),
                CharacterTrait(name: "Obsessive", description: "Fixates on things", category: "Quirks & Flaws"),
                CharacterTrait(name: "Paranoid", description: "Sees threats everywhere", category: "Quirks & Flaws"),
                CharacterTrait(name: "Insomniac", description: "Can't sleep well", category: "Quirks & Flaws"),
                CharacterTrait(name: "Perfectionist", description: "Nothing is good enough", category: "Quirks & Flaws"),
                CharacterTrait(name: "Coward", description: "Afraid of danger", category: "Quirks & Flaws"),
                CharacterTrait(name: "Reckless", description: "Takes unnecessary risks", category: "Quirks & Flaws"),
                CharacterTrait(name: "Gullible", description: "Easily deceived", category: "Quirks & Flaws")
            ],
            allowsMultiple: true,
            isRequired: false
        ),
        
        // Motivations
        CharacterTraitCategory(
            name: "Core Motivation",
            icon: "flag.fill",
            description: "What drives them forward",
            traits: [
                CharacterTrait(name: "Revenge", description: "Seeking vengeance", category: "Core Motivation"),
                CharacterTrait(name: "Love", description: "Driven by romance or family", category: "Core Motivation"),
                CharacterTrait(name: "Power", description: "Wants control", category: "Core Motivation"),
                CharacterTrait(name: "Knowledge", description: "Seeks understanding", category: "Core Motivation"),
                CharacterTrait(name: "Wealth", description: "Desires riches", category: "Core Motivation"),
                CharacterTrait(name: "Fame", description: "Wants recognition", category: "Core Motivation"),
                CharacterTrait(name: "Justice", description: "Rights wrongs", category: "Core Motivation"),
                CharacterTrait(name: "Survival", description: "Just staying alive", category: "Core Motivation"),
                CharacterTrait(name: "Redemption", description: "Making amends", category: "Core Motivation"),
                CharacterTrait(name: "Discovery", description: "Finding truth", category: "Core Motivation"),
                CharacterTrait(name: "Protection", description: "Keeping others safe", category: "Core Motivation"),
                CharacterTrait(name: "Freedom", description: "Breaking chains", category: "Core Motivation"),
                CharacterTrait(name: "Legacy", description: "Being remembered", category: "Core Motivation"),
                CharacterTrait(name: "Duty", description: "Fulfilling obligations", category: "Core Motivation"),
                CharacterTrait(name: "Peace", description: "Finding tranquility", category: "Core Motivation")
            ],
            allowsMultiple: true,
            isRequired: true
        )
    ]
}
