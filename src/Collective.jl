__precompile__()

module Collective

import Base: size, getindex, isless
using HypothesisTests: BinomialTest, pvalue

include("feature_expressions.jl")
include("features.jl")

type Corpus
    features::FeatureSet
    frequencies::Vector{Float64}
end

function Corpus(words::AbstractArray{String}, features=allfeatures())
    featureset = FeatureSet(features)
    frequencies = sum(featureset.evaluate(lowercase(word)) for word in words) / length(words)
    Corpus(featureset, frequencies)
end

immutable FeatureResult
    description::String
    evaluate::Function
    satisfied::BitArray{1}
    probability::Float64
end

(r::FeatureResult)(word::String) = r.evaluate(word)

isless(f1::FeatureResult, f2::FeatureResult) = f1.probability < f2.probability

binomial_probability(successes, trials, frequency) = pvalue(BinomialTest(successes, trials, frequency))

function analyze(corpus::Corpus, words::AbstractArray{String})
    match = corpus.features.evaluate.(lowercase.(words))
    num_matches = sum(match)
    probabilities = binomial_probability.(num_matches, length(words), corpus.frequencies)
    FeatureResult.(corpus.features.descriptions, corpus.features.evaluators, [[m[i] for m in match] for i in 1:length(corpus.features.descriptions)], probabilities)
end


end
