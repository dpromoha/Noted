//
//  SettingsVC.swift
//  Noted
//
//  Created by Daria Pr on 19.09.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import UIKit
import ColorPalette

class SettingsVC: UIViewController, ColorPaletteViewDelegate, ColorPaletteViewDataSource {
    
    @IBOutlet weak var colorPalette: ColorPaletteView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPalette.delegate = self
        colorPalette.dataSource = self
        
        colorPalette.rowCount = 2
        colorPalette.columnCount = 6
        
        colorPalette.verticalSpacing = 20.0
        colorPalette.horizontalSpacing = 10.0
        
    }
    
    func colorPalette(_ colorPalette: ColorPaletteView, didSelect color: UIColor, at index: Int) {
        navigationController?.navigationBar.barTintColor = color
        defaults.set(color, forKey: "NavBarColor")
        colorPalette.paletteItemSelectedBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func colorPalette(_ colorPalette: ColorPaletteView, colorAt index: Int) -> UIColor? {
        switch index {
        case 0:
            return #colorLiteral(red: 0.5098039216, green: 0.1882352941, blue: 0.4, alpha: 1)
        case 1:
            return #colorLiteral(red: 0.1764705882, green: 0.4156862745, blue: 0.1019607843, alpha: 1)
        case 2:
            return #colorLiteral(red: 0.6823529412, green: 0.09803921569, blue: 0.01176470588, alpha: 1)
        case 3:
            return #colorLiteral(red: 0.4862745098, green: 0.3019607843, blue: 0.2392156863, alpha: 1)
        case 4:
            return #colorLiteral(red: 0.2666666667, green: 0.3254901961, blue: 0.368627451, alpha: 1)
        case 5:
            return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        case 6:
            return #colorLiteral(red: 0.462745098, green: 0.3568627451, blue: 0.3450980392, alpha: 1)
        case 7:
            return #colorLiteral(red: 0.7254901961, green: 0.2901960784, blue: 0.3490196078, alpha: 1)
        case 8:
            return #colorLiteral(red: 0.737254902, green: 0.4470588235, blue: 0.003921568627, alpha: 1)
        case 9:
            return #colorLiteral(red: 0.2823529412, green: 0.3411764706, blue: 0.4705882353, alpha: 1)
        case 10:
            return #colorLiteral(red: 0.3803921569, green: 0.4392156863, blue: 0.337254902, alpha: 1)
        case 11:
            return #colorLiteral(red: 0.7607843137, green: 0.3960784314, blue: 0.4509803922, alpha: 1)
        default:
            return #colorLiteral(red: 0.4602370858, green: 0.6171972156, blue: 0.8999380469, alpha: 1)
        }
    }
    
}

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}
