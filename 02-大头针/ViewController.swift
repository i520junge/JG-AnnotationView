//
//  ViewController.swift
//  02-大头针
//
//  Created by 刘军 on 2016/11/13.
//  Copyright © 2016年 刘军. All rights reserved.
//点击地图，添加大头针，点击大头针弹出显示位置

import UIKit
import MapKit
//import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    /// 地理编码
    lazy var geoc:CLGeocoder = {
        return CLGeocoder()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    1、获取在控件上点击的点
        let point = touches.first?.location(in: mapView)
        
//    2、将控件上面的点(CGPoint),转为经纬度
        let coordinate = mapView.convert(point!, toCoordinateFrom: mapView)
        
//    3、创建大头针数据模型,并添加到地图上：注：必须先设置title和subTitle的占位字
        let annotation = addAnnotation(coordinate: coordinate, title: "城市", subTitle: "地址")
                //①通过模型创建大头针；
                //②确定大头针的经纬度(在地图上显示的位置)；
                //③设置大头针弹框的标题和子标题；
                //④添加到地图上
        
//    4、将点击的那个点的经纬度进行 反地理编码，得到弹框要显示的标题和子标题
                //①获取需要反地理编码的经纬度，懒加载地理编码对象：CLGeocoder
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoc.reverseGeocodeLocation(location, completionHandler: {
            (clpls:[CLPlacemark]?, error:Error?) -> Swift.Void in
            
                //②判断反地理编码是否成功
            if error != nil{return}
            
                //③取出地标对象（CLPlacemark）
            let clpl = clpls?.first
            
                //④通过地标对象获取城市、详细地址，更新大头针标题和子标题
            annotation.title = clpl?.administrativeArea
            annotation.subtitle = (clpl?.locality ?? "无法获取所在省份") + (clpl?.subLocality ?? "无法获取所在省份 ")
            annotation.subtitle = annotation.subtitle! + (clpl?.name ?? "无法获取所在城市")
        })
        
    }
    
    /// 移除大头针
    @IBAction func removeAnnotation(_ sender: UIBarButtonItem) {
        // 1.获取需要移除的大头针
        let annotation = mapView.annotations
        
        // 2.移除大头针
        mapView.removeAnnotations(annotation)
    }
}

//MARK:- mapview代理方法，自定义大头针
extension ViewController:MKMapViewDelegate{
    
    /// 当添加一个大头针模型时系统自动会调用这个方法，去设置大头针视图
    /// 如果不实现这个方法，则默认用系统的
    /// - Parameters:
    ///   - mapView: 地图视图
    ///   - annotation: 大头针数据模型
    /// - Returns: 返回创建好的大头针视图
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //步骤跟创建tableViewCell一样
//        1、创建标识
        let ID = "annotationID"
        
//        2、从缓存池中获取大头针视图
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ID)
        
//        3、如果没有获取到，就创建大头针视图
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ID)
        }
//        4、设置大头针数据模型
        annotationView?.annotation = annotation
        
//        5、设置大头针样式（弹框、弹框偏移、弹框的左右底部控件、大头针偏移、下降动画、拖拽）
        //如果自定义了大头针视图,必须要指定长什么样
            annotationView?.image = UIImage(named: "category_1")
        //必须设置允许弹框，才会弹框
        annotationView?.canShowCallout = true
        //设置大头针中心偏移量，弹框偏移量
//        annotationView?.centerOffset = CGPoint(x: -50, y: 50)
//        annotationView?.calloutOffset = CGPoint(x: 50, y: 50)
        
        annotationView?.isDraggable = true
        //设置下降（animatesDrop）动画只能大头针的子类
//        annotationView?.animatesDrop = true
        
        //设置弹框左右视图，底部视图
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView1.image = UIImage(named: "huba")
        annotationView?.leftCalloutAccessoryView = imageView1   //左边视图
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView2.image = UIImage(named: "htl")
        annotationView?.rightCalloutAccessoryView = imageView2   //左边视图
        
        //底部视图，是iOS9.0之后有的
//        if #available(iOS 9.0, *) {
//            annotationView?.detailCalloutAccessoryView = UISwitch()
//        }
        
        return annotationView
    }
    
    /// 当拖拽大头针时，系统会调用这个方法
    /// - Parameters:
    ///   - mapView: 地图视图
    ///   - view: 大头针视图
    ///   - newState: 新的状态
    ///   - oldState: 老的状态
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
}




//MARK:- 创建大头针
extension ViewController{
    /// 创建大头针，添加到地图上
    /// - Parameters:
    ///   - coordinate: 经纬度
    ///   - title: 标题
    ///   - subTitle: 小标题
    /// - Returns: 大头针
    func addAnnotation(coordinate:CLLocationCoordinate2D,title:String ,subTitle:String) -> JGAnnotation{
        //①通过模型创建大头针；
        let annotation = JGAnnotation()
        
        //②确定大头针的经纬度(在地图上显示的位置)；
        annotation.coordinate = coordinate
        
        //③设置大头针弹框的标题和子标题；
        annotation.title = title
        annotation.subtitle = subTitle
        
        //④添加到地图上
        mapView.addAnnotation(annotation)
        
        return annotation
    }
}


