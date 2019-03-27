//
//  TableViewTest.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit
import GNLayout

class TableViewTest: UIViewController {
    var tableView: UITableView?
    var models:[TestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStates()
        for _ in 0...10
        {
            models.append(TestModel())
        }
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 500
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.view.addSubview(tableView!)
        tableView?.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "TableView Test"
    }
    override var description: String
    {
        return ""
    }
}
extension TableViewTest: UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        cell?.selectionStyle = .none
        cell?.viewRepresentation?.model = models[indexPath.row]
        cell?.contentView.setNeedsLayout()
        return cell!
    }
}
extension TableViewTest: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let t = tableView.cellForRow(at: indexPath) as? TableViewCell
        t?.contentView.backgroundColor = .orange
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut], animations: {
            t?.contentView.backgroundColor = .white
        })
        let m = t?.viewRepresentation?.model as? TestModel
        tableView.beginUpdates()
        m?.title = "Selected \(indexPath)"
        m?.text = "Mauris eu imperdiet erat, ac vestibulum orci. Vestibulum porttitor non sapien vitae accumsan."
        t?.contentView.setNeedsLayout()
        tableView.endUpdates()
    }
}
open class TableViewCell: UITableViewCell
{
    public var viewRepresentation:GNView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        _init()
    }
    private func _init()
    {
        viewRepresentation = GNView("infoBox",presentedView: self.contentView,
                                    state:GNLayoutStates.state("tableViewLayout")
            ,subviews: [
                GNImage("icon",nil,"photo"),
                GNLabel("title",
                        style: UIFont.TextStyle.title1
                ),
                GNLabel("text",
                        style: UIFont.TextStyle.body
                )
            ])
    }
}
extension TableViewTest: GNViewController
{
    func configureStates() {
        GNLayoutStates.addState(GNLayoutState("tableViewLayout",[
            ],[
            ],states:[
                GNLayoutState("title",[
                    .textColor(.darkGray)
                    ],[
                        .topMargin(10),
                        .right(10),
                        .left(130),
//                        .beforeView("text",4)
                    ]),
                GNLayoutState("icon",[
                    .cornerRadius(50),
                    ],[
//                        .topMargin(10),
//                        .bottomMargin(10),
                        .left(10),
                        .topMargin(10),
                        .width(100),
                        .height(100)
                    ]),
                GNLayoutState("text",[
                    .textColor(.darkGray)
                    ],[
                        .bottomMargin(10),
                        .afterView("title", 10),
//                        .topMargin(10),
                        .trailingMargin(10),
                        .left(130),
//                        .right(10)
                    ])
            ]))
    }
}
