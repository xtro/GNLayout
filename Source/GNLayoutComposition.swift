//
//  GNLayoutCompositionEntry.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit

public enum GNLayoutCompositionEntry {
    // Center
    case center
    case centerX
    case centerY
    
    // TLBR
    case fill(_ :CGFloat)
    case horizontal(_ :CGFloat)
    case vertical(_ :CGFloat)
    
    case top(_ :CGFloat)
    case right(_ :CGFloat)
    case left(_ :CGFloat)
    case bottom(_ :CGFloat)

    case topMargin(_ :CGFloat)
    case bottomMargin(_ :CGFloat)
    case leadingMargin(_ :CGFloat)
    case trailingMargin(_ :CGFloat)
    
    case cellBottom(_ :CGFloat)
    
    // Vertical relations
    case before(_:UIView, _ :CGFloat)
    case after(_:UIView,_ :CGFloat)
    case beforeView(_:String, _ :CGFloat)
    case afterView(_:String,_ :CGFloat)
    case aboveView(_:String,_ :CGFloat)
    case behindView(_:String,_ :CGFloat)
    
    
    // Size
    case size(_ :CGFloat, _ :CGFloat)
    case width(_ :CGFloat)
    case height(_ :CGFloat)

}


public struct GNLayoutComposition
{
    var subviewDictionary:[String:GNLayoutDisplayEntry]?
    var connections:GNLayoutConnections = GNLayoutConnections()

    var entry: GNLayoutEntry = GNLayoutEntry()
    var otherEntry: GNLayoutEntry = GNLayoutEntry()
    var attribute: GNLayoutCompositionEntry = .center
    
    public init(_ entry:UIView, attribute: GNLayoutCompositionEntry? = .center, attributes: [GNLayoutCompositionEntry]? = nil, subviewDictionary:[String:GNLayoutDisplayEntry]? = nil)
    {
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        if !(entry.superview is UITableViewCell)
        {
            entry.translatesAutoresizingMaskIntoConstraints = false
        }
        self.attribute = attribute!
        self.entry.item = entry
        self.otherEntry.item = entry.superview
        //
        self.subviewDictionary = subviewDictionary
        if let a = attributes
        {
            for atr in a
            {
                addAttribute(atr)
            }
        }else{
            addAttribute(attribute!)
        }
    }
    mutating func changeAttributes(attributes:[GNLayoutCompositionEntry])
    {
        connections.removeConnections()
        for atr in attributes
        {
            addAttribute(atr)
        }
    }

    mutating func addAttribute(_ attribute: GNLayoutCompositionEntry)
    {
        guard let view = entry.item as? UIView else {
            return
        }
        guard let superview = view.superview else {
            return
        }
        switch attribute {
        case .center:
            connections.centerX = GNLayoutConnection(view, otherEntry: superview, attribute: .centerX, constant: 0)
            connections.centerY = GNLayoutConnection(view, otherEntry: superview, attribute: .centerY, constant: 0)
            break
        case .centerX:
            connections.centerX = GNLayoutConnection(view, otherEntry: superview, attribute: .centerX, constant: 0)
            break
        case .centerY:
            connections.centerY = GNLayoutConnection(view, otherEntry: superview, attribute: .centerY, constant: 0)
            break
        case let .size(width,height):
            connections.width = GNLayoutConnection(view, otherEntry: nil, attribute: .width, constant: width)
            connections.height = GNLayoutConnection(view, otherEntry: nil, attribute: .height, constant: height)
            break
        case let .width(value):
            connections.width = GNLayoutConnection(view, otherEntry: nil, attribute: .width, constant: value)
            break
        case let .height(value):
            connections.height = GNLayoutConnection(view, otherEntry: nil, attribute: .height, constant: value)
            break
        case let .fill(padding):
            connections.top = GNLayoutConnection(view, otherEntry: superview, attribute: .top, constant: padding)
            connections.bottom = GNLayoutConnection(view, otherEntry: superview, attribute: .bottom, constant: -padding)
            connections.left = GNLayoutConnection(view, otherEntry: superview, attribute: .left, constant: padding)
            connections.right = GNLayoutConnection(view, otherEntry: superview, attribute: .right, constant: -padding)
            break
        case let .vertical(padding):
            connections.top = GNLayoutConnection(view, otherEntry: superview, attribute: .top, constant: padding)
            connections.bottom = GNLayoutConnection(view, otherEntry: superview, attribute: .bottom, constant: -padding)
            break
        case let .horizontal(padding):
            connections.left = GNLayoutConnection(view, otherEntry: superview, attribute: .left, constant: padding)
            connections.right = GNLayoutConnection(view, otherEntry: superview, attribute: .right, constant: -padding)
            break
        case let .top(padding):
            connections.top = GNLayoutConnection(view, otherEntry: superview, attribute: .top, constant: padding)
            break
        case let .topMargin(padding):
            connections.top = GNLayoutConnection(view, otherEntry: superview, attribute: .topMargin, constant: padding)
            break
        case let .bottomMargin(padding):
            connections.bottom = GNLayoutConnection(view, otherEntry: superview, attribute: .bottomMargin, constant: -padding)
            break
        case let .leadingMargin(padding):
            connections.left = GNLayoutConnection(view, otherEntry: superview, attribute: .leadingMargin, constant: padding)
            break
        case let .trailingMargin(padding):
            connections.right = GNLayoutConnection(view, otherEntry: superview, attribute: .trailingMargin, constant: -padding)
            break
        case let .cellBottom(padding):
            connections.bottom = GNLayoutConnection(view, otherEntry: superview, attribute: .bottomMargin, constant: -padding, relatedBy: .greaterThanOrEqual)
            break
        case let .bottom(padding):
            connections.bottom = GNLayoutConnection(view, otherEntry: superview, attribute: .bottom, constant: -padding)
            break
        case let .left(padding):
            connections.left = GNLayoutConnection(view, otherEntry: superview, attribute: .left, constant: padding)
            break
        case let .right(padding):
            connections.right = GNLayoutConnection(view, otherEntry: superview, attribute: .right, constant: -padding)
            break
        case let .before(otherView,padding):
            connections.bottom = GNLayoutConnection(view, otherEntry: otherView, attribute: .bottom, otherAttribute: .top, constant: -padding)
            break
        case let .after(otherView,padding):
            connections.top = GNLayoutConnection(view, otherEntry: otherView, attribute: .top, otherAttribute: .bottom, constant: padding)
            break
        case let .beforeView(id,padding):
            if let otherView = subviewDictionary?[id]?.presentedView
            {
                connections.bottom = GNLayoutConnection(view, otherEntry: otherView, attribute: .bottom, otherAttribute: .top, constant: -padding)
            }
            break
        case let .afterView(id,padding):
            if let otherView = subviewDictionary?[id]?.presentedView
            {
                connections.top = GNLayoutConnection(view, otherEntry: otherView, attribute: .top, otherAttribute: .bottom, constant: padding)
            }
            break
        case let .aboveView(id,padding):
        if let otherView = subviewDictionary?[id]?.presentedView
        {
            connections.bottom = GNLayoutConnection(view, otherEntry: otherView, attribute: .leading, otherAttribute: .trailing, constant: padding)
        }
        break
        case let .behindView(id,padding):
        if let otherView = subviewDictionary?[id]?.presentedView
        {
            connections.top = GNLayoutConnection(view, otherEntry: otherView, attribute: .right, otherAttribute: .left, constant: -padding)
        }
        break
        }
    }
    var constraints:[NSLayoutConstraint]
    {
        return connections.constraints
    }
}
