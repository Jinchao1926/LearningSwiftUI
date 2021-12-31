//
//  GiftExchangeViewModel.swift
//  Faker
//
//  Created by 林锦超 on 2021/12/30.
//

import Foundation
import AppKit

struct ExchangeModel {
    // user
    private(set) var phone: String?
    private(set) var password: String?
    private(set) var token: String?
    
    var user: String { String(format: "%@ (%@)", phone ?? "", token ?? "") }
    
    // gift
    var gifts: [GiftModel] = []
}

extension ExchangeModel: Hashable {}

class GiftExchangeViewModel: ObservableObject, FakerResponse {
    private(set) var datas: [ExchangeModel] = [
        // 我的
        /*
        ExchangeModel(phone: "16605911007", password: "Linger1007", gifts: [
            GiftModel(id: 143642, name: "乐高(LEGO)  悟空小侠"),
            GiftModel(id: 143694, name: "小米 米家电烤箱")
        ]) */
        // 杜老板的
        ExchangeModel(phone: "16605920226", token: "O73ZTnPbqUe1XOsH2suTlwiKYwakjv-0", gifts: [
            GiftModel(id: 149467, name: "华为   免费贴膜"),
            GiftModel(id: 143694, name: "小米 米家电烤箱"),
            GiftModel(id: 143680, name: "小米 电动剃须刀s300"),
            GiftModel(id: 143675, name: "小米 香氛机套装"),
            GiftModel(id: 143674, name: "小米 米家台灯lite"),
            GiftModel(id: 143672, name: "MUJI 水性彩色笔套装"),
            GiftModel(id: 143670, name: "MUJI 彩色铅笔24色")
        ]),
        // 胡总1
        ExchangeModel(phone: "🦊1", token: "tLw9lgXRgkWX7XS3OKNaJAJ_4w8JnqLE,16419", gifts: [
//            GiftModel(id: 149467, name: "华为   免费贴膜"),
            GiftModel(id: 143693, name: "MUJI 电磁炉"),
            GiftModel(id: 146902, name: "小米   挂烫机"),
            GiftModel(id: 143665, name: "MUJI 地毯除尘滚轮"),
            GiftModel(id: 143686, name: "小米 电水壶"),
            GiftModel(id: 143668, name: "星巴克 咖啡券"),
            GiftModel(id: 143663, name: "七鲜 东北长粒香米"),
            GiftModel(id: 143662, name: "七鲜 斑布无芯卷纸"),
            GiftModel(id: 143670, name: "MUJI 彩色铅笔24色"),
            GiftModel(id: 143664, name: "MINISO 衣物留香珠"),
            GiftModel(id: 143640, name: "MINISO 湿纸巾")
        ]),
        // 胡总2
        ExchangeModel(phone: "🦊1", token: "DvVWlslRdU-qOHdU-RzbWggHR__JPhCU,16419", gifts: [
//            GiftModel(id: 149467, name: "华为   免费贴膜"),
            GiftModel(id: 143660, name: "小米 智能电压力锅2.5L"),
            GiftModel(id: 143694, name: "小米 米家电烤箱"),
            GiftModel(id: 143674, name: "小米 米家台灯lite"),
            GiftModel(id: 143686, name: "小米 电水壶"),
            GiftModel(id: 143665, name: "MUJI 地毯除尘滚轮"),
            GiftModel(id: 143668, name: "星巴克 咖啡券"),
            GiftModel(id: 143663, name: "七鲜 东北长粒香米"),
            GiftModel(id: 143662, name: "七鲜 斑布无芯卷纸"),
            GiftModel(id: 143670, name: "MUJI 彩色铅笔24色"),
            GiftModel(id: 143640, name: "MINISO 湿纸巾"),
            GiftModel(id: 143664, name: "MINISO 衣物留香珠")
        ]),
    
        //陈婷
        ExchangeModel(phone: "陈婷", token: "jJieJ3K1SkKaRj8lVPWGzQhT_X_G8gYk,16419", gifts: [
//            GiftModel(id: 149467, name: "华为   免费贴膜"),
            GiftModel(id: 143652, name: "MUJI 微电脑电饭煲"),
            GiftModel(id: 146902, name: "小米   挂烫机"),
            GiftModel(id: 143674, name: "小米 米家台灯lite"),
            GiftModel(id: 143665, name: "MUJI 地毯除尘滚轮"),
            GiftModel(id: 143670, name: "MUJI 彩色铅笔24色"),
            GiftModel(id: 143640, name: "MINISO 湿纸巾"),
            GiftModel(id: 143664, name: "MINISO 衣物留香珠")
        ]),
    ]
    
    private var timer: Timer?
    private var targetDate: Date?
    
    func doExchange() {
        for (idx, model) in datas.enumerated() {
            if let token = model.token {
                // exchange
                for (jdx, gift) in model.gifts.enumerated() {
                    let giftID: String = String(gift.id ?? 0)
                    self.exchange(token: token, giftID: giftID, completion: { [weak self] doState, doError in
                        
                        self?.datas[idx].gifts[jdx].state = doState
                        self?.datas[idx].gifts[jdx].message = doError
                        self?.objectWillChange.send()
                    })
                }
            }
        }
    }
    
    private func exchange(token: String, giftID: String, completion: @escaping (_ state: State, _ error: String?) -> Void) {
        GiftProvider.request(GiftAPI.exchange(token: token, giftID: giftID)) {
            [weak self] result in
            
            switch result {
            case let .success(response):
                if let jsonDict = self?.format(response) {
                    if let d = jsonDict.0 {
                        // success
                        print("response:", d)
                        completion(.success, nil)
                    }
                    else {
                        print("error:", jsonDict.2)
                        completion(.failure, jsonDict.2)
                    }
                    return
                }
                completion(.failure, nil)

            case let .failure(error):
                completion(.failure, error.errorDescription)
            }
        }
    }
    
    func timing() {
       targetDate = Calendar.current.date(bySettingHour: 8, minute: 59, second: 59, of: Date())
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(startExchangingTimer), userInfo: nil, repeats: true)
        if let theTimer = timer {
            RunLoop.main.add(theTimer, forMode: .common)
        }
       timer?.fire()
    }
    
    @objc private func startExchangingTimer() {
        let current = Date()
        let component = Calendar.current.dateComponents([.second], from: current, to: targetDate!)
        if let second = component.second, Double(second) < 0.5 {
            print("Times up!!!")
            doExchange()
            timer?.invalidate()
        }
        print("current: \(current) target: \(targetDate!) seconds: \(String(describing: component.second))")
    }
    
    
    /*
    func doExchange() {
        for (idx, model) in datas.enumerated() {
            if let phone = model.phone, let password = model.password {
                // login
                login(phone: phone, password: password) { [weak self] state, token, error in
                    guard let self = self else { return }
                    
                    // login success
                    if state == .success {
                        // exchange
                        for (jdx, gift) in model.gifts.enumerated() {
                            let giftID: String = String(gift.id ?? 0)
                            self.exchange(token: token, giftID: giftID, completion: { [weak self] doState, doError in
                                
                                self?.datas[idx].gifts[jdx].state = doState
                                self?.datas[idx].gifts[jdx].message = doError
                            })
                        }
                        
                        return
                    }
                    
                    self.datas[idx].state = state
                    self.datas[idx].message = error
                }
            }
        }
    } */
    
    /*
    private func login(phone: String, password: String, completion: @escaping (_ state: State, _ token: String, _ error: String?) -> Void) {
        completion(.loading, "", nil)
        
        UserProvider.request(UserAPI.login(phone: phone, password: password)) { [weak self] result in
            switch result {
            case let .success(response):
                if let obj = self?.format(response), let dict = obj.0 {
                    if let token = dict["Token"] as? String {
                        completion(.success, token, nil)
                    }
                    else {
                        print("error:", obj.2)
                        completion(.failure, "", obj.2)
                    }
                    return
                }
                completion(.failure, "", nil)

            case let .failure(error):
                completion(.failure, "", error.errorDescription)
            }
        }
    } */
    
    
}
