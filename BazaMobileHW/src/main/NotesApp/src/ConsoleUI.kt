class ConsoleUI {
    fun showCanvas(canvas: CanvasUnit) {
        println(canvas.drawCanvas())
    }

    fun readString(message: String = "Введите строку"): String? {
        print("$message ")
        return readLine()?.takeIf { it.isNotBlank() }
    }

    fun readInt(message: String = "Введите число"): Int? {
        print("$message ")
        return readLine()?.toIntOrNull()
    }

    fun showMenuList(buttons: List<String>): Int? {
        println("\n=== МЕНЮ ===")
        buttons.forEachIndexed { index, button ->
            println("${index + 1}. $button")
        }
        println("================")
        return readInt("Выберите пункт меню (1-${buttons.size})")
    }
}