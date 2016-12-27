# MIT Mystery Hunt 2013 puzzle Wordplay 
# http://www.mit.edu/~puzzle/2013/coinheist.com/get_smart/wordplay/index.html

@testset "wordplay" begin
    words = lowercase.(strip.(split(readstring("../data/113809of.fic"))))
    corpus = Collective.Corpus(words[1:Int(round(length(words) / 10000)):end])

    function best_feature(wordlist)
        results = Collective.analyze(corpus, wordlist)
        for result in results[1:100:end]
            @test result.evaluate.(wordlist) == result.satisfied
        end
        r, _ = findmin(r for r in results if all(r.satisfied))
        r
    end

    # Set 1
    @test best_feature(["ample", "adenoid", "music", "fifa"]).description == "is a hill word"

    # Set 2
    @test best_feature(["peeped", "isseis", "fee", "acacia", "salsas", "arrear"]).description == "is a pyramid word"

    # Set 3
    @test best_feature(["skort", "sporty", "yolks", "peccadillo", "unknot", "rosy"]).description == "is a valley word"

    # Set 4
    @test best_feature(["testset", "lol", "tenet", "malayalam"]).description == "is a palindrome"

    # Set 5
    @test best_feature(["hitchhiker", "kaashoek", "jellystone", "kierkegaard", "metallica", "maastrict", "menschheit"]).description == "contains a double letter"

    # Set 6
    @test best_feature(["aime", "eye", "eerie", "riaa", "oahu", "oeis"]).description == "has 1 unique consonants"
end
