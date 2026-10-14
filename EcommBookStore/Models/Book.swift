//
//  Book.swift
//  EcommBookStore
//

import Foundation

struct Book: Identifiable, Hashable {
    let id: UUID
    let title: String
    let author: String
    let authorImage: String
    let authorGenres: [String]
    let authorBooksCount: Int
    let price: Double
    let coverColor: String  // system color name used for placeholder cover
    let coverEmoji: String  // emoji shown on placeholder cover
    let rating: Double
    let description: String
    var coverImageId: Int? = nil  // OpenLibrary `cover_i`; nil → show placeholder cover

    enum CoverSize: String {
        case small = "S", medium = "M", large = "L"
    }

    /// https://covers.openlibrary.org/b/id/<cover_i>-<S|M|L>.jpg
    func coverURL(size: CoverSize = .medium) -> URL? {
        guard let coverImageId else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverImageId)-\(size.rawValue).jpg")
    }
}

// MARK: - Sample Data

extension Book {
    static let popularBooks: [Book] = [
        Book(
            id: UUID(),
            title: "Dracula",
            author: "Bram Stoker",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Horror", "Gothic"],
            authorBooksCount: 5,
            price: 22.00,
            coverColor: "orange",
            coverEmoji: "🦇",
            rating: 4.5,
            description: "Dracula is an 1897 Gothic horror novel by Irish author Bram Stoker. It introduced the character of Count Dracula and established many conventions of subsequent vampire fantasy. The novel tells the story of Dracula's attempt to move from Transylvania to England so that he may find new blood and spread the undead curse."
        ),
        Book(
            id: UUID(),
            title: "The Little Mermaid",
            author: "Hans Christian Andersen",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Fantasy", "Fairy Tale"],
            authorBooksCount: 8,
            price: 100.00,
            coverColor: "teal",
            coverEmoji: "🧜‍♀️",
            rating: 4.2,
            description: "The Little Mermaid is a fairy tale by the Danish author Hans Christian Andersen. The story follows a young mermaid who is willing to give up her life in the sea and her identity as a mermaid to gain a human soul and the love of a human prince."
        ),
        Book(
            id: UUID(),
            title: "A Million Miles",
            author: "Donald Miller",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Biography", "Adventure"],
            authorBooksCount: 4,
            price: 25.00,
            coverColor: "indigo",
            coverEmoji: "🌄",
            rating: 4.0,
            description: "A Million Miles in a Thousand Years is about what happens when Donald Miller edited his memoir into a movie. Guided by his editors, Donald discovered that if you want your life to make a great story, you have to go out and live a better story."
        )
    ]

    static let bestsellerBooks: [Book] = [
        Book(
            id: UUID(),
            title: "The Twelfth Child",
            author: "Bette Lee Crosby",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Fiction", "Drama"],
            authorBooksCount: 12,
            price: 18.00,
            coverColor: "brown",
            coverEmoji: "👧",
            rating: 4.7,
            description: "Bette Lee Crosby's bestselling saga about a woman who discovers a box of letters in her grandmother's attic and unravels a story of love, sacrifice, and family secrets spanning three generations."
        ),
        Book(
            id: UUID(),
            title: "In the Company of Ghosts",
            author: "Andrew Author",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Mystery", "Thriller"],
            authorBooksCount: 3,
            price: 32.00,
            coverColor: "green",
            coverEmoji: "👻",
            rating: 3.9,
            description: "A gripping mystery set in a small coastal town where a series of inexplicable events forces a retired detective to confront the ghosts of his past — both real and imagined."
        ),
        Book(
            id: UUID(),
            title: "Follow Me To The Ground",
            author: "Max James Lopez",
            authorImage: "person.crop.circle.fill",
            authorGenres: ["Science", "Fiction"],
            authorBooksCount: 3,
            price: 29.00,
            coverColor: "purple",
            coverEmoji: "🌺",
            rating: 4.0,
            description: "A weird, tender, haunted, and deeply affecting spectacle — unlike anything you will read this year. Follow Me To The Ground is a novel of fathers and daughters, of healing and harm, and of what it means to be human when the rules of the world no longer apply."
        )
    ]
}
