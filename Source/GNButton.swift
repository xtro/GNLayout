//
//  GNButton.swift
//  GNLayout
//
//  Created by Gabor Nagy on 19/01/17.
//  Copyright © 2017 Gabor Nagy. All rights reserved.
//

import UIKit

open class GNButton: GNLayoutDisplayEntry
{
    public typealias GNButtonTarget = (target: Any?, action: Selector, event: UIControl.Event)
    public typealias GNButtonTap = ((UIButton) -> Void)

    public var titleKey:String?
    public var imageKey:String?
    
    public init(_ id:String,
         _ title:String? = nil,
         _ titleKey:String? = nil,
         _ image:UIImage? = nil,
         _ imageKey:String? = nil,
         properties:[GNLayoutDisplayProperty]? = [],
         attributes: [GNLayoutCompositionEntry]? = [],
         state:GNLayoutState? = nil,
         targets:[GNButtonTarget]? = nil,
         target:GNButtonTarget? = nil,
         tap:GNButtonTap? = nil
        )
    {
        // Setup keys
        self.imageKey = imageKey
        self.titleKey = titleKey
        
        // Setup view
        let view = UIButton(type: .custom)
        view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        if let t = title
        {
            view.setTitle(t, for: .normal)
        }
        if let i = image
        {
            view.setImage(i, for: .normal)
        }
        
        // Setup initial state
        if let s = state
        {
            super.init(id, view, s.layout!)
            self.setProperties(s.properties!)
            self.state = s
        }else{
            super.init(id, view, attributes!)
            self.setProperties(properties!)
        }
        // Setup target
        if let t = target
        {
            view.addTarget(t.target, action: t.action, for: t.event)
        }else if let t = targets
        {
            for target in t {
                view.addTarget(target.target, action: target.action, for: target.event)
            }
        }
        if let t = tap
        {
            tapHandler = t
            view.addTarget(self, action: #selector(onTap(sender:)), for: .touchUpInside)
        }
    }
    fileprivate var tapHandler:GNButtonTap?
    @objc func onTap(sender:UIButton)
    {
        tapHandler?(sender)
    }
    deinit {
        titleKey = nil
        imageKey = nil
        (presentedView as? UIButton)?.removeTarget(self, action: #selector(onTap(sender:)), for: .touchUpInside)
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
