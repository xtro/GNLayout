//
//  MasterViewController.swift
//  JoynSDK
//
//  Created by Gabor Nagy on 03/02/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit
import GNLayout

class Examples: UITableViewController {

    var examples = [UIViewController]()

    override func viewDidLoad() {
        GNLayoutStates.loadDefaults()
        title = "GNLayout Examples"
        examples = [
            StageTest(),
            TableViewTest()
        ]
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = examples[indexPath.row]
        cell.textLabel!.text = object.title
        cell.detailTextLabel!.text = object.description
        cell.detailTextLabel!.numberOfLines = 0
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        example.view.backgroundColor = .white
        example.view.frame = self.view.bounds
        navigationController?.pushViewController(example, animated: true)
    }
}
