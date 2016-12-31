# Collective

[![Build Status](https://travis-ci.org/rdeits/Collective.jl.svg?branch=master)](https://travis-ci.org/rdeits/Collective.jl)
[![codecov.io](http://codecov.io/github/rdeits/Collective.jl/coverage.svg?branch=master)](http://codecov.io/github/rdeits/Collective.jl?branch=master)

Collective is a Julia package designed to identify interesting *features* from a collection of words. This is a common mechanic in puzzles you might find at, for example, the MIT Mystery Hunt. 

## Features

A *feature* is just a boolean property of a word, like `"contains the letter 'a'"` or `"is a palindrome"`. Many features can also include scalar quantities. For example, we might want to compute a family of features for a word's Scrabble score. Those features would look like: `"scrabble score == 1"`, `"scrabble score == 2"`, ..., `"scrabble score == n".` 

## Interestingness

A particular set of words can satisfy many features. For example, if I give you the list of words: `["questionable", "businesswoman", "exhaustion", "discouraged", "communicated", "hallucinogen", "sequoia"]`, you might tell me that they all contain the letter 'a'. That's true, but it's much more interesting to notice that they all contain *all 5 vowels*. We measure this degree of interestingness using the standard binomial probability distribution: given `n` words, we can compute the probability that `k` of them satisfy some feature `F` as:

	(n choose k) * f^k * (1 - f)^(n - k)

where `f` is the frequency with wich feature `F` occurs in the population of words (in this case, the dictionary). The most interesting feature is the one whose probability of `k` occurrences is smallest. 

# Examples

## Basic Usage

As always, the first thing we need to do is load the package:

```julia
julia> using Collective
```

To determine the frequency distribution of each feature, we'll need a population of English words:

```julia
julia> const words = wordlist(open("/usr/share/dict/words"))
```

Constructing a `Corpus` does all the hard work of compiling functions for every feature and testing their frequencies (this will take a few seconds):

```julia
julia> corpus = Corpus(words)
Corpus with 752 features
```

Now we can use that corpus to solve puzzles. Here's a set of words:

```julia
julia> puzzle = ["questionable", "businesswoman", "exhaustion", "discouraged", "communicated", "hallucinogen", "sequoia"]
```

We can run the feature statistics with `analyze()`:

```julia
julia> results = analyze(corpus, puzzle)
```

Analyze returns a vector of `FeatureResult`s, each of which contains:

	* A human-readable description of the feature
	* A function to evaluate that feature
	* The number of words in the puzzle which match that feature
	* The binomial probability of that number of matches

To get the best features, we can just sort that list:

```julia
julia> for r in sort(results)[1:5]
           println(r)
       end
Feature: 7/7 matches, p=9.557960209111938e-10: has 5 unique vowels
Feature: 5/7 matches, p=0.00014320447809066083: has 10 unique letters
Feature: 7/7 matches, p=0.0003462662041256388: contains 'u'
Feature: 3/7 matches, p=0.0009726511521148434: contains 'u' at index 5
Feature: 2/7 matches, p=0.004751757839289005: contains 'q'
```

That first feature has a probability of about 1 in 1 billion. It's extremely unlikely that 7 randomly chosen words would have 5 unique vowels each. So that's the feature we should use for whatever the next step of the puzzle is! 

If we don't want the whole sorted list of features, we can just get the single best one:

```julia
julia> best_feature, index = findmin(results)
julia> println(best_feature)
Feature: 7/7 matches, p=9.557960209111938e-10: has 5 unique vowels
```

## Clustering

Collective also knows how to cluster words. Specifically, given a list of M words, and a number N < M, it will try to find the group of N words which are related by a single very interesting feature. For example:

```julia
julia>  puzzle = shuffle(["hugoweaving",
                          "mountaindew",
                          "mozambique",
                          "sequoia",
                          "annotation",
                          "artificial",
                          "individual",
                          "omnivorous",
                          "onlocation",
                          "almost",
                          "biopsy",
                          "chimp",
                          "films",
                          "ghost",
                          "tux",
                          "balked",
                          "highnoon",
                          "posted"])
julia> cluster, feature = best_cluster(corpus, puzzle, 6)
(String["biopsy","films","chimp","almost","tux","ghost"],Feature: 0/6 matches, p=1.5216925912448385e-15: has at least 1 reverse alphabetical bigrams)
```

This one will require some interpretation. The 6 words which were identified are: `["biopsy","films","chimp","almost","tux","ghost"]`. The feature which was returned says that 0 out of the 6 words has one or more reverse alphabetical bigrams, and that the probability of such an occurrence is 1 in 1.5e-15. Putting it another way, it says that *every* word had only alphabetical bigrams, or, more plainly, every word has all of its letters in alphabetical order. This is a cool effect of using the real binomial probabilities: it can sometimes be interesting to find that *none* of a group of words satisfies a particular feature if that feature is usually very common. 

## More Demos

Check out the test cases in `test/puzzles` for a variety of real puzzle words and their detected features. 

