//
//  CartManager.swift
//  EcommBookStore
//

import Foundation
import Combine

class CartManager: ObservableObject {
    
    @Published var cartItems: [Book] = []

    func addToCart(_ book: Book) {
        cartItems.append(book)
    }

    var itemCount: Int {
        cartItems.count
    }

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
}
