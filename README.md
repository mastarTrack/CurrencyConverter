# CurrencyConverter

**실시간 데이터를 외부 API를 통해 받아오고**

그 데이터를 UI에 표시하고, 사용자의 입력을 바탕으로 **새로운 결과를 계산하여 보여주는 앱**을 만들어봅니다.

**환율 계산기 앱**

> 실시간 환율 정보를 Open API로 받아오고, 금액을 변환하거나, 관심 있는 통화를 즐겨찾기에 추가해 상단 고정해보세요!
> 
> 
> 환율 정보는 항상 변하고, 다양한 국가의 통화가 존재하기 때문에,
> 
> 이번 과제를 통해 다음과 같은 내용을 복습하고 실습할 수 있습니다:
> 
> •    **SnapKit을 활용한 UI 구성 및 AutoLayout 디버깅 경험**
> 
> •    **URLSession을 활용한 Open API 통신**
> 
> •    **UITableView를 통한 리스트 UI 구성**
> 
> •    **MVVM 패턴을 활용한 로직 분리**
> 
> •    **CoreData를 활용한 간단한 데이터 저장 및 즐겨찾기 기능**
>

----------

- **Model**: 데이터를 가져오거나 데이터 모델을 정의합니다.
- **View**:  화면에 보이는 UI를 설정합니다.
- **Controller**: 로직을 수행하거나 View에서 Action이 필요한 객체의 경우 액션을 할당하고 동작을 명령합니다.

텍스트필드 때문에 고민이 많았습니다.

```swift
class CalculationView {
    private let amountTextField = UITextField()

    func setTextFieldAction(_ action: UIAction) {
        amountTextField.addAction(action, for: .editingChanged)
    }
    
    func resignTextField() {
        amountTextField.resignFirstResponder()
    }
    
    func passAmountText() -> String? {
        return amountTextField.text
    }
}
```

```swift
class CalculationViewController {
    private var stringAmount: String?

    private func setTextFieldAction() {
        let save = UIAction { [weak self] _ in
            let text = self?.calculationView.passAmountText()
            self?.stringAmount = text
        }
        
        calculationView.setTextFieldAction(save)
    }
}
```

1️⃣ **amountTextField의 동작 할당**
`CalculationView`의 `amountTextField`의 경우, 텍스트필드의 텍스트가 변화할 때마다 `CalculationViewController`의 `stringAmount` 속성에 저장하고 있습니다.

동작은 Controller에서 정의하고 싶은데, 동작에 필요한 데이터와 동작을 할당받을 객체는 View가 가지고 있으니 너무 View와 Controller 사이를 왔다갔다 거리는 비효율적인 느낌이 들었습니다.

1. Controller에서 동작 정의 시작 (`func setTextFieldAction()`)
2. View → Controller 데이터 전달 (`func passAmountText() -> String?`)
3. Controller → View 동작 할당 명령 (`func setTextFieldAction(_ action: UIAction)`)

하지만 어찌됐든 View의 데이터와 ViewController의 속성 모두 필요한 것이기 때문에 현재 구현 방식을 유지하기로 했습니다.
(View에서 텍스트필드의 동작을 정의하더라도 Controller에서 속성을 받아올 필요가 있습니다. delegate를 사용하자니 그럼 코드의 복잡도가 현재와 크게 다르지 않을 것 같았습니다.)

2️⃣ **amountTextField로의 접근**
`func resignTextField()` 메서드나 `func passAmountText() -> String?` 메서드는 내부에 정의된 동작이 많지 않습니다.
단순히 amountTextField에 접근하는 건데 메서드로 정의할지, amountTextField의 접근제한자를 internal로 바꿀지 고민했습니다.
접근제한자를 변경할 경우 amountTextField가 외부에서 변경될 위험이 있으므로 이번에는 그런 위험성을 최대한 줄이고자 현재 방식을 유지하였습니다.
