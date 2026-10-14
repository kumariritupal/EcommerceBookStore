//
//  HomeView.swift
//  EcommBookStore
//
//  Screen 1 — Discover books, search, popular & bestseller horizontal lists.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartManager: CartManager
    @StateObject private var bookService = BookService()
    @State private var searchText: String = ""

    private var accentColor: Color { Color(red: 0.94, green: 0.60, blue: 0.48) }

    // Filtered books based on search
    private var filteredPopular: [Book] {
        searchText.isEmpty ? bookService.popularBooks :
            bookService.popularBooks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    private var filteredBestsellers: [Book] {
        searchText.isEmpty ? bookService.bestsellerBooks :
            bookService.bestsellerBooks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Header
                    HStack {
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                        Spacer()
                        // Cart icon with badge
                        NavigationLink(destination: CartView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "cart.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                if cartManager.itemCount > 0 {
                                    Text("\(cartManager.itemCount)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                        .background(accentColor)
                                        .clipShape(Circle())
                                        .offset(x: 6, y: -6)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    // MARK: Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Discover your\nbest books now")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .lineSpacing(2)

                        Text("Find your dream book according to your preferences\nand join to our family, What are you waiting for.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                    // MARK: Search Bar
                    HStack(spacing: 0) {
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                                .padding(.leading, 14)
                            TextField("Search for a book", text: $searchText)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        Button {
                            // filter action placeholder
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(accentColor)
                                .cornerRadius(12)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)

                    // MARK: Popular Now Section
                    SectionHeaderView(title: "Popular Now")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 14)

                    if bookService.isLoadingPopular && bookService.popularBooks.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.bottom, 32)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredPopular) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        BookCardView(book: book)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 32)
                    }

                    // MARK: Bestsellers Section
                    SectionHeaderView(title: "Bestsellers")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 14)

                    if bookService.isLoadingBestsellers && bookService.bestsellerBooks.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.bottom, 32)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredBestsellers) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        BookCardView(book: book)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 32)
                    }

                    if let errorMessage = bookService.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .task { await bookService.fetchAll() }
        }
    }
}

// MARK: - Section Header

private struct SectionHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            Text("See All")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.94, green: 0.60, blue: 0.48))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(CartManager())
}
