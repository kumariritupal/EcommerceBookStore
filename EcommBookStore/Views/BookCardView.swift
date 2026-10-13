//
//  BookCardView.swift
//  EcommBookStore
//
//  Horizontal scroll card shown in Popular / Bestsellers sections.
//

import SwiftUI

struct BookCardView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            BookCoverView(book: book, width: 120, height: 160)
                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)

            Text(book.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: 120, alignment: .leading)

            Text(String(format: "$%.2f", book.price))
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
    }
}
