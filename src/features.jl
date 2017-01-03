function allfeatures()
    Feature[
        @feature((scrabble_score(word) == j for j in 1:26), "has scrabble score $j")
        @feature((c in word for c in 'a':'z'), "contains '$c'")
        @feature((length(word) >= j && word[j] == c for c in 'a':'z', j in 1:12), "contains '$c' at index $j")
        @feature((length(word) >= j && word[end - j + 1] == c for c in 'a':'z', j in 1:6), "contains '$c' at index $j from end")
        @feature((num_unique_vowels(letter_tallies(word)) == j for j in 1:5), "has $j unique vowels")
        @feature((num_unique_consonants(letter_tallies(word)) == j for j in 1:15), "has $j unique consonants")
        @feature((num_unique_letters(letter_tallies(word)) == j for j in 1:26), "has $j unique letters")
        @feature((vowel_pattern(word, (true, false)) || vowel_pattern(word, (false, true))), "alternates consonant vowel")
        @feature((vowel_pattern(word, p) for p in ((true, false), 
                                                   (false, true))), "has vowel/consonant pattern $p")
        @feature((num_double_letters(word) == j for j in 1:3), "contains $j double letters")
        @feature((num_repeats(letter_tallies(word), i) == j for j in 1:5, i in 2:4), "has $j letters repeated at least $i times each")
        @feature((num_repeats_strict(letter_tallies(word), i) == j for j in 1:5, i in 2:4), "has $j letters repeated exactly $i times each")
        @feature((num_repeats(letter_tallies(word), i) >= j for j in 1:5, i in 2:4), "has at least $j letters repeated at least $i times each")
        @feature((num_repeats_strict(letter_tallies(word), i) >= j for j in 1:5, i in 2:4), "has at least $j letters repeated exactly $i times each")
        @feature(contains_repeated_consonant(letter_tallies(word)), "contains a repeated consonant")
        @feature(contains_repeated_vowel(letter_tallies(word)), "contains a repeated vowel")
        @feature(contains_day_of_week(word), "contains a day of the week abbreviation")
        @feature(is_hill(word), "is a hill word")
        @feature(is_valley(word), "is a valley word")
        @feature(word == reverse(word), "is a palindrome")
        @feature(is_pyramid(letter_tallies(word)), "is a pyramid word")
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
        @feature(ismatch(GREEK_REGEX, word), "contains a greek letter")
        @feature((longest_vowel_streak(word) == j for j in 2:5), "has $j vowels in a row")
        @feature((longest_vowel_streak(word) >= j for j in 2:5), "has at least $j vowels in a row")
        @feature((longest_consonant_streak(word) == j for j in 2:5), "has $j consonants in a row")
        @feature((longest_consonant_streak(word) >= j for j in 2:5), "has at least $j consonants in a row")
        @feature((num_morse_bits(letter_tallies(word)) == j for j in 1:10), "has $j morse bits ('i's and 't's)")
        @feature((num_morse_bits(letter_tallies(word)) >= j for j in 1:5), "has at least $j morse bits ('i's and 't's)")
        @feature(ismatch(ENTIRELY_ELEMENTS_REGEX, word), "can be completely broken down into chemical element symbols")
        @feature(ismatch(ENTIRELY_STATES_REGEX, word), "can be completely broken down into US state abbreviations")
        @feature((num_state_abbreviations(word) == j for j in 1:5), "contains $j US state abbreviations")
        @feature(in(word, MA_BELL_EXCHANGES_SET), "is a Ma Bell recommended telephone exchange name")
        ]
end

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

const ALPHABET = 'a':'z'
const VOWELS = UInt8[c - 'a' + 1 for c in "aeiouy"]
const CONSONANTS = UInt8[c - 'a' + 1 for c in "bcdfghjklmnpqrstvwxyz"]
const VOWELS_SET = Set(ALPHABET[VOWELS])
const CONSONANTS_SET = Set(ALPHABET[CONSONANTS])
const ELEMENT_DATA = readdlm(joinpath(Pkg.dir("Collective"), "data", "elements.tsv"), '\t', String, skipstart=1)
const ELEMENTAL_SYMBOLS = lowercase.(strip.(ELEMENT_DATA[:,2]))
const STATES_DATA = readdlm(joinpath(Pkg.dir("Collective"), "data", "states.tsv"), '\t', String, skipstart=1)
const STATE_ABBREVIATIONS = strip.(lowercase.(STATES_DATA[:,2]))

parenwrap(s) = "($s)"

const SINGLE_ELEMENT_REGEX = Regex("$(join((parenwrap(s) for s in ELEMENTAL_SYMBOLS), '|'))")
const ENTIRELY_ELEMENTS_REGEX = Regex("^($(join((parenwrap(s) for s in ELEMENTAL_SYMBOLS), '|')))*\$")

const SINGLE_STATE_REGEX = Regex("$(join((parenwrap(s) for s in STATE_ABBREVIATIONS), '|'))")
const ENTIRELY_STATES_REGEX = Regex("^($(join((parenwrap(s) for s in STATE_ABBREVIATIONS), '|')))*\$")

const GREEK_REGEX = r"(alpha)|(beta)|(gamma)|(delta)|(epsilon)|(zeta)|(eta)|(theta)|(iota)|(kappa)|(lambda)|(mu)|(nu)|(omicron)|(pi)|(rho)|(sigma)|(tau)|(upsilon)|(phi)|(chi)|(psi)|(omega)"

const MA_BELL_EXCHANGES_SET = Set(lowercase.(readdlm(joinpath(Pkg.dir("Collective"), "data", "ma_bell_exchanges.tsv"), '\t', String)))

isconsonant(char) = char in CONSONANTS_SET
isvowel(char) = char in VOWELS_SET


function num_unique_vowels(tallies)
    c = 0
    for x in VOWELS
        c += (tallies[x] > 0)
    end
    c
end

function num_unique_consonants(tallies)
    c = 0
    for x in CONSONANTS
        c += (tallies[x] > 0)
    end
    c
end

function num_unique_letters(tallies)
    c = 0
    for t in tallies
        c += (t > 0)
    end
    c
end

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
        tallies[convert(UInt8, c - 'a' + 1)] += 1
    end
    tallies
end

function num_repeats_strict(tallies, n)
    c = 0
    for t in tallies
        c += (t == n)
    end
    c
end

function num_repeats(tallies, n)
    c = 0
    for t in tallies
        c += (t >= n)
    end
    c
end

function contains_repeated_consonant(tallies)
    for x in CONSONANTS
        if tallies[x] > 1
            return true
        end
    end
    false
end

function contains_repeated_vowel(tallies)
    for x in VOWELS
        if tallies[x] > 1
            return true
        end
    end
    false
end

contains_day_of_week(word) = ismatch(r"(sat)|(sun)|(mon)|(tue)|(wed)|(thu)|(fri)", word)

"""
Letters are alpha, then reverse alpha
"""
function is_hill(word)
    has_rise = false
    has_fall = false
    rising = true
    for i in 1:(length(word) - 1)
        if word[i + 1] > word[i]
            if !rising
                return false
            end
            has_rise = true
        elseif word[i + 1] < word[i]
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
    has_rise = false
    has_fall = false
    rising = false
    for i in 1:(length(word) - 1)
        if word[i + 1] < word[i]
            if rising
                return false
            end
            has_fall = true
        elseif word[i + 1] > word[i]
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
function is_pyramid(tallies)
    nonzero_tallies = Int[t for t in tallies if t > 0]
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

function longest_vowel_streak(word)
    current_streak = 0
    longest_streak = 0
    for c in word
        if isvowel(c)
            current_streak += 1
            if current_streak > longest_streak
                longest_streak = current_streak
            end
        else
            current_streak = 0
        end
    end
    longest_streak
end

function longest_consonant_streak(word)
    current_streak = 0
    longest_streak = 0
    for c in word
        if isconsonant(c)
            current_streak += 1
            if current_streak > longest_streak
                longest_streak = current_streak
            end
        else
            current_streak = 0
        end
    end
    longest_streak
end

num_morse_bits(tallies) = tallies['t' - 'a' + 1] + tallies['i' - 'a' + 1]

function num_elemental_symbols(word)
    i = 0
    foreach(m -> i += 1, eachmatch(SINGLE_ELEMENT_REGEX, word, true))
    i
end

function num_state_abbreviations(word)
    i = 0
    foreach(m -> i += 1, eachmatch(SINGLE_STATE_REGEX, word, true))
    i
end
