__precompile__()

module Collective

import Base: size, getindex, isless

include("statistics.jl")
include("features.jl")

function frequency(feature::Feature, stats::AbstractArray{Statistics})
    sum(satisfies.(feature, stats)) / length(stats)
end

type Corpus
    features::Vector{Feature}
    frequencies::Vector{Float64}
end
function Corpus(words::AbstractArray{String})
    features = allfeatures()
    stats = Statistics.(lowercase.(words))
    frequencies = Float64[frequency(f, stats) for f in features]
    Corpus(features, frequencies)
end

immutable FeatureResult
    feature::Feature
    satisfied::Vector{Bool}
    frequency::Float64
end

isless(f1::FeatureResult, f2::FeatureResult) = f1.frequency < f2.frequency

function summarize(feature::Feature, frequency::Float64, words::AbstractArray{String})
    stats = Statistics.(lowercase.(words))
    sat = Vector{Bool}(length(stats))
    total_freq = 1.0
    for i in 1:length(stats)
        if satisfies(feature, stats[i])
            sat[i] = true
            total_freq *= frequency
        else
            sat[i] = false
            total_freq *= (1 - frequency)
        end
    end
    FeatureResult(feature, sat, binomial(length(sat), sum(sat)) * total_freq)
end

function analyze(corpus::Corpus, words::AbstractArray{String})
    results = FeatureResult[summarize(corpus.features[i], corpus.frequencies[i], words) for i in 1:length(corpus.features)]
end


end
