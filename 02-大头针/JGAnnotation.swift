//
//  JGAnnotation.swift
//  02-大头针
//
//  Created by 刘军 on 2016/11/13.
//  Copyright © 2016年 刘军. All rights reserved.
//

import UIKit
import MapKit

class JGAnnotation: NSObject,MKAnnotation{
    
    /// 经纬度
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    /// 标题
    var title: String?
    
    /// 子标题
    var subtitle: String?
}
