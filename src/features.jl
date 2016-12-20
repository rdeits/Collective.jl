abstract Feature
size(::Feature) = ()
getindex(f::Feature, ::CartesianIndex{0}) = f

const FEATURES = []

function allfeatures()
    return FEATURES
end

macro addfeatures(T, expr)
    quote
        addfeatures(::Type{$T}) = $(esc(expr))
        append!(FEATURES, addfeatures($T))
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

isconsonant(char) = match(r"[bcdfghjklmnpqrstvwxyz]", char)
isvowel(char) = match(r"[aeiouy]", char)

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
