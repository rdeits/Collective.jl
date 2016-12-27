function scrabble_score(word::String)
    score = 0
    for c in word
        score += scrabble_score(c)
    end
    score
end

scrabble_score(char::Char) = SCRABBLE_SCORES[char]

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

const VOWELS = Set(collect("aeiouy"))
const CONSONANTS = Set(collect("bcdfghjklmnpqrstvwxyz"))
isconsonant(char) = char in CONSONANTS
isvowel(char) = char in VOWELS

num_unique_vowels(word) = length(Set(filter(isvowel, word)))
num_unique_consonants(word) = length(Set(filter(isconsonant, word)))
num_unique_letters(word) = length(Set(word))
alternates_consonant_vowel(word) = consonant_then_vowel(word) || vowel_then_consonant(word)
function consonant_then_vowel(word)
    expected = true
    for c in word
        if isconsonant(c) != expected
            return false
        end
        expected = !expected
    end
    true
end
function vowel_then_consonant(word)
    expected = true
    for c in word
        if isvowel(c) != expected
            return false
        end
        expected = !expected
    end
    true
end
function contains_double_letter(word)
    for i in 1:(length(word) - 1)
        if word[i] == word[i+1]
            return true
        end
    end
    return false
end

function contains_repeated_letter(word)
    for i in 1:length(word) - 1
        for j in (i + 1):length(word)
            if word[i] == word[j]
                return true
            end
        end
    end
    return false
end

contains_day_of_week(word) = ismatch(r"(sat)|(sun)|(mon)|(tue)|(wed)|(thu)|(fri)", word)


function allfeatures()
    Feature[
        @feature((scrabble_score(word) == j for j in 1:26), "scrabble score $j")
        @feature((c in word for c in 'a':'z'), "contains $c")
        @feature((length(word) >= j && word[j] == c for c in 'a':'z', j in 1:26), "contains $c at index $j")
        @feature((length(word) >= j && word[end - j + 1] == c for c in 'a':'z', j in 1:26), "contains $c at index $j from end")
        @feature((num_unique_vowels(word) == j for j in 1:5), "$j unique vowels")
        @feature((num_unique_consonants(word) == j for j in 1:21), "$j unique consonants")
        @feature((num_unique_letters(word) == j for j in 1:26), "$j unique letters")
        @feature((alternates_consonant_vowel(word)), "alternates consonant vowel")
        @feature((contains_double_letter(word)), "contains double letter")
        @feature((contains_repeated_letter(word)), "contains repeated letter")
        @feature((contains_day_of_week(word)), "contains day of the week abbreviation")
        ]
end
