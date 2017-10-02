//
//  Helper.swift
//  VisionDemo1
//
//  Created by 李智揚 on 2017/9/5.
//  Copyright © 2017年 Yowoo Tech Inc. All rights reserved.
//

import UIKit

func transformRect(fromRect: CGRect , toViewRect :UIView) -> CGRect {
    
    var toRect = CGRect()
    toRect.size.width = fromRect.size.width * toViewRect.frame.size.width
    toRect.size.height = fromRect.size.height * toViewRect.frame.size.height
    toRect.origin.y =  (toViewRect.frame.height) - (toViewRect.frame.height * fromRect.origin.y )
    toRect.origin.y  = toRect.origin.y -  toRect.size.height
    toRect.origin.x =  fromRect.origin.x * toViewRect.frame.size.width
    
    return toRect
}
