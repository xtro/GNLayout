//
//  GNLayoutDisplayProperty.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit

public enum GNLayoutDisplayProperty {
    // View specific
    case cornerRadius(_ :CGFloat)
    case fill(_ :UIColor)
    case border(_ :UIColor,_ :CGFloat)
    
    // Control specific
    case textColor(_ :UIColor)
    case text(_ :String)
    case image(_ :UIImage)
    case contentEdgeInsets(_ :UIEdgeInsets)
    
    // Button specific
    case titleEdgeInsets(_ :UIEdgeInsets)
    case imageEdgeInsets(_ :UIEdgeInsets)

}
fileprivate var _GNLayoutDisplayEntryContext = 0

open class GNLayoutDisplayEntry: NSObject
{
    public var id:String
    public var presentedView:UIView
    internal var attributes:[GNLayoutCompositionEntry]
    internal var composition:GNLayoutComposition?
    
    public init(_ id:String, _ view:UIView, _ attributes: [GNLayoutCompositionEntry], subviews:[GNLayoutDisplayEntry]? = []) {
        self.attributes = attributes
        presentedView = view
        self.id = id
        super.init()
        updateSubviewDictionary(subviews: subviews!)
    }
    deinit {
        removeModel()
    }

    @objc public var model:Any?
    {
        willSet
        {
            removeModel()
        }
        didSet
        {
            setupModel()
        }
    }
    fileprivate func updateEntry( _ entry:GNLayoutDisplayEntry?, property:Any? = nil)
    {
        if let v = property as? String
        {
            entry?.setProperty(.text(v))
        }else if let v = property as? UIImage
        {
            entry?.setProperty(.image(v))
        }
    }
    fileprivate func setupModel()
    {
        if let anyModel = model, let d = subviewDictionary
        {
            if let m = anyModel as? [String:String]
            {
                for (key, value) in m
                {
                    updateEntry(d[key],property: value)
                }
            }else if let m = anyModel as? NSObject
            {
                for (key, view) in d
                {
                    if let value = view.modelValue(m, forKey: key)
                    {
                        updateEntry(view,property: value)
                        addObserver(self, forKeyPath: "model.\(key)", options: [.new], context: &_GNLayoutDisplayEntryContext)
                    }
               }
            }
        }
    }
    fileprivate func removeModel()
    {
        if let anyModel = model, let d = subviewDictionary
        {
            if let m = anyModel as? NSObject
            {
                for (key, view) in d
                {
                    if view.modelValue(m, forKey: key) != nil
                    {
                        removeObserver(self, forKeyPath: "model.\(key)", context: &_GNLayoutDisplayEntryContext)
                    }
                }
            }
        }
    }
    open func modelValue(_ model:NSObject,forKey key:String) -> Any?
    {
        return model.value(forKey: key)
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &_GNLayoutDisplayEntryContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        // do something upon notification of the observed object
        if let viewName = keyPath?.components(separatedBy: ".").last
        {
            if let view = subviewDictionary?[viewName]
            {
                if let v = view as? GNLabel
                {
                    if let value = change?[.newKey] as? String
                    {
                        UIView.transition(with: view.presentedView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                            v.setProperty(.text(value))
                        })
                        v.presentedView.invalidateIntrinsicContentSize()
                        v.presentedView.superview?.setNeedsLayout()
                    }
                }
            }
        }
    }
    public func createCompositionIfNeeded()
    {
        if composition == nil
        {
            composition = GNLayoutComposition(presentedView, attributes: attributes, subviewDictionary: subviewDictionary)
        }
    }
    public var connections:GNLayoutConnections?
    {
        createCompositionIfNeeded()
        return composition!.connections
    }
    public var connectionConstraints:[NSLayoutConstraint]
    {
        createCompositionIfNeeded()
        return composition!.connections.constraints
    }
    // MARK: Properties
    fileprivate var _state:GNLayoutState?
    open var state:GNLayoutState?
    {
        set(value)
        {
            setState(value, animated: false)
        }
        get
        {
            return _state
        }
    }
    open func setState(_ state:GNLayoutState?, animated:Bool? = true)
    {
        if let s = state
        {
            if let c = s.states?.count, c > 0
            {
                if let d = subviewDictionary
                {
                    for (key,subview) in d {
                        let state = s.states?.filter({ (state) -> Bool in
                            state.key == key
                        }).first
                        subview.state = state
                    }
                }
            }
            updateState(s, animated: animated)
        }
        _state = state
    }
    open func updateState(_ state:GNLayoutState, animated:Bool? = true)
    {
        if animated!
        {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.1, options: [], animations: {
                if let p = state.properties
                {
                    for property in p
                    {
                        self.setProperty(property)
                    }
                }
                self.presentedView.setNeedsLayout()
                self.changeComposition(attributes: state.layout!)
                self.presentedView.superview?.superview?.layoutIfNeeded()
                
            }) { (done) in
                
            }
        }else{
            setProperties(state.properties!)
            self.attributes = state.layout!
            changeComposition(attributes: self.attributes)
        }
    }
    public func changeComposition(attributes:[GNLayoutCompositionEntry])
    {
        if let v = presentedView.superview
        {
            v.removeConstraints(connectionConstraints)
            composition?.changeAttributes(attributes: attributes)
            v.addConstraints(connectionConstraints)
        }
    }
    // MARK: Properties
    public func setProperties(_ properties:[GNLayoutDisplayProperty])
    {
        for property in properties
        {
            setProperty(property)
        }
    }
    public func setProperty(_ property:GNLayoutDisplayProperty)
    {
        switch property {
            case let .fill(color):
                presentedView.backgroundColor = color
                break
            case let .textColor(color):
                (presentedView as? UIButton)?.setTitleColor(color, for: .normal)
                (presentedView as? UILabel)?.textColor = color
                break
            case let .text(string):
                (presentedView as? UIButton)?.setTitle(string, for: .normal)
                (presentedView as? UILabel)?.text = string
                break
            case let .image(img):
                (presentedView as? UIButton)?.setImage(img, for: .normal)
                (presentedView as? UIImageView)?.image = img
                break
            case let .cornerRadius(radius):
                presentedView.layer.cornerRadius = radius
                presentedView.layer.masksToBounds = true
                break
            case let .contentEdgeInsets(insets):
                (presentedView as? UIButton)?.contentEdgeInsets = insets
                break
            case let .imageEdgeInsets(insets):
                (presentedView as? UIButton)?.imageEdgeInsets = insets
                break
            case let .titleEdgeInsets(insets):
                (presentedView as? UIButton)?.titleEdgeInsets = insets
                break
            case let .border(color,width):
                presentedView.layer.borderColor = color.cgColor
                presentedView.layer.borderWidth = width
                break
        }
    }
    
    // MARK: Subview
    public var subviews:[GNLayoutDisplayEntry]?
    public var subviewDictionary:[String:GNLayoutDisplayEntry]?
        {
        didSet{
            composition?.subviewDictionary = subviewDictionary
        }
    }
    public func removeFromSuperview()
    {
        if let v = presentedView.superview
        {
            presentedView.removeFromSuperview()
            v.removeConstraints(connectionConstraints)
            v.layoutIfNeeded()
        }
    }
    public func addSubviews(_ subviews:[GNLayoutDisplayEntry]? = [])
    {
        addSubviewsIfNeeded()
        updateSubstates()
        addConstraintsIfNeeded()
    }
    fileprivate func updateSubviewDictionary(subviews views:[GNLayoutDisplayEntry]? = [])
    {
        if let s = views
        {
            subviews = views
            subviewDictionary = [:]
            for view in s
            {
                let id = view.id
                subviewDictionary![id] = view
                view.subviewDictionary = subviewDictionary
            }
        }
    }
    fileprivate func addSubviewsIfNeeded()
    {
        for view in subviews!
        {
            presentedView.addSubview(view.presentedView)
        }
    }
    fileprivate func updateSubstates()
    {
        state = state!
        for (key,view) in subviewDictionary!
        {
            if let state = state?.states?.filter({ (state) -> Bool in
                state.key == key
            }).first
            {
                view.state = state
            }
        }
    }
    fileprivate func addConstraintsIfNeeded()
    {
        for (_,view) in subviewDictionary!
        {
            view.subviewDictionary = subviewDictionary
            presentedView.addConstraints( view.connectionConstraints )
        }
        presentedView.superview?.layoutIfNeeded()
    }

}

public extension UIView
{
    func addViews(_ views:[GNLayoutDisplayEntry])
    {
        for view in views
        {
            addSubview(view.presentedView)
            addConstraints( view.connectionConstraints )
        }
        layoutIfNeeded()
    }
    func addView(_ view:GNLayoutDisplayEntry)
    {
        addSubview(view.presentedView)
        addConstraints( view.connectionConstraints )
        layoutIfNeeded()
    }
    func removeView(_ view:GNLayoutDisplayEntry)
    {
        view.removeFromSuperview()
    }
}
