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
    expr = cacheify!(setup, copy(expr), var)
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

function compile_evaluators(features::Vector{Feature})
    num_features = sum([f.length for f in features])
    values = gensym(:values)
    loop_var = gensym(:i)
    result = quote
        $values = Vector{Function}($(num_features))
        $loop_var = 1
    end
    for (i, feat) in enumerate(features)
        inner = quote
            $values[$loop_var] = (word) -> $(feat.expr)
            $loop_var += 1
        end
        push!(result.args, loop_over(feat.args, inner))
    end
    push!(result.args, values)
    result
end

immutable FeatureSet{F}
    features::Vector{Feature}
    evaluate::F
    evaluators::Vector{Function}
    descriptions::Vector{String}
end

function FeatureSet(features)
    test_expr = compile_test(features)
    evaluators_expr = compile_evaluators(features)
    description_expr = compile_descriptions(features)
    FeatureSet(features,
        eval(:((word) -> $(test_expr))),
        eval(:(() -> $(evaluators_expr)))(),
        eval(:(() -> $(description_expr)))())
end
