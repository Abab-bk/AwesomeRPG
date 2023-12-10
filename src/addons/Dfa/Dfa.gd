class_name DFA extends Node

const DEFAULT_BLOCK_WORDS_PATH: String = "res://addons/Dfa/DefaultBlockWords.txt"


class DFAState:
    var is_final: bool = false
    var transitions: Dictionary = {}


class WordFilterDFA:
    var root: DFAState


    func _init(blocked_words: Array = []):
        root = DFAState.new()

        for word in blocked_words:
            add_word(word)


    func add_word(word: String):
        var current_state = root

        for char in word:
            if not current_state.transitions.has(char):
                current_state.transitions[char] = DFAState.new()
            current_state = current_state.transitions[char]

        current_state.is_final = true


    func load_blocked_words_from_file(filePath: String):
        var _file = FileAccess.open(filePath, FileAccess.READ)
        if _file.file_exists(filePath):
            var file = FileAccess.open(filePath, FileAccess.READ)
            var fileContent: String = file.get_as_text()
            file.close()
            
            var blockedWords: PackedStringArray = fileContent.replace("\r", "").split("\n")
            _init(blockedWords)
        else:
            print("File not found:", filePath)


    func contains_blocked_word(text: String) -> bool:
        var current_state = root

        for char in text:
            if current_state.transitions.has(char):
                current_state = current_state.transitions[char]
                if current_state.is_final:
                    return true
            else:
                current_state = root

        return false


func is_block_word(word: String) -> bool:
    var word_filter_dfa = WordFilterDFA.new()

    word_filter_dfa.load_blocked_words_from_file(DEFAULT_BLOCK_WORDS_PATH)

    return word_filter_dfa.contains_blocked_word(word)
