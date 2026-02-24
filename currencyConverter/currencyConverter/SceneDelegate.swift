//
//  SceneDelegate.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // 메인 화면 세팅
        let navigationController = UINavigationController(rootViewController: ExchangeRateViewController(viewModel: ExchangeRateViewModel()))
        
        // 코어데이터에서 마지막 상태 읽어오기
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppState")
        
        do {
            // 저장된 상태 있으면 꺼내기
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject],
               let lastState = result.last,
               let lastScreen = lastState.value(forKey: "lastScreen") as? String {
                
                if lastScreen == "Calculator",
                   let currencyCode = lastState.value(forKey: "currencyCode") as? String,
                   let currencyCountry = lastState.value(forKey: "currencyCountry") as? String {
                    
                    let calcViewModel = CalculatorViewModel(code: currencyCode, country: currencyCountry, rate: "1000.0")
                    
                    let calcVC = CalculatorViewController(viewModel: calcViewModel)

                    // 리스트 화면 위에 계산기 화면을 얹어 시작
                    navigationController.pushViewController(calcVC, animated: false)
                    print("복원 완료: 계산기 화면 (\(currencyCode)")
                } else {
                    print("복원 완료: 리스트 화면")}
                }
            } catch {
                    print("상태 복원 실패: \(error)")
                }
        // 완성된 화면 윈도우에 띄우기
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

    // MARK: -- 백그라운드
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // 백그라운드 상태로 갈때 현 화면 상태 저장
        saveCurrentAppState()
    }
    
    // 앱 상태 저장 메서드
    private func saveCurrentAppState() {
        // 최 상단 뷰컨 찾기
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController as? UINavigationController,
              let topVC = rootVC.topViewController else { return }
        
        let context = CoreDataManager.shared.context
        
        // 기존에 저장되어있던 상태 지우기
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppState")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(deleteRequest)
        
        // 현 상태 기록하기
        let newState = AppState(context: context)
        
        if topVC is ExchangeRateViewController {
            newState.lastScreen = "List"
            newState.currencyCode = nil
            
        } else if  let calcVC = topVC as? CalculatorViewController {
            newState.lastScreen = "Calculator"
            newState.currencyCode = calcVC.viewModel.selectedCode
            newState.currencyCountry = calcVC.viewModel.selectedCountry
            print("상태저장 완료: \(newState.currencyCode ?? "")")
        }
        
        // 코어데이터 최종 저장
        CoreDataManager.shared.saveContext()
    }


}

