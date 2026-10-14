//
//  CartView.swift
//  EcommBookStore
//
//  Screen 3 — My Cart with quantity controls, promo code, totals & checkout.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var promoCode: String = ""

    private var accentColor: Color { Color(red: 0.94, green: 0.60, blue: 0.48) }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header
            ZStack {
                Text("My Cart")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider()

            if cartManager.cartItems.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "cart")
                        .font(.system(size: 44))
                        .foregroundColor(.secondary)
                    Text("Your cart is empty")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // MARK: Items
                        ForEach(cartManager.cartItems) { item in
                            CartItemRow(item: item)
                            Divider()
                        }

                        // MARK: Promo Code
                        Text("Promo Code")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.top, 24)
                            .padding(.bottom, 12)

                        HStack(spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(Color(.systemGray3))
                                TextField("Enter Code", text: $promoCode)
                                    .font(.system(size: 14))
                                    .textInputAutocapitalization(.characters)
                                    .autocorrectionDisabled()
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )

                            Button {
                                // promo code action placeholder
                            } label: {
                                Text("Apply")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .frame(width: 96, height: 48)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.primary, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.bottom, 28)

                        // MARK: Summary
                        VStack(spacing: 14) {
                            SummaryRow(title: "Subtotal", amount: cartManager.subtotal)
                            SummaryRow(title: "Delivery", amount: cartManager.deliveryFee)
                            Divider()
                            SummaryRow(title: "Total", amount: cartManager.totalPrice)
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                // checkout action placeholder
            } label: {
                Text("Proceed to Checkout")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(accentColor.opacity(cartManager.cartItems.isEmpty ? 0.4 : 1))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
            .disabled(cartManager.cartItems.isEmpty)
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
    }
}

// MARK: - Cart Item Row

private struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            BookCoverView(book: item.book, width: 72, height: 96)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.book.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(item.book.author)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Text(String(format: "$%.2f", item.book.price))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.top, 2)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing) {
                Button {
                    cartManager.remove(item)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }

                Spacer(minLength: 8)

                HStack(spacing: 10) {
                    QuantityButton(systemName: "minus", enabled: item.quantity > 1) {
                        cartManager.decrement(item)
                    }
                    Text("\(item.quantity)")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(minWidth: 18)
                    QuantityButton(systemName: "plus", enabled: true) {
                        cartManager.increment(item)
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
}

private struct QuantityButton: View {
    let systemName: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(enabled ? .primary : Color(.systemGray3))
                .frame(width: 34, height: 34)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .disabled(!enabled)
    }
}

// MARK: - Summary Row

private struct SummaryRow: View {
    let title: String
    let amount: Double

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(format: "$%.2f", amount))
        }
        .font(.system(size: 15))
        .foregroundColor(.secondary)
    }
}

#Preview {
    let cart = CartManager()
    cart.addToCart(Book.popularBooks[0])
    cart.addToCart(Book.bestsellerBooks[0])
    return NavigationStack {
        CartView()
            .environmentObject(cart)
    }
}
