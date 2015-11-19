//
//  DrawViewController.swift
//  chem-type
//
//  Created by triki on 11/13/15.
//  Copyright © 2015 triki. All rights reserved.
//

import UIKit
import Darwin
import QuartzCore
import AVFoundation
import Toucan

class DrawViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawView!
    var sessionManager = AFHTTPSessionManager(baseURL: nil)
    var greyscaleVals: [[CGFloat]]!
    var singleArray: [CGFloat]!
    var savedData: NSData?
    var transferInt: Int!
    
    @IBAction func ClearTapped(sender: AnyObject) {
        let theDrawView : DrawView = drawView as DrawView
        theDrawView.lines = []
        theDrawView.setNeedsDisplay()
    }
    
    
    @IBAction func ProccessTapped(sender: AnyObject) {
        UIGraphicsBeginImageContextWithOptions(drawView.layer.frame.size, false, 0);
        drawView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if let data = UIImagePNGRepresentation(viewImage){
            //let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            //let writePath = documentsDir.stringByAppendingString("/myscaleimage.png")
            //data.writeToFile(writePath, atomically:true)
            
            let alert = UIAlertController(title: "Image Saved", message: "Your image has been saved successfully! Press next to continue", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            savedData = data
            
            /*  let numColumns = 18
            let numRows = 12
            var scaledArray = Array<Array<CGFloat>>()
            for numColumns in 0...numColumns {
            scaledArray.append(Array(count:numRows, repeatedValue:0.0))
            }
            for(var i = 0; i < 1800; i++)
            {
            for(var j = 0; j < 1200; j++)
            {
            let xOld:Float = Float(i)
            let yOld:Float = Float(j)
            let xNew = floor((12.0/1800.0)*xOld)
            let yNew = floor((8.0/1200.0)*yOld)
            scaledArray[Int(xNew)][Int(yNew)] += greyscaleVals[i][j]
            }
            }
            
            print(scaledArray) */
            
            
            /*let cgImage = image!.CGImage
            let width = CGImageGetWidth(cgImage) / 24
            let height = CGImageGetHeight(cgImage) / 24
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            let context = UIGraphicsGetCurrentContext()
            
            CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
            
            CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
            
            let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
            
            if(scaledImage == nil)
            {
            print("bad")
            }*/
            
            var image = UIImage(data: data)
            image = testResizedLandscapeClipped(image!)
            let cgImage = image!.CGImage
            let width = CGImageGetWidth(cgImage)
            let height = CGImageGetHeight(cgImage)
            print(width)
            print(height)
            extractPixels(image!)
            //let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            // let writePath = documentsDir.stringByAppendingString("/myscaledimage.png")
            // data.writeToFile(writePath, atomically:true)
        }
            
        else
        {
            let alert = UIAlertController(title: "Image Not Saved", message: "Your image has not been saved. Sorry about that, try again.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Sorry!", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
        }
    }
    
    func testResizedLandscapeClipped(image: UIImage) -> UIImage {
        let resized = Toucan(image: image).resize(CGSize(width: 6, height: 3), fitMode: Toucan.Resize.FitMode.Clip).image
        return resized
    }
    
    func extractPixels(scaledImage: UIImage)
    {
        greyscaleVals = [[CGFloat]]()
        singleArray = [CGFloat]()
        
        if let cgImage = scaledImage.CGImage
        {
            let provider = CGImageGetDataProvider(cgImage)
            let bitmapData = CGDataProviderCopyData(provider)
            let cfData = CFDataGetBytePtr(bitmapData)
            let width = CGImageGetWidth(cgImage)
            let height = CGImageGetHeight(cgImage)
            for (var i = 0; i < height; i++)
            {
                greyscaleVals.append([CGFloat]())
                for ( var j = 0; j < width; j++)
                {
                    let pixelInfo: Int = ((Int(width) * Int(j)) + Int(i)) * 4
                    let r = CGFloat(cfData[pixelInfo])
                    let g = CGFloat(cfData[pixelInfo+1])
                    let b = CGFloat(cfData[pixelInfo+2])
                    let greyColor = (r+g+b)/3
                    greyscaleVals[i].append(greyColor)
                    singleArray.append(greyColor)
                    // print(greyscaleVals[i][j])
                }
            }
            
            var mean: CGFloat = 0.0
            var std: CGFloat = 0.0
            for i in singleArray
            {
                mean = mean + i
            }
            mean = mean/(CGFloat(singleArray.count))
            for i in singleArray
            {
                std =  std + ((i-mean)*(i-mean))
                
                std = std / (CGFloat(singleArray.count))
                std = sqrt(std)
            }
            for(var i = 0; i < singleArray.count; i++)
            {
                singleArray[i] = (singleArray[i]-mean)/std
            }
            //print(mean)
            //print(std)
            //print(singleArray)
            sendRequest(singleArray)
        }
    }
    
    func sendRequest(singleArray: [CGFloat]){
        let values: [String] = [
            String(singleArray[0]),
            String(singleArray[1]),
            String(singleArray[2]),
            String(singleArray[3]),
            String(singleArray[4]),
            String(singleArray[5]),
            String(singleArray[6]),
            String(singleArray[7]),
            String(singleArray[8]),
            String(singleArray[9]),
            String(singleArray[10]),
            String(singleArray[11]),
            String(singleArray[12]),
            String(singleArray[13]),
            String(singleArray[14]),
            String(singleArray[15]),
            String(singleArray[16]),
            String(singleArray[17]),
            String(singleArray[18]),
            String(singleArray[19]),
            String(singleArray[20]),
            String(singleArray[21]),
            String(singleArray[22]),
            String(singleArray[23]),
            String(singleArray[24]),
            String(singleArray[25]),
            String(singleArray[26]),
            String(singleArray[27]),
            String(singleArray[28]),
            String(singleArray[29]),
            String(singleArray[30]),
            String(singleArray[31]),
            String(singleArray[32]),
            String(singleArray[33]),
            String(singleArray[34]),
            String(singleArray[35]),
            String(singleArray[36]),
            String(singleArray[37]),
            String(singleArray[38]),
            String(singleArray[39]),
            String(singleArray[40]),
            String(singleArray[41]),
            String(singleArray[42]),
            String(singleArray[43]),
            String(singleArray[44]),
            String(singleArray[45]),
            String(singleArray[46]),
            String(singleArray[47]),
            String(singleArray[48]),
            String(singleArray[49]),
            String(singleArray[50]),
            String(singleArray[51]),
            String(singleArray[52]),
            String(singleArray[53]),
            String(singleArray[54]),
            String(singleArray[55]),
            String(singleArray[56]),
            String(singleArray[57]),
            String(singleArray[58]),
            String(singleArray[59]),
            String(singleArray[60]),
            String(singleArray[61]),
            String(singleArray[62]),
            String(singleArray[63]),
            String(singleArray[64]),
            String(singleArray[65]),
            String(singleArray[66]),
            String(singleArray[67]),
            String(singleArray[68]),
            String(singleArray[69]),
            String(singleArray[70]),
            String(singleArray[71]),
            String(singleArray[72]),
            String(singleArray[73]),
            String(singleArray[74]),
            String(singleArray[75]),
            String(singleArray[76]),
            String(singleArray[77]),
            String(singleArray[78]),
            String(singleArray[79]),
            String(singleArray[80]),
            String(singleArray[81]),
            String(singleArray[82]),
            String(singleArray[83]),
            String(singleArray[84]),
            String(singleArray[85]),
            String(singleArray[86]),
            String(singleArray[87]),
            String(singleArray[88]),
            String(singleArray[89]),
            String(singleArray[90]),
            String(singleArray[91]),
            String(singleArray[92]),
            String(singleArray[93]),
            String(singleArray[94]),
            String(singleArray[95]),
            "0"]
        let body = [
            "Inputs": [
                "input1": [
                    "ColumnNames": [
                        "Col1",
                        "Col2",
                        "Col3",
                        "Col4",
                        "Col5",
                        "Col6",
                        "Col7",
                        "Col8",
                        "Col9",
                        "Col10",
                        "Col11",
                        "Col12",
                        "Col13",
                        "Col14",
                        "Col15",
                        "Col16",
                        "Col17",
                        "Col18",
                        "Col19",
                        "Col20",
                        "Col21",
                        "Col22",
                        "Col23",
                        "Col24",
                        "Col25",
                        "Col26",
                        "Col27",
                        "Col28",
                        "Col29",
                        "Col30",
                        "Col31",
                        "Col32",
                        "Col33",
                        "Col34",
                        "Col35",
                        "Col36",
                        "Col37",
                        "Col38",
                        "Col39",
                        "Col40",
                        "Col41",
                        "Col42",
                        "Col43",
                        "Col44",
                        "Col45",
                        "Col46",
                        "Col47",
                        "Col48",
                        "Col49",
                        "Col50",
                        "Col51",
                        "Col52",
                        "Col53",
                        "Col54",
                        "Col55",
                        "Col56",
                        "Col57",
                        "Col58",
                        "Col59",
                        "Col60",
                        "Col61",
                        "Col62",
                        "Col63",
                        "Col64",
                        "Col65",
                        "Col66",
                        "Col67",
                        "Col68",
                        "Col69",
                        "Col70",
                        "Col71",
                        "Col72",
                        "Col73",
                        "Col74",
                        "Col75",
                        "Col76",
                        "Col77",
                        "Col78",
                        "Col79",
                        "Col80",
                        "Col81",
                        "Col82",
                        "Col83",
                        "Col84",
                        "Col85",
                        "Col86",
                        "Col87",
                        "Col88",
                        "Col89",
                        "Col90",
                        "Col91",
                        "Col92",
                        "Col93",
                        "Col94",
                        "Col95",
                        "Col96",
                        "Col97"
                    ],
                    "Values": [values,
                        values,
                    ]
                    
                ]
            ],
            "GlobalParameters": [:]
        ]
        
        
        let url: String = "https://ussouthcentral.services.azureml.net/workspaces/c8a6a33a937f4dc3ae36c98e3e99114d/services/af16560e960a4dc99fb3d116ca7dcb84/execute?api-version=2.0"
        var myResponceObject = NSData()
        
//        let request = NSURLRequest(URL: NSURL(fileURLWithPath: url))
//        let session = NSURLSession.sharedSession()
//        
//        
//        do {
//            let bodyData = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions(rawValue: 0))
//        } catch {
//            
//        }
        
        
        
        let dataTask = sessionManager.POST(url, parameters: body, success: { (dataTask, responceObject) -> Void in
            
            
//                let theData = responceObject as! NSData
//                let theResJson = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions(rawValue: 0))
//                print("printing responce \(responceObject)")
//                print(responceObject["Results"]["output1"]["value"])
            
            let newDict = responceObject as! NSDictionary
            print("new dict: \(newDict)")
            if let results = newDict["Results"] as? NSDictionary {
                if let output1 = results["output1"] as? NSDictionary {
                    if let value = output1["value"] as? NSDictionary {
                        if let valueArray = value["Values"] as? NSArray {
                            if let actualValueArray = valueArray[0] as? NSArray {
                                if let myValue = actualValueArray[0] as? String {
                                    if let 😍 = Int(myValue) {
                                        print(😍)
                                        self.transferInt = 😍
                                    }
                                }
                            }
                        }
                    }
                }
            }
//            do {
//                ,
//                if let newObjectFromJSON = try NSJSONSerialization.JSONObjectWithData((responceObject as! NSData), options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//                    if let results = newObjectFromJSON["Results"]  {
//                        print(results)
//                    }
//                } else {
//                    print("not a dictionary")
//                }
//                
//                
//                
//            
//            } catch {
//                
//            }
            
            /*if let data =
            as? NSDictionary {
                if let feed = data["feed"] as? NSDictionary {
                    if let firstApp = feed[0] as? NSDictionary {
                        if let apps = feed["entry"] as? NSArray {
                            println("Optional Binding: )
                        }
                    }
                }
            }*/
            
            }) { (dataTask, error) -> Void in
            print(error)
                
        }
        
        //let dataTask = sessionManager.POST(url, parameters: body, success: { (dataTask, responseObject) -> Void in
        //print(dataTask?.currentRequest?.allHTTPHeaderFields)
        //}
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionManager.requestSerializer = AFJSONRequestSerializer(writingOptions: [])
        self.sessionManager.requestSerializer.setValue("Bearer o01UcDoSm0bFiwKL3JTGOjC4rJefM7baOVWCuGK/hJ5YSawFKYkKqJNh46Y81maaMRygW3/lwr17+i7zP+40BA==", forHTTPHeaderField: "Authorization")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let processedViewController = segue.destinationViewController as? ProcessedViewController {
            processedViewController.transferInt = transferInt
        }
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
