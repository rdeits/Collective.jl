macro feature(ex, description::String="")
    Expr(:call, :Feature, Expr(:quote, ex), Expr(:quote, Expr(:quote, description)))
end

macro feature(ex, description::Expr)
    Expr(:call, :Feature, Expr(:quote, ex), Expr(:quote, description))
end

cacheify!(setup, expr, input_var::Symbol) = expr

function cacheify!(setup::Vector{Expr}, expr::Expr, input_var::Symbol)
    if expr.head == :call && length(expr.args) == 2 && expr.args[2] == input_var
        cached_varname = gensym(expr.args[1])
        push!(setup, :($cached_varname = $(copy(expr))))
        cached_varname
    else
        for (i, child) in enumerate(expr.args)
            expr.args[i] = cacheify!(setup, child, input_var)
        end
        expr
    end
end

function cacheify(expr::Expr, var::Symbol)
    setup = Expr[]
    expr = cacheify!(setup, expr, var)
    Expr(:block, setup..., expr)
end

immutable Feature
    expr::Expr
    args::Vector{Tuple{Symbol, Expr}}
    length::Int
    description::Expr
    function Feature(expr::Expr, description::Expr)
        args = Tuple{Symbol, Expr}[]
        if expr.head == :generator
            rhs = expr.args[1]
            for ex in expr.args[2:end]
                @assert ex.head == :(=)
                push!(args, (ex.args[1], ex.args[2]))
            end
            len = prod(length(eval(ex[2])) for ex in args)
        else
            rhs = expr
            len = 1
        end
        new(rhs, args, len, description)
    end
end

immutable FeatureSet{F}
    features::Vector{Feature}
    evaluate::F
    descriptions::Vector{String}
end

function loop_over(args::Vector{Tuple{Symbol, Expr}}, inner::Expr)
    for (var, expr) in reverse(args)
        inner = quote
        for $var in $expr
            $inner
        end
    end
end
inner
end


function compile_test(features::Vector{Feature})
    num_features = sum([f.length for f in features])
    values = gensym(:values)
    loop_var = gensym(:i)
    result = quote
        $values = falses($(num_features))
        $loop_var = 1
    end
    for (i, feat) in enumerate(features)
        inner = quote
            $values[$loop_var] = $(feat.expr)
            $loop_var += 1
        end
        push!(result.args, loop_over(feat.args, inner))
    end
    push!(result.args, values)
    result = cacheify(result, :word)
    # println(result)
    result
end

function compile_descriptions(features::Vector{Feature})
    num_features = sum([f.length for f in features])
    values = gensym(:values)
    loop_var = gensym(:i)
    result = quote
        $values = Vector{String}($(num_features))
        $loop_var = 1
    end
    for (i, feat) in enumerate(features)
        inner = quote
            $values[$loop_var] = $(feat.description)
            $loop_var += 1
        end
        push!(result.args, loop_over(feat.args, inner))
    end
push!(result.args, values)
result
end

function FeatureSet(features)
    test_expr = compile_test(features)
    description_expr = compile_descriptions(features)
    FeatureSet(features,
        eval(:((word) -> $(test_expr))),
        eval(:(() -> $(description_expr)))())
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
        ]
end
