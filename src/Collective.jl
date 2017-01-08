__precompile__()

module Collective

import Base: size, getindex, isless, show
using Iterators: subsets
using DataStructures: OrderedDict

export Corpus, 
       wordlist,
       analyze,
       best_feature,
       best_cluster,
       best_clusters,
       common_features

cleanup(s::String) = replace(lowercase(strip(s)), r"[^a-z]", "")

wordlist(data::IO) = cleanup.(vec(readdlm(data, ',', String)))
wordlist(s::String) = wordlist(IOBuffer(s))

include("bitstally.jl")
import .BitsTallies: BitsTally, isanagram, istransaddition
include("feature_expressions.jl")
include("features.jl")

type Corpus{F}
    features::FeatureSet{F}
    frequencies::Vector{Float64}
end

show(io::IO, c::Corpus) = print(io, "Corpus with $(length(c.features.descriptions)) features")

function Corpus(words::AbstractArray{String}, features=allfeatures())
    featureset = FeatureSet(features)
    frequencies = sum(featureset.evaluate(lowercase(word)) for word in words) / length(words)
    frequencies = max.(frequencies, 1/length(words))
    Corpus(featureset, frequencies)
end

immutable FeatureResult
    description::String
    evaluate::Function
    satisfied::BitArray{1}
    probability::Float64
end

(r::FeatureResult)(word::String) = r.evaluate(word)

show(io::IO, r::FeatureResult) = print(io, "Feature: $(sum(r.satisfied))/$(length(r.satisfied)) matches, p=$(r.probability): $(r.description)")

isless(f1::FeatureResult, f2::FeatureResult) = f1.probability < f2.probability

binomial_probability(successes, trials, frequency) = binomial(trials, successes) * frequency^successes * (1 - frequency)^(trials - successes)

function binomial_pvalue(successes, trials, frequency)
    p = binomial_probability(successes, trials, frequency)
    expected = frequency * trials
    if successes > expected
        for k in (successes + 1):trials
            p += binomial_probability(k, trials, frequency)
        end
    else
        for k in 1:(successes - 1)
            p += binomial_probability(k, trials, frequency)
        end
    end
    p
end

function evaluate(corpus::Corpus, words::AbstractArray{String})
    corpus.features.evaluate.(lowercase.(words))
end

function analyze(corpus::Corpus, words::AbstractArray{String}, allowed_misses=length(words))
    match = evaluate(corpus, words)
    num_matches = sum(match)
    probabilities = binomial_pvalue.(num_matches, length(words), corpus.frequencies)
    results = FeatureResult.(corpus.features.descriptions, corpus.features.evaluators, [[m[i] for m in match] for i in 1:length(corpus.features.descriptions)], probabilities)
    required_matches = length(words) - allowed_misses
    [r for r in results if sum(r.satisfied) >= required_matches]
end

function best_feature(corpus::Corpus, words::AbstractArray{String})
    best_feature(corpus, evaluate(corpus, words))
end

function best_feature(corpus::Corpus, vals::AbstractArray{BitArray{1}})
    matches = sum(vals)
    n = length(vals)
    num_features = length(corpus.features.descriptions)
    p, i = findmin(Collective.binomial_pvalue(matches[i], n, corpus.frequencies[i]) for i in 1:num_features)
    FeatureResult(corpus.features.descriptions[i], 
                  corpus.features.evaluators[i],
                  [m[i] for m in vals],
                  p)
end

immutable Cluster
    words::Vector{String}
    feature::FeatureResult
end

isless(c1::Cluster, c2::Cluster) = c1.feature < c2.feature

function best_cluster(corpus::Corpus, words::AbstractArray{String}, n::Integer)
    vals = evaluate(corpus, words)
    x = Inf
    best_subset = Int[]
    for subset in subsets(collect(1:length(vals)), n)
        f = Collective.best_feature(corpus, vals[subset])
        p = f.probability
        if p < x
            x = p
            best_subset = subset
        end
    end
    Cluster(words[best_subset], best_feature(corpus, words[best_subset]))
end

best_clusters(corpus::Corpus, words::AbstractArray{String}) = 
    [best_cluster(corpus, words, n) for n in 2:div(length(words), 2) if length(words) % n == 0]

best_cluster(corpus::Corpus, words::AbstractArray{String}) = minimum(best_clusters(corpus, words))

function common_features(featureset::FeatureSet, words::AbstractArray{String})
    vals = featureset.evaluate.(lowercase.(words))
    common_indices = [i for i in 1:length(vals[1]) if all(v[i] for v in vals)]
    FeatureResult[
        FeatureResult(featureset.descriptions[i],
                      featureset.evaluators[i],
                      [m[i] for m in vals],
                      NaN) for i in common_indices]
end

common_features(corpus::Corpus, words::AbstractArray{String}) = 
    common_features(corpus.features, words)



end
