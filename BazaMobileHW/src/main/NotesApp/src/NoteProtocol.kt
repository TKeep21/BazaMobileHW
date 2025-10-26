interface NoteProtocol : CanvasUnit {
    fun willRemove()
    fun update(data: IdentifiableModel)
    fun getAll(): List<IdentifiableModel>
}