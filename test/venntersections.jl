@testset "ventersections" begin
    words = PuzzleTools.Wordsets.unixwords()[1:100:end];
    c = Collective.Corpus(words)
    @testset "diagram 1" begin
        @testset "set 1" begin
            list = ["lowered", "levitate", "inanimate", "paradise", "leveraged", "sizes", "tuxedo"]
            r, _ = findmin(Collective.analyze(c, list))
            @test r.feature == Collective.AlternatesConsonantVowel()
        end

        @testset "set 2" begin
            list = ["leveraged", "sizes", "tuxedo", "lynx", "lightly", "crocodile", "triumph"]
            r, _ = findmin(Collective.analyze(c, list))
            @test r.feature == Collective.ScrabbleScore(14)
        end

        @testset "set 3" begin
            list = ["lowered", "levitate", "leveraged", "lynx", "lightly", "lengths", "legislator"]
            r, _ = findmin(Collective.analyze(c, list))
            @test r.feature == Collective.LetterAtIndex('l', 1)
        end
    end

    @testset "diagram 2" begin
        @testset "set 2" begin
            list = ["grimaced", "formally", "questionable", "discouraged", "communicated", "chrysalis", "saccharin"]
            r, _ = findmin(Collective.analyze(c, list))
            @test r.feature == Collective.LetterAtIndexFromEnd('a', 4)
        end
    end
end
