//
//  EcommerceCartTableViewController.swift
//  EcommerceApp
//
//  Created by Florian Marcu on 1/26/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class EcommerceCartTableViewController: UITableViewController {

    var cartManager: ShoppingCartManager? {
        didSet {
            NotificationCenter.default.addObserver(self, selector: #selector(didUpdateCart), name: kNotificationDidAddProductToCart, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didUpdateCart), name: kNotificationDidAClearCart, object: nil)

            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    func didPlaceOrder() {
        // This is where you need to handle the placing of an order, based on the shopping cart configuration, accessible from cartMananger local var
        // The current implementation only clears the shopping cart
        cartManager?.clearProducts()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cartManager = cartManager else {
            return 0
        }
        return cartManager.distinctProductCount() + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartManager = cartManager else {
            return UITableViewCell()
        }
        if (indexPath.row < cartManager.distinctProductCount()) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell

            cell.configureCell(item: cartManager.distinctProductItems()[indexPath.row])

            return cell
        } else if (indexPath.row == cartManager.distinctProductCount()) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTotalTableViewCell", for: indexPath) as! CartTotalTableViewCell
            cell.configureCell(total: cartManager.totalPrice())
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartPlaceOrderTableViewCell", for: indexPath) as! CartPlaceOrderTableViewCell
        cell.configureCell(cartManager: cartManager)
        cell.delegate = self
        return cell
    }

    @objc
    fileprivate func didUpdateCart(notification: Notification) {
        tableView.reloadData()
    }
}
