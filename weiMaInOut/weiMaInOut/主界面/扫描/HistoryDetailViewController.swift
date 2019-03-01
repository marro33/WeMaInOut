//
//  HistoryDetailViewController1.swift
//  weiMaInOut
//
//  Created by Gaojian on 2018/12/25.
//  Copyright © 2018年 ZJ. All rights reserved.
//

import UIKit
import Alamofire

class HistoryDetailViewController: UIViewController {

//
//    var headerstring = ""
//    let requestURL = "https://api.veima.com/lgs/api/LogisticsCodeQuery?logisticsCode="
//    let requestURL_test = "https://api-dev.veima.com/lgs/api/LogisticsCodeQuery?logisticsCode="
//    var url = "https://api.veima.com/lgs/api/LogisticsCodeQuery/GetLogisticCodeBasic?customerCode=1595&logisticsCode=202984378540"

    var url = ""
    var result = ""
    var strArray = ["物流码：","未知","产品：","未知","批次：","未知","经销商：","未知","经销商区域：","未知"]
    var labelArray = [UILabel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        initUI()
        requestsever()
    }

    func initUI() {

        self.view.backgroundColor = UIColor.white
        self.title = "详细内容"
        self.navigationController?.navigationBar.backgroundColor = UIColor.orange

        for i in 0..<10{
            let rect = CGRect(x: 20, y: 80+40*i, width: 200, height: 30)
            let label = UILabel(frame: rect)
            label.text = strArray[i]
            if(i % 2 == 0){
                label.textColor = UIColor.lightGray
            }
            label.textAlignment = NSTextAlignment.left
            self.view.addSubview(label)
            labelArray.append(label)
        }

        labelArray[1].text = result

    }




    func requestsever(){


        let array: NSArray = UserDefaults.standard.array(forKey: "config") as! NSArray

        var customerCode = ""
        if let arr = array[0] as? NSArray{
            customerCode = arr[0] as! String
        }

        url = "https://api.veima.com/lgs/api/LogisticsCodeQuery/GetLogisticCodeBasic?customerCode=" + customerCode + "&logisticsCode=" + result

//        if UserDefaults.standard.string(forKey: "token") == nil{
//            self.showAlert()
//            return
//        }
//        headerstring = UserDefaults.standard.string(forKey: "token") as! String
//        let headers: HTTPHeaders = ["authorization": headerstring]

//        if !UserDefaults.standard.bool(forKey: "test"){
//            url = requestURL
//        }else{
//            url = requestURL_test
//        }
        //        let index = result.index(result.startIndex, offsetBy: 1)
        //        result = result.substring(from: index)

        print("URL>>>>>" + url)

        //        print(">>>>>>>>>>> \(requestURL)")

        Alamofire.request(url, method: .get,headers: nil).responseJSON {
            response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result


            if "\(response.result)"=="SUCCESS"{
                print("开始解析JSON")

                let detail = response.result.value as! Dictionary<String, Any>

                //                print(data)

                if let data = detail["data"] as? Dictionary<String, Any> {

                    //                var fd = data["fDepotName"] as! String
                    //                var log = data["logisticsCode"] as! String
                    self.labelArray[3].text = data["goodsName"] as? String ?? "查无该商品"
                    self.labelArray[5].text = data["batchNo"] as? String ?? "未知"
                    self.labelArray[7].text = data["clientName"] as? String ?? "未知"
                    self.labelArray[9].text = data["clientAreaName"] as? String ?? "未知"
                }
            }else{
                self.showAlert()
            }

        }

    }


    enum ErrorType: Error {
        case invalidURL
        case invalidResult
        case invalidToken
    }


    func showAlert(){
        let alert = UIAlertController(title: "结果加载失败", message: "请重新选择登录模式", preferredStyle: .alert)
        let action = UIAlertAction (title: "登录", style: .default, handler: {
            (alerts: UIAlertAction) -> Void in

            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)

            let viewController = mainStoryboard.instantiateInitialViewController() as! UINavigationController
            self.present(viewController, animated: true, completion: nil)

        })
        let action2 = UIAlertAction (title: "取消", style: .cancel, handler: {
            (alerts: UIAlertAction) -> Void in

        })
        alert.addAction(action)
        alert.addAction(action2)
        present(alert,animated: true,completion: nil)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
