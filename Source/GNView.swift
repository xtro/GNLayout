//
//  GNView.swift
//  GNLayout
//
//  Created by Gabor Nagy on 19/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit

open class GNView: GNLayoutDisplayEntry
{
    public init(_ id:String,
         targetView:UIView? = nil,
         presentedView:UIView? = nil,
         properties:[GNLayoutDisplayProperty]? = [],
         layout: [GNLayoutCompositionEntry]? = [],
         state:GNLayoutState? = nil,
         subviews:[GNLayoutDisplayEntry]? = []
        )
    {
        // Setup view
        var view:UIView?
        if presentedView != nil
        {
            view = presentedView
        }else{
            view = UIView(frame:CGRect.zero)
            view?.isUserInteractionEnabled = true
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Setup initial state
        if let s = state
        {
            super.init(id, view!, s.layout!, subviews: subviews)
            self.setProperties(s.properties!)
            self.state = s
        }else{
            super.init(id, view!, layout!, subviews: subviews)
            self.setProperties(properties!)
        }
        
        // Add to superview
        targetView?.addView(self)
        
        // Add subviews
        addSubviews(subviews)
    }
}

public protocol GNViewController
{
    func configureStates()
}
