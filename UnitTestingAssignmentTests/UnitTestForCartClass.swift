//
//  UnitTestForCartClass.swift
//  UnitTestForCartClass
//
//  Created by Eka Kelenjeridze on 03.12.23.
//

import XCTest
@testable import UnitTestingAssignment

final class UnitTestForCartClass: XCTestCase {
    
    var cart: CartViewModel!
    
    // MARK: Test Setup
    override func setUpWithError() throws {
        cart = CartViewModel()
        cart.viewDidLoad()
    }
    
    // MARK: Test Teardown
    override func tearDownWithError() throws {
        cart = nil
    }
    
    
    func testFetchProducts() {
        let expectation = self.expectation(description: "fetchProducts")
        
        cart.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.cart.allProducts)
            XCTAssertFalse(self.cart.allProducts!.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func productsFetched() {
        if cart.allProducts == nil {
            testFetchProducts()
        }
    }
    
    func testAddProductWithID() {
        productsFetched()
        cart.addProduct(withID: 1)
        XCTAssertFalse(cart.selectedProducts.isEmpty)
        XCTAssertEqual(cart.selectedProducts.first?.id, 1)
    }
    
    func testAddProductWithID2() {
        productsFetched()
        cart.addProduct(withID: 1)
        XCTAssertEqual(cart.selectedProducts.count, 1)
        XCTAssertEqual(cart.selectedItemsQuantity, 1)
    }
    
    func testAddRandomProduct() {
        productsFetched()
        cart.addRandomProduct()
        XCTAssertEqual(cart.selectedProducts.count, 1)
    }
    
    func testRemoveProduct() {
        cart.addProduct(withID: 2)
        cart.removeProduct(withID: 2)
        XCTAssertTrue(cart.selectedProducts.isEmpty)
        XCTAssertEqual(cart.selectedItemsQuantity, 0)
    }
    
    func testRemoveProduct2() {
        cart.addProduct(withID: 2)
        cart.removeProduct(withID: 2)
        XCTAssertEqual(cart.selectedItemsQuantity, 0)
    }
    
    func testTotalPrice() {
        productsFetched()
        if let product1 = cart.allProducts?.first(where: { $0.id == 3 }) {
            product1.selectedQuantity = 1
            cart.addProduct(product: product1)
        }
        
        if let product2 = cart.allProducts?.first(where: { $0.id == 6 }) {
            product2.selectedQuantity = 1
            cart.addProduct(product: product2)
        }
        
        XCTAssertEqual(cart.totalPrice, 2998.0)
    }
    
    func testClearCart() {
        productsFetched()
        cart.addProduct(withID: 1)
        XCTAssertFalse(cart.selectedProducts.isEmpty)
    }
    
    func testClearCart2() {
        cart.clearCart()
        XCTAssertTrue(cart.selectedProducts.isEmpty)
    }
}

