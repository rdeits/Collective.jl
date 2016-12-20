type Statistics
    word::String
    length::Int
    scrabble_score::Int
    num_unique_vowels::Int
    num_unique_consonants::Int
    num_unique_letters::Int

    function Statistics(word)
        word = lowercase(word)
        stat = new(word)
        stat.length = length(word)
        stat.scrabble_score = scrabble_score(word)
        stat.num_unique_vowels = length(Set(filter(isvowel, word)))
        stat.num_unique_consonants = length(Set(filter(isconsonant, word)))
        stat.num_unique_letters = length(Set(word))
        stat
    end
end

function scrabble_score(word::String)
    sum(scrabble_score(c) for c in word)
end

const SCRABBLE_SCORES = Dict{Char, Int}(
    'e' => 1,
    'a' => 1,
    'i' => 1,
    'o' => 1,
    'n' => 1,
    'r' => 1,
    't' => 1,
    'l' => 1,
    's' => 1,
    'u' => 1,
    'd' => 2,
    'g' => 2,
    'b' => 3,
    'c' => 3,
    'm' => 3,
    'p' => 3,
    'f' => 4,
    'h' => 4,
    'v' => 4,
    'w' => 4,
    'y' => 4,
    'k' => 5,
    'j' => 8,
    'x' => 8,
    'q' => 10,
    'z' => 10
)

scrabble_score(char::Char) = SCRABBLE_SCORES[char]
