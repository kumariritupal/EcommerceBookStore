//
//  CartManager.swift
//  EcommBookStore
//

import Foundation
import Combine

struct CartItem: Identifiable {
    let book: Book
    var quantity: Int

    var id: UUID { book.id }
    var lineTotal: Double { book.price * Double(quantity) }
}

class CartManager: ObservableObject {

    static let deliveryFee: Double = 5.00

    @Published var cartItems: [CartItem] = []

    func addToCart(_ book: Book) {
        if let index = cartItems.firstIndex(where: { $0.id == book.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(book: book, quantity: 1))
        }
    }

    func increment(_ item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        cartItems[index].quantity += 1
    }

    func decrement(_ item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }),
              cartItems[index].quantity > 1 else { return }
        cartItems[index].quantity -= 1
    }

    func remove(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }

    /// Total number of books (sum of quantities), used for the cart badge.
    var itemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double {
        cartItems.reduce(0) { $0 + $1.lineTotal }
    }

    var deliveryFee: Double {
        cartItems.isEmpty ? 0 : Self.deliveryFee
    }

    var totalPrice: Double {
        subtotal + deliveryFee
    }
}
