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

const VOWELS = "aeiouy"
const CONSONANTS = "bcdfghjklmnpqrstvwxyz"
const VOWELS_SET = Set(collect(VOWELS))
const CONSONANTS_SET = Set(collect(CONSONANTS))
isconsonant(char) = char in CONSONANTS_SET
isvowel(char) = char in VOWELS_SET

num_unique_vowels(word) = length(Set(filter(isvowel, word)))
num_unique_consonants(word) = length(Set(filter(isconsonant, word)))
num_unique_letters(word) = length(Set(word))

function vowel_pattern(word, pattern)
    i = 1
    for c in word
        if pattern[i]
            if !isvowel(c)
                return false
            end
        else
            if !isconsonant(c)
                return false
            end
        end
        if i == length(pattern)
            i = 1
        else
            i += 1
        end
    end
    true
end

function num_double_letters(word)
    c = 0
    for i in 1:(length(word) - 1)
        if word[i] == word[i+1]
            c += 1
        end
    end
    c
end

function letter_tallies(word)
    tallies = zeros(UInt8, 26)
    for c in word
        tallies[convert(UInt8, c - 96)] += 1
    end
    tallies
end

function num_repeated_letters(word)
    tallies = letter_tallies(word)
    c = 0
    for t in tallies
        if t > 1
            c += 1
        end
    end
    c
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

function contains_repeated_consonant(word)
    for i in 1:length(word) - 1
        if isconsonant(word[i])
            for j in (i + 1):length(word)
                if word[i] == word[j]
                    return true
                end
            end
        end
    end
    return false
end

function contains_repeated_vowel(word)
    for i in 1:length(word) - 1
        if isvowel(word[i])
            for j in (i + 1):length(word)
                if word[i] == word[j]
                    return true
                end
            end
        end
    end
    return false
end

contains_day_of_week(word) = ismatch(r"(sat)|(sun)|(mon)|(tue)|(wed)|(thu)|(fri)", word)

"""
Letters are alpha, then reverse alpha
"""
function is_hill(word)
    diffs = diff(collect(word))
    has_rise = false
    has_fall = false
    rising = true
    for d in diffs
        if d > 0
            if !rising
                return false
            end
            has_rise = true
        elseif d < 0
            rising = false
            has_fall = true
        end
    end
    has_rise && has_fall
end

"""
Letters are reverse alpha, then alpha
"""
function is_valley(word)
    diffs = diff(collect(word))
    has_rise = false
    has_fall = false
    rising = false
    for d in diffs
        if d < 0
            if rising
                return false
            end
            has_fall = true
        elseif d > 0
            rising = true
            has_rise = true
        end
    end
    has_rise && has_fall
end

function is_sequential(a::AbstractArray)
    for i in 1:(length(a) - 1)
        a[i+1] == a[i] + 1 || return false
    end
    true
end

"""
Letter tally is 1, 2, 3, etc.
"""
function is_pyramid(word)
    letter_tallies = zeros(Int, 26)
    for c in word
        letter_tallies[c - 'a' + 1] += 1
    end
    nonzero_tallies = Int[t for t in letter_tallies if t > 0]
    is_sequential(sort!(nonzero_tallies))
end

function num_alpha_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] < word[i + 1]
            count += 1
        end
    end
    count
end

function num_reverse_alpha_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] > word[i + 1]
            count += 1
        end
    end
    count
end

function num_sequential_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] + 1 == word[i+1]
            count += 1
        end
    end
    count
end

function num_reverse_sequential_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] - 1 == word[i+1]
            count += 1
        end
    end
    count
end

function num_cardinal_directions(word)
    num_n = 0
    num_e = 0
    num_s = 0
    num_w = 0
    for c in word
        num_n += c == 'n'
        num_e += c == 'e'
        num_s += c == 's'
        num_w += c == 'w'
    end
    num_n + num_e + num_s + num_w
end

function allfeatures()
    Feature[
        @feature((scrabble_score(word) == j for j in 1:26), "has scrabble score $j")
        @feature((c in word for c in 'a':'z'), "contains '$c'")
        @feature((length(word) >= j && word[j] == c for c in 'a':'z', j in 1:12), "contains '$c' at index $j")
        @feature((length(word) >= j && word[end - j + 1] == c for c in 'a':'z', j in 1:6), "contains '$c' at index $j from end")
        @feature((num_unique_vowels(word) == j for j in 1:5), "has $j unique vowels")
        @feature((num_unique_consonants(word) == j for j in 1:21), "has $j unique consonants")
        @feature((num_unique_letters(word) == j for j in 1:26), "has $j unique letters")
        @feature((vowel_pattern(word, (true, false)) || vowel_pattern(word, (false, true))), "alternates consonant vowel")
        @feature((vowel_pattern(word, p) for p in ((true, false), 
                                                   (false, true))), "has vowel/consonant pattern $p")
        @feature((num_double_letters(word) == j for j in 1:3), "contains $j double letters")
        @feature((num_repeated_letters(word) == j for j in 1:7), "contains $j repeated letters")
        @feature((num_repeated_letters(word) >= j for j in 1:5), "contains at least $j repeated letters")
        @feature(contains_repeated_consonant(word), "contains a repeated consonant")
        @feature(contains_repeated_vowel(word), "contains a repeated vowel")
        @feature(contains_day_of_week(word), "contains a day of the week abbreviation")
        @feature(is_hill(word), "is a hill word")
        @feature(is_valley(word), "is a valley word")
        @feature(word == reverse(word), "is a palindrome")
        @feature(is_pyramid(word), "is a pyramid word")
        @feature((num_alpha_bigrams(word) == j for j in 0:10), "has $j alphabetical bigrams")
        @feature((num_alpha_bigrams(word) >= j for j in 1:10), "has at least $j alphabetical bigrams")
        @feature((num_reverse_alpha_bigrams(word) == j for j in 0:10), "has $j reverse alphabetical bigrams")
        @feature((num_reverse_alpha_bigrams(word) >= j for j in 1:10), "has at least $j reverse alphabetical bigrams")
        @feature((num_sequential_bigrams(word) == j for j in 0:10), "has $j sequential bigrams")
        @feature((num_sequential_bigrams(word) >= j for j in 1:10), "has at least $j sequential bigrams")
        @feature((num_reverse_sequential_bigrams(word) == j for j in 0:10), "has $j reverse sequential bigrams")
        @feature((num_reverse_sequential_bigrams(word) >= j for j in 1:10), "has at least $j reverse sequential bigrams")
        @feature((num_cardinal_directions(word) == j for j in 1:6), "has $j cardinal direction abbreviations (NESW)")
        @feature((num_cardinal_directions(word) >= j for j in 1:6), "has at least $j cardinal direction abbreviations (NESW)")
        ]
end
