# CurrencyConverter (환율 계산기)
**실시간 환율 데이터를 외부 API를 통해 받아오고**
데이터를 UI에 표시하고, 사용자의 입력을 바탕으로 **새로운 결과를 계산하여 보여주는 앱**입니다.

## 주요 기능
- **1. 실시간 환율 조회:** `API 통신`을 통해 USD 대비 국가들의 환율 정보를 가져옵니다.
- **2. 환율 변동성 표시:** `CoreData에` 저장된 지난 기록을 통해, 기록 대비 환율 상승과 하락, 유지 상태를 표시합니다.
- **3. 통화 검색:** 국가 코드, 국가 이름 검색을 통해 정보를 찾기 용이합니다.
- **4. 즐겨찾기:** 자주 확인하는 통화를 즐겨찾기에 등록하여 리스트의 최상단에 표시합니다.
- **5. 환율 계산:** 선택한 통화에 대해 환율을 계산하는 시스템을 지원하여, 입력된 결과값에 따라 계산된 결과를 보여줍니다.
- **6. 앱 상태 복구:** 앱 종료 시점에 접근해있던 화면을 기록하여 재실행 시 바로 해당 화면으로 접근하며 해당데이터(통화 코드)도 제공됩니다.

## 프로젝트 구조
```
currencyConverter/
├── App/
│   └── SceneDelegate.swift          # 앱 생명주기 및 상태 복구(Scene Restoration) 관리
├── Model/
│   ├── CurrencyResponse.swift       # API 응답 데이터 모델 (Codable)
│   ├── ExchangeRate.swift           # 앱 내에서 사용하는 환율 모델 및 상태(up/down/stay)
│   ├── Mapper.swift                 # 통화 코드-국가명 매핑 데이터
│   ├── MyColor.swift                # UIColor 익스텐션 (다크모드 대응 등)
│   └── Manager/
│       ├── CoreDataManager.swift    # CoreData Stack 설정 및 저장 관리 (Singleton)
│       ├── NetworkManager.swift     # Alamofire 기반 제네릭 네트워크 통신
│       ├── FavoriteManager.swift    # 즐겨찾기 저장, 정보 불러오기 로직
│       ├── HistoryManager.swift     # 과거 환율 데이터 저장 및 중복 방지 로직
│       └── InformationManager.swift # 앱 최종 상태(통화 코드, 페이지) 저장 관리
├── ViewModel/
│   ├── CalculatorViewModel.swift    # 환율 계산 로직 및 유효성 검사
│   └── ExchangeRateViewModel.swift  # 메인 리스트 로직 (검색, 정렬, 데이터 바인딩)
├── View/
│   ├── CalculatorView.swift         # SnapKit 기반 계산기 레이아웃
│   ├── ExchangeView.swift           # SnapKit 기반 메인 레이아웃
│   ├── TableView.swift
│   └── TableViewCell.swift          # 환율 리스트 커스텀 셀
├── ViewController/
│   ├── CalculatorViewController.swift
│   └── ExchangeRateViewController.swift
└── Assets.xcassets                  # 컬러셋
```
## 도전 구현 LV. 11 메모리 이슈 디버깅 및 개선 경험
**1. 분석 대상**
- **CalculatorViewControlle**r와 **CalculatorViewModel** 사이의 데이터 바인딩 `Closure`
- **ExchangeRateViewControler**와 **ExchangeRateViewModel** 사이의 데이터 바인딩 `Closure`
- **CalculatorView**와 **CalculatorViewController** 사이의 `Delegate` 패턴

**2. 구상**
- **Closure 기반:** ViewModel의 updateData `Closure` 내에서 self를 강하게 참조할 경우, ViewController가 `deinit`되어도 메모리에서 해제되지 않아 순환 참조가 발생할 수 있다.
- **Delegate 기반:** View와 ViewController가 서로 강하게 참조하면 메모리 누수가 발생할 수 있다.

**3. 점검 (Memory Graph Debugger) 및 결과**

**3.1 Closure 기반**
- **CalculatorViewController:** 화면 `Pop` 즉시 `deinit` 로그 출력을 확인했습니다. **`[weak self]`를 통한 순환 참조 방지**
- **ExchangeRateViewcontroller:** Root 화면으로 앱이 실행 중에 메모리에 항상 유지되어야 합니다.
- **공통:** ViewController를 여러번 `Push/Pop`하여 메모리 노드를 확인했습니다.

**3.2 Delegate 기반**
- CalculatorView.swift에서 weak var delegate: CalculatorViewDelegate? 부분의 `weak` 키워드를 통해 약한 참조를 적용했습니다.

## 기술 스택
- **Language:** ``Swift 5.1+``
- **Architecture:** ``MVVM``
- **UI:** UIKit, ``Snapkit``
- **Network:** ``Alamofire``
- **Database:** ``CoreData``
