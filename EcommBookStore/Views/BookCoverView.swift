//
//  BookCoverView.swift
//  EcommBookStore
//
//  Reusable placeholder book cover (colored card + emoji + title).
//

import SwiftUI

struct BookCoverView: View {
    let book: Book
    let width: CGFloat
    let height: CGFloat
    var imageSize: Book.CoverSize = .medium

    private var coverBackground: Color {
        switch book.coverColor {
        case "orange":  return Color(red: 0.85, green: 0.35, blue: 0.25)
        case "teal":    return Color(red: 0.18, green: 0.52, blue: 0.52)
        case "indigo":  return Color(red: 0.24, green: 0.25, blue: 0.52)
        case "brown":   return Color(red: 0.48, green: 0.33, blue: 0.20)
        case "green":   return Color(red: 0.22, green: 0.48, blue: 0.35)
        case "purple":  return Color(red: 0.15, green: 0.18, blue: 0.35)
        default:        return Color(red: 0.4, green: 0.4, blue: 0.6)
        }
    }

    var body: some View {
        if let url = book.coverURL(size: imageSize) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    placeholder
                default:
                    ZStack {
                        Color(.systemGray5).cornerRadius(8)
                        ProgressView()
                    }
                    .frame(width: width, height: height)
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(coverBackground)
                .cornerRadius(8)

            VStack(spacing: 4) {
                Text(book.coverEmoji)
                    .font(.system(size: width * 0.30))

                Text(book.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 10)
            }
        }
        .frame(width: width, height: height)
    }
}
