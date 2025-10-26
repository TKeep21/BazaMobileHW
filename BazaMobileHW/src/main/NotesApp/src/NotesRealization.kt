import kotlin.reflect.KClass

abstract class Note<Data : IdentifiableModel>(
    var data: Data,
    private val storage: Storage<Data>,
    private val dataClass: KClass<Data>
) : NoteProtocol {
    override val id: String
        get() = data.id

    init {
        storage.add(data)
    }

    override fun update(newData: IdentifiableModel) {
        if (dataClass.isInstance(newData)) {
            @Suppress("UNCHECKED_CAST")
            this.data = newData as Data
            storage.update(this.data)
        }
    }

    override fun willRemove() {
        storage.removeById(data.id)
    }

    override fun getAll(): List<IdentifiableModel> {
        return listOf(data)
    }

    override fun drawCanvas(): String {
        return "Базовая заметка ${data.id}"
    }
}

data class TextNoteModel(
    override val id: String,
    var name: String,
    var text: String
) : IdentifiableModel

data class ReminderNoteModel(
    override val id: String,
    var text: String,
    var isDone: Boolean
) : IdentifiableModel


class TextNote(
    data: TextNoteModel,
    storage: Storage<TextNoteModel>
) : Note<TextNoteModel>(data, storage, TextNoteModel::class) {
    override fun drawCanvas(): String {
        return "Текстовая заметка с именем ${data.name} содержит: ${data.text}"
    }
}

class ReminderNote(
    data: ReminderNoteModel,
    storage: Storage<ReminderNoteModel>
) : Note<ReminderNoteModel>(data, storage, ReminderNoteModel::class) {
    override fun drawCanvas(): String {
        return "Задача ${data.text} ${if (data.isDone) "выполнена" else "не выполнена"}"
    }
}
