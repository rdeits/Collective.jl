__precompile__()

module Collective

import Base: size, getindex, isless
using HypothesisTests: BinomialTest, pvalue

include("features.jl")

type Corpus
    features::FeatureSet
    frequencies::Vector{Float64}
end
function Corpus(words::AbstractArray{String})
    features = FeatureSet(allfeatures())
    frequencies = sum(features.evaluate(lowercase(word)) for word in words) / length(words)
    Corpus(features, frequencies)
end

immutable FeatureResult
    description::String
    satisfied::BitArray{1}
    probability::Float64
end

isless(f1::FeatureResult, f2::FeatureResult) = f1.probability < f2.probability

binomial_probability(successes, trials, frequency) = pvalue(BinomialTest(successes, trials, frequency))

function analyze(corpus::Corpus, words::AbstractArray{String})
    match = corpus.features.evaluate.(lowercase.(words))
    num_matches = sum(match)
    probabilities = binomial_probability.(num_matches, length(words), corpus.frequencies)
    FeatureResult.(corpus.features.descriptions, [[m[i] for m in match] for i in 1:length(corpus.features.descriptions)], probabilities)
end


end
