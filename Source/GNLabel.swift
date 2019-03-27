//
//  GNLabel.swift
//  GNLayout
//
//  Created by Gabor Nagy on 19/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit

open class GNLabel: GNLayoutDisplayEntry
{
    var textKey:String?
    
    public init(_ id:String,
         _ text:String? = nil,
         _ textKey:String? = nil,
         _ attributes: [GNLayoutCompositionEntry]? = [],
         style:UIFont.TextStyle? = .body,
         state:GNLayoutState? = nil)
    {
        // Setup keys
        self.textKey = textKey
        
        // Setup view
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.text = text
        view.font = UIFont.preferredFont(forTextStyle: style!)
        view.numberOfLines = 0
        view.layer.masksToBounds = false
        
        // Setup initial state
        if let s = state
        {
            super.init(id, view, s.layout!)
            self.setProperties(s.properties!)
            self.state = s
        }else{
            super.init(id, view, attributes!)
        }
    }
    deinit {
        textKey = nil
    }
    //
    override open func modelValue(_ model:NSObject,forKey key:String) -> Any?
    {
        if let k = textKey
        {
            return super.modelValue(model, forKey: k)
        }
        return super.modelValue(model, forKey: key)
    }
}
