@testset "ventersections" begin
    words = PuzzleTools.Wordsets.unixwords()[1:100:end];
    c = Collective.Corpus(words)

    function best_feature(list)
        r, _ = findmin(Collective.analyze(c, list))
        r.feature
    end

    @testset "diagram 1" begin
        # Set 1
        @test best_feature(["lowered", "levitate", "inanimate", "paradise", "leveraged", "sizes", "tuxedo"]) == Collective.AlternatesConsonantVowel()

        # Set 2
        @test best_feature(["leveraged", "sizes", "tuxedo", "lynx", "lightly", "crocodile", "triumph"]) == Collective.ScrabbleScore(14)

        # Set 3
        @test best_feature(["lowered", "levitate", "leveraged", "lynx", "lightly", "lengths", "legislator"]) == Collective.LetterAtIndex('l', 1)
    end

    @testset "diagram 2" begin
        # Set 2
        @test best_feature(["questionable", "businesswoman", "exhaustion", "discouraged", "communicated", "hallucinogen", "sequoia"]) == Collective.NumUniqueVowels(5)

        # Set 3
        @test best_feature(["grimaced", "formally", "questionable", "discouraged", "communicated", "chrysalis", "saccharin"]) == Collective.LetterAtIndexFromEnd('a', 4)
    end

    @testset "diagram 3" begin
        # Set 3
        @test best_feature(["thumbtacks", "monologue", "testimony", "camel", "meteorology", "trampoline", "achievement"]) == Collective.ContainsLetter('m')
    end

    @testset "diagram 4" begin
        # Set 3
        @test best_feature(["philharmonic", "mischievous", "leeching", "loophole", "toothpaste", "alcoholic", "narwhal"]) == Collective.LetterAtIndex('h', 5)
    end
end
