//
//  BookService.swift
//  EcommBookStore
//
//  Fetches Popular and Bestseller books from the OpenLibrary Search API.
//

import Foundation

// MARK: - OpenLibrary API Response Models

private struct OLSearchResponse: Decodable {
    let docs: [OLBook]
}

private struct OLBook: Decodable {
    let key: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?
}

// MARK: - BookService

@MainActor
final class BookService: ObservableObject {

    @Published var popularBooks: [Book] = []
    @Published var bestsellerBooks: [Book] = []
    @Published var isLoadingPopular = false
    @Published var isLoadingBestsellers = false
    @Published var errorMessage: String? = nil

    private let popularURL = URL(string:
        "https://openlibrary.org/search.json?q=popular&fields=key,title,author_name,cover_i,editions&limit=20"
    )!

    private let bestsellerURL = URL(string:
        "https://openlibrary.org/search.json?q=bestseller&fields=key,title,author_name,cover_i,editions&limit=20"
    )!

    func fetchAll() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchPopular() }
            group.addTask { await self.fetchBestsellers() }
        }
    }

    private func fetchPopular() async {
        isLoadingPopular = true
        defer { isLoadingPopular = false }
        do {
            popularBooks = try await fetch(from: popularURL)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetchBestsellers() async {
        isLoadingBestsellers = true
        defer { isLoadingBestsellers = false }
        do {
            bestsellerBooks = try await fetch(from: bestsellerURL)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetch(from url: URL) async throws -> [Book] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(OLSearchResponse.self, from: data)
        return response.docs.map { olBook in
            Book(
                id: UUID(),
                title: olBook.title,
                author: olBook.author_name?.first ?? "Unknown Author",
                authorImage: "person.crop.circle.fill",
                authorGenres: [],
                authorBooksCount: 0,
                price: Double.random(in: 9.99...49.99).rounded(toPlaces: 2),
                coverColor: "indigo",
                coverEmoji: "📖",
                rating: Double.random(in: 3.5...5.0).rounded(toPlaces: 1),
                description: "No description available.",
                coverImageId: olBook.cover_i
            )
        }
    }
}

// MARK: - Helpers

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
