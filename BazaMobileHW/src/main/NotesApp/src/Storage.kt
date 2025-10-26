class Storage<T : IdentifiableModel> {
    private val items = mutableListOf<T>()

    fun add(item: T) {
        items.add(item)
    }

    fun removeById(id: String) {
        items.removeAll { it.id == id }
    }

    fun getById(id: String): T? {
        return items.firstOrNull { it.id == id }
    }

    fun update(item: T) {
        val index = items.indexOfFirst { it.id == item.id }
        if (index != -1) {
            items[index] = item
        }
    }

    fun getAll(): List<T> {
        return items.toList()
    }
}