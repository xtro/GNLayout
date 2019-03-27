//
//  GNLayoutState.swift
//  GNLayout
//
//  Created by Gabor Nagy on 19/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import Foundation

public class GNLayoutState: NSObject
{
    public var key:String
    public var properties:[GNLayoutDisplayProperty]?
    public var layout: [GNLayoutCompositionEntry]?
    public var states: [GNLayoutState]?
    
    public init(_ key:String, _ properties: [GNLayoutDisplayProperty]? = nil, _ layout: [GNLayoutCompositionEntry]? = nil, states: [GNLayoutState]? = nil) {
        self.key = key
        self.properties = properties
        self.layout = layout
        self.states = states
    }
}
