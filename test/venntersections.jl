@testset "ventersections" begin
    words = lowercase.(strip.(split(readstring("/usr/share/dict/words"))))[1:100:end]
    words = [replace(word, r"[^a-z]", "") for word in words]
    c = Collective.Corpus(words)

    function best_feature(list)
        r, _ = findmin(Collective.analyze(c, list))
        r.description
    end

    @testset "diagram 1" begin
        # Set 1
        @test best_feature(["lowered", "levitate", "inanimate", "paradise", "leveraged", "sizes", "tuxedo"]) == "alternates consonant vowel"

        # Set 2
        @test best_feature(["leveraged", "sizes", "tuxedo", "lynx", "lightly", "crocodile", "triumph"]) == "scrabble score 14"

        # Set 3
        @test best_feature(["lowered", "levitate", "leveraged", "lynx", "lightly", "lengths", "legislator"]) == "contains l at index 1"
    end

    @testset "diagram 2" begin
        # Set 2
        @test best_feature(["questionable", "businesswoman", "exhaustion", "discouraged", "communicated", "hallucinogen", "sequoia"]) == "5 unique vowels"

        # Set 3
        @test best_feature(["grimaced", "formally", "questionable", "discouraged", "communicated", "chrysalis", "saccharin"]) == "contains a at index 4 from end"
    end

    @testset "diagram 3" begin
        # Set 3
        @test best_feature(["thumbtacks", "monologue", "testimony", "camel", "meteorology", "trampoline", "achievement"]) == "contains m"
    end

    @testset "diagram 4" begin
        # Set 3
        @test best_feature(["philharmonic", "mischievous", "leeching", "loophole", "toothpaste", "alcoholic", "narwhal"]) == "contains h at index 5"
    end
end
