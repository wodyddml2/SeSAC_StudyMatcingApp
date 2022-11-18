//
//  CustomAnnotationView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    static let indentifier = "CustomAnnotationView"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let image: Int?
    let coordinate: CLLocationCoordinate2D

    init(image: Int?, coordinate: CLLocationCoordinate2D) {
        self.image = image
        self.coordinate = coordinate
    }
}
