class ConsoleUI {
    func showCanvas(_ canvas:CanvasUnit){
        print(canvas.drawCanvas())
    }
    
    func readString(_ message: String = "Введите строку") -> String? {
        print(message,terminator: " ")
        return readLine()
    }
    
    func readInt(_ message: String = "Введите число") -> Int? {
        print(message,terminator: " ")
        guard let input = readLine(), let number = Int(input) else {
            return nil
        }
        return number
    }
    
    func showMenuList(_ buttons:[String]) -> Int? {
        print("\n=== МЕНЮ ===")
        for (index,button) in buttons.enumerated(){
            print("\(index+1). \(button)")
        }
        print("================")
        
        return readInt("Выберите пункт меню (1-\(buttons.count)): ")
        
    }
}

