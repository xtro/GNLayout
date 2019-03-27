//
//  TestModel.swift
//  GNLayout
//
//  Created by Gabor Nagy on 21/11/16.
//  Copyright © 2016 Gabor Nagy. All rights reserved.
//

import UIKit
import GNLayout

class TestModel: NSObject {
    @objc dynamic var photo:UIImage = UIImage(named: "user")!
    @objc dynamic var title:String = "Lorem Ipsum"
    @objc dynamic var text:String = "Vestibulum in iaculis enim, a rhoncus enim. Nulla facilisi. Donec sed odio velit. Duis aliquam convallis volutpat. Ut ornare pulvinar tincidunt. Sed eleifend odio vel sem ullamcorper ultricies. Nam mollis placerat velit, et malesuada libero ultrices vel. Sed tortor ligula, pharetra non laoreet et, ultricies eget ipsum. Mauris ac suscipit massa. Nullam quis tellus ac tortor faucibus cursus. In hac habitasse platea dictumst. Pellentesque eros magna, laoreet nec ornare quis, gravida sit amet velit."
    
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}
