//
//  GNLayoutConnections.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit

public class GNLayoutConnections
{
    var left: GNLayoutConnection?
    var right: GNLayoutConnection?
    var top: GNLayoutConnection?
    var bottom: GNLayoutConnection?
    
    var leading: GNLayoutConnection?
    var trailing: GNLayoutConnection?
    
    var width: GNLayoutConnection?
    var height: GNLayoutConnection?
    
    var centerX: GNLayoutConnection?
    var centerY: GNLayoutConnection?
    
    var baseline: GNLayoutConnection?
    var lastBaseline: GNLayoutConnection?
    var firstBaseline: GNLayoutConnection?
    
    var constraints:[NSLayoutConstraint]
    {
        var a = [NSLayoutConstraint]()
        for var c in [left,right,top,bottom,leading,trailing,width,height,centerX,centerY,baseline,lastBaseline,firstBaseline]
        {
            if c != nil
            {
                _ = c?.constraintUpdate()
                a.append(c!.constraint!)
            }
        }
        return a
    }
    func removeConnections()
    {
        left = nil
        right = nil
        top = nil
        bottom = nil
        
        leading = nil
        trailing = nil
        
        width = nil
        height = nil
        
        centerX = nil
        centerY = nil
        
        baseline = nil
        lastBaseline = nil
        firstBaseline = nil
    }
}

struct GNLayoutConnection {
    var entry: GNLayoutEntry = GNLayoutEntry()
    var otherEntry: GNLayoutEntry = GNLayoutEntry()
    var multiplier: CGFloat = 1
    var relatedBy: NSLayoutConstraint.Relation = .equal
    var constant: CGFloat = 0
    {
        didSet
        {
            constraint?.constant = constant
        }
    }
    
    init(_ entry:UIView, otherEntry:UIView?, attribute: NSLayoutConstraint.Attribute? = nil, otherAttribute: NSLayoutConstraint.Attribute? = nil, attributes: [NSLayoutConstraint.Attribute]? = nil, constant: CGFloat? = 0,relatedBy: NSLayoutConstraint.Relation? = .equal, multiplier: CGFloat? = 1)
    {
        self.entry.item = entry
        self.entry.attribute = attribute!
        self.otherEntry.item = otherEntry
        if otherEntry != nil
        {
            if otherAttribute != nil
            {
                self.otherEntry.attribute = otherAttribute!
            }else{
                self.otherEntry.attribute = attribute!
            }
        }else{
            self.otherEntry.attribute = .notAnAttribute
        }

        //
        self.constant = constant!
        self.relatedBy = relatedBy!
        self.multiplier = multiplier!
        _ = constraintUpdate()
    }
    
    var constraint:NSLayoutConstraint?
    mutating func constraintUpdate() -> NSLayoutConstraint
    {
        if constraint == nil
        {
            constraint = NSLayoutConstraint(item: entry.item!, attribute: entry.attribute, relatedBy: relatedBy, toItem: otherEntry.item, attribute: otherEntry.attribute, multiplier: multiplier, constant: constant)
        }
        return constraint!
    }
}

