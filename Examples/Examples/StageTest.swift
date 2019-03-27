//
//  StageTest.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit
import GNLayout

class StageTest: UIViewController {
    
    var viewRepresentation:GNView?
    public var model = TestModel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Stage Test"
    }
    override var description: String
    {
        return ""
    }
    
    @objc func onTap(sender:UIButton)
    {
        if let state = viewRepresentation?.state?.key, state == "stageTest_Closed"
        {
            sender.setTitle("BACK", for: .normal)
            viewRepresentation?.setState(GNLayoutStates.state("stageTest_Opened"), animated: true)
        }else{
            sender.setTitle("SHOW", for: .normal)
            viewRepresentation?.setState(GNLayoutStates.state("stageTest_Closed"), animated: true)
        }
    }
    
    override func viewDidLoad() {
        title = "Stage test"
        super.viewDidLoad()
        configureStates()
        viewRepresentation = GNView("infoBox",
                        targetView: self.view,
                        state:GNLayoutStates.state("stageTest_Closed"),
                        subviews: [
                            GNImage("icon",nil,"photo"),
                            GNButton(
                                "button", "SHOW",
                                target: (self,#selector(onTap(sender:)),.touchUpInside)
                            ),
                            GNLabel("title",
                                  style: UIFont.TextStyle.title1
                            ),
                            GNLabel("text",
                                  style: UIFont.TextStyle.body
                                )
                        ]
        )
        viewRepresentation?.model = model
    }
}
extension StageTest: GNViewController
{
    func configureStates() {
        GNLayoutStates.loadDefaults()
        GNLayoutStates.addState(GNLayoutState("stageTest_Opened",[
            .fill(.white),
            .cornerRadius(10)
            ],[
                .horizontal(5),
                .bottom(20),
                .top(100)
            ],states:[
                GNLayoutState("title",[
                    .textColor(.orange)
                    ],[
                        .top(30),
                        .centerX
                    ]),
                GNLayoutState("icon",[
                    .cornerRadius(50),
                    ],[
                        .width(100),
                        .height(100),
                        .top(0),
                        .left(20)
                    ]),
                GNLayoutState("text",[
                    .textColor(.orange)
                    ],[
                        .afterView("title",60),
                        .horizontal(20),
                    ]),
                GNLayoutState("button",[
                    .border(.white,2),
                    .cornerRadius(10),
                    .fill(.white),
                    .textColor(.orange),
                    .border(.orange,2),
                    .contentEdgeInsets(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
                    ],[
                        .centerX,
                        .bottom(10),
                    ])
            ]))

        GNLayoutStates.addState(GNLayoutState("stageTest_Closed", [
            .fill(.lightGray),
            .cornerRadius(130)
            ],[
                .centerX,
                .bottom(30)
            ],states:[
                GNLayoutState("title",[
                    .textColor(.white)
                    ],[
                        .width(0),
                        .height(0)
                    ]),
                GNLayoutState("icon",[
                    .cornerRadius(100),
                    ],[
                        .horizontal(30),
                        .vertical(30),
                        .width(200),
                        .height(200)
                    ]),
                GNLayoutState("text",[
                    .textColor(.white)
                    ],[
                        .width(0),
                        .height(0)
                    ]),
                GNLayoutState("button",[
                    .fill(.orange),
                    .border(.white,2),
                    .textColor(.white),
                    .cornerRadius(10),
                    .contentEdgeInsets(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
                    ],[
                        .centerX,
                        .bottom(30)
                    ])
            ]))
    }
}
