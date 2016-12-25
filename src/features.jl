abstract Feature
size(::Feature) = ()
getindex(f::Feature, ::CartesianIndex{0}) = f

const FEATURES = Feature[]

function allfeatures()
    return FEATURES
end

macro addfeatures(T, expr)
    quote
        allfeatures(::Type{$T}) = $(esc(expr))
        append!(FEATURES, allfeatures($T))
    end
end

immutable ContainsLetter <: Feature
    letter::Char
end
@addfeatures ContainsLetter [ContainsLetter(l) for l in 'a':'z']
satisfies(f::ContainsLetter, stat) = f.letter in stat.word

immutable LetterAtIndex <: Feature
    letter::Char
    index::Int
end
@addfeatures LetterAtIndex [LetterAtIndex(l, j) for l in 'a':'z' for j in 1:26]
satisfies(f::LetterAtIndex, stat) = length(stat.word) >= f.index && stat.word[f.index] == f.letter

immutable LetterAtIndexFromEnd <: Feature
    letter::Char
    index::Int
end
@addfeatures LetterAtIndexFromEnd [LetterAtIndexFromEnd(l, j) for l in 'a':'z' for j in 1:26]
satisfies(f::LetterAtIndexFromEnd, stat) = length(stat.word) >= f.index && stat.word[end - f.index + 1] == f.letter

VOWELS = Set(collect("aeiouy"))
CONSONANTS = Set(collect("bcdfghjklmnpqrstvwxyz"))
isconsonant(char) = char in CONSONANTS
isvowel(char) = char in VOWELS

immutable AlternatesConsonantVowel <: Feature
end
@addfeatures AlternatesConsonantVowel [AlternatesConsonantVowel()]
satisfies(f::AlternatesConsonantVowel, stat) =
    ismatch(r"^([bcdfghjklmnpqrstvwxyz][aeiouy])+[bcdfghjklmnpqrstvwxyz]?$", stat.word) ||
    ismatch(r"^([aeiouy][bcdfghjklmnpqrstvwxyz])+[aeiouy]?$", stat.word)

immutable Length <: Feature
    length::Int
end
@addfeatures Length [Length(i) for i in 1:26]
satisfies(f::Length, stat) = stat.length == f.length

immutable ScrabbleScore <: Feature
    score::Int
end
@addfeatures ScrabbleScore [ScrabbleScore(i) for i in 1:30]
satisfies(f::ScrabbleScore, stat) = stat.scrabble_score == f.score

immutable NumUniqueVowels <: Feature
    n::Int
end
@addfeatures NumUniqueVowels [NumUniqueVowels(i) for i in 1:6]
satisfies(f::NumUniqueVowels, stat) = stat.num_unique_vowels == f.n

immutable NumUniqueConsonants <: Feature
    n::Int
end
@addfeatures NumUniqueConsonants [NumUniqueConsonants(i) for i in 1:6]
satisfies(f::NumUniqueConsonants, stat) = stat.num_unique_consonants == f.n

immutable NumUniqueLetters <: Feature
    n::Int
end
@addfeatures NumUniqueLetters [NumUniqueLetters(i) for i in 1:10]
satisfies(f::NumUniqueLetters, stat) = stat.num_unique_letters == f.n
