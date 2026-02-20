//
//  SceneDelegate.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let infoManager = InformationManager(container: appDelegate.persistentContainer)
        let historyManager = HistoryManager(container: appDelegate.persistentContainer)
        let info = infoManager.fetchData()
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: ExchangeRateViewController())
        
        if info?.page == "calculator", let code = info?.code {
            if let history = historyManager.fetchData(code: code) {
                let exchangeRate = ExchangeRate(code: code, rate: history.rate)
                let calculatorVM = CalculatorViewModel(item: exchangeRate)
                let calculatorVC = CalculatorViewController(viewModel: calculatorVM)
                
                navigationController.pushViewController(calculatorVC, animated: true)
            }
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let infoManager = InformationManager(container: appDelegate.persistentContainer)
        let navigation = window?.rootViewController as! UINavigationController
        
        if let calculatorVC = navigation.topViewController as? CalculatorViewController {
            infoManager.saveInfo(code: calculatorVC.viewModel.item.code, page: "calculator")
        } else {
            infoManager.saveInfo(code: nil, page: "exchangeRate")
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

