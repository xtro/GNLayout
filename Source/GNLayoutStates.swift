//
//  GNLayoutStates.swift
//  GNLayout
//
//  Created by Gabor Nagy on 20/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit

fileprivate let SEPARATOR:String = "."

public class GNLayoutStates
{
    fileprivate static var _globalStates:[String:GNLayoutState] = [:]
    public static func addState(_ state:GNLayoutState)
    {
        _globalStates[state.key] = state
    }
    public static func state(_ key:String) -> GNLayoutState?
    {
        return _globalStates[key]
    }
    public init() {
    }
    public static func loadDefaults()
    {
    }
}
