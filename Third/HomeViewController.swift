//
//  HomeViewController.swift
//  DenTV
//
//  Created by Dmitriy Roytman on 11.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var data: NSData?
    var list: [City] = []
    var entity: Entity!
    var predicate: NSPredicate!
    var refresher: UIRefreshControl!
    
    func closure(result: [AnyObject]) {
        if let _ = result as? [City] {
            list = result as! [City]
            tableView.reloadData()
            print("result is type of [City]")
        } else {
            print("result is NOT type of [City]")
        }
        print(__FUNCTION__)
        refresher.endRefreshing()
    }
    
    
    // MARK: - IBOutlet's
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        entity = Entity(closure: closure)
        configureUI()
        if list.isEmpty { entity.refresh() }
        initRefresher()
    }
    
    // MARK: Helper
    func initRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Потяните вниз для обновления")
        refresher.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
        
    }
    
    func refreshData() {
        entity.refresh()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! DetailsViewController
        controller.city = list[sender as! Int]
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let obj = list[indexPath.row]
        cell.textLabel?.text = obj.city_name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("show", sender: indexPath.row)
    }
    
}

extension HomeViewController {
    // MARK: Helper
    func refresh() {
        tableView.reloadData()
    }
    
    func configureUI() {
        title = "Города"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
    }
}