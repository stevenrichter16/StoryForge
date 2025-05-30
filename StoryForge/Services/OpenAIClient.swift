//
//  OpenAIClient.swift
//  StoryForge
//
//  Created by Steven Richter on 5/28/25.
//

import Foundation

/// OpenAI API client for character generation
actor OpenAIClient {
    static let shared = OpenAIClient()
    
    private var apiKey: String
    
    private init() {
        // Load API key from secure storage
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let nsDictionary = NSDictionary(contentsOfFile: path),
              let key = nsDictionary["OPENAI_API_KEY"] as? String else {
            fatalError("Missing or invalid OPENAI_API_KEY in Secrets.plist")
        }
        
        self.apiKey = key
    }
    
    func chatCompletion(
        systemPrompt: String,
        userPrompt: String,
        temperature: Double = 1.0,
        model: String = "gpt-4"
    ) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct ChatMessage: Codable {
            let role: String
            let content: String
        }
        
        struct ChatRequest: Codable {
            let model: String
            let messages: [ChatMessage]
            let temperature: Double
        }
        
        let body = ChatRequest(
            model: model,
            messages: [
                ChatMessage(role: "system", content: systemPrompt),
                ChatMessage(role: "user", content: userPrompt)
            ],
            temperature: temperature
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw APIError.invalidAPIKey
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        struct Choice: Codable {
            struct Message: Codable {
                let content: String?
            }
            let message: Message
        }
        
        struct ChatResponse: Codable {
            let choices: [Choice]
            struct Error: Codable {
                let message: String
                let type: String
            }
            let error: Error?
        }
        
        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
        
        if let error = chatResponse.error {
            throw APIError.openAIError(message: error.message, type: error.type)
        }
        
        guard let content = chatResponse.choices.first?.message.content else {
            throw APIError.noContent
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    enum APIError: LocalizedError {
        case invalidResponse
        case invalidAPIKey
        case httpError(statusCode: Int, message: String)
        case openAIError(message: String, type: String)
        case noContent
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid response from server"
            case .invalidAPIKey:
                return "Invalid API key. Please check your Secrets.plist file."
            case .httpError(let statusCode, let message):
                return "HTTP Error \(statusCode): \(message)"
            case .openAIError(let message, _):
                return "OpenAI Error: \(message)"
            case .noContent:
                return "No content in response"
            }
        }
    }
}
