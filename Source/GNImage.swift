//
//  GNImage.swift
//  GNLayout
//
//  Created by Gabor Nagy on 19/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit

open class GNImage: GNLayoutDisplayEntry
{
    var imageKey:String?
    
    public init(_ id:String,
         _ image:UIImage? = nil,
         _ imageKey:String? = nil,
         _ attributes: [GNLayoutCompositionEntry]? = [],
         state:GNLayoutState? = nil
        )
    {
        // Setup keys
        self.imageKey = imageKey
        
        // Setup view
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        view.sizeToFit()
        
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
        imageKey = nil
    }
    override open func modelValue(_ model:NSObject,forKey key:String) -> Any?
    {
        if let k = imageKey
        {
            return super.modelValue(model, forKey: k)
        }
        return super.modelValue(model, forKey: key)
    }
}
