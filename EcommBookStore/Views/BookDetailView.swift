//
//  BookDetailView.swift
//  EcommBookStore
//
//  Screen 2 — Book detail with cover, rating, description, author & Add to Cart.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book

    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var addedToCart = false

    private var accentColor: Color { Color(red: 0.94, green: 0.60, blue: 0.48) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Cover
                ZStack(alignment: .topLeading) {
                    Color(.systemGray6)
                        .frame(maxWidth: .infinity)
                        .frame(height: 360)

                    BookCoverView(book: book, width: 200, height: 300, imageSize: .large)
                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)

                    // Back button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 2)
                    }
                    .padding(.top, 16)
                    .padding(.leading, 20)
                }

                // MARK: Content
                VStack(alignment: .leading, spacing: 20) {

                    // Title & Rating
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)

                        StarRatingView(rating: book.rating)
                    }

                    Divider()

                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)

                        Text(book.description)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.leading, 12)
                            .overlay(
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 3),
                                alignment: .leading
                            )
                    }

                    Divider()

                    // Author
                    HStack {
                        Text("Author")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("See All")
                            .font(.system(size: 13))
                            .foregroundColor(accentColor)
                    }

                    AuthorRowView(book: book)

                    // Spacer before button
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .safeAreaInset(edge: .bottom) {
            // MARK: Add to Cart Button
            Button {
                cartManager.addToCart(book)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    addedToCart = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    addedToCart = false
                }
            } label: {
                HStack(spacing: 10) {
                    if addedToCart {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Added to Cart!")
                            .font(.system(size: 16, weight: .semibold))
                    } else {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Add To Cart")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(addedToCart ? Color.green : accentColor)
                .cornerRadius(16)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .animation(.easeInOut(duration: 0.2), value: addedToCart)
            }
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
    }
}

// MARK: - Star Rating

private struct StarRatingView: View {
    let rating: Double
    private var accentColor: Color { Color(red: 0.94, green: 0.60, blue: 0.48) }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starImageName(for: index))
                    .font(.system(size: 14))
                    .foregroundColor(accentColor)
            }
            Text(String(format: "%.1f/5", rating))
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
    }

    private func starImageName(for index: Int) -> String {
        let filled = Double(index) <= rating
        let halfFilled = Double(index) - 0.5 <= rating && Double(index) > rating
        if filled { return "star.fill" }
        if halfFilled { return "star.leadinghalf.filled" }
        return "star"
    }
}

// MARK: - Author Row

private struct AuthorRowView: View {
    let book: Book
    private var accentColor: Color { Color(red: 0.94, green: 0.60, blue: 0.48) }

    var body: some View {
        HStack(spacing: 12) {
            // Author avatar
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                Image(systemName: book.authorImage)
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(book.author)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                HStack(spacing: 6) {
                    ForEach(book.authorGenres, id: \.self) { genre in
                        Text(genre)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                }
            }

            Spacer()

            if book.authorBooksCount > 0 {
                Text("\(book.authorBooksCount) Books")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accentColor)
            }
        }
        .padding(14)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: Book.bestsellerBooks[2])
            .environmentObject(CartManager())
    }
}
