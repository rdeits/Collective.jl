# MIT Mystery Hunt 2014 puzzle Venntersections
# http://www.mit.edu/~puzzle/2014/puzzle/venntersections/

@testset "ventersections" begin

    @testset "diagram 1" begin
        # Set 1
        f1 = best_feature(["lowered", "levitate", "inanimate", "paradise", "leveraged", "sizes", "tuxedo"])
        @test f1.description == "alternates consonant vowel"

        # Set 2
        f2 = best_feature(["leveraged", "sizes", "tuxedo", "lynx", "lightly", "crocodile", "triumph"]) 
        @test f2.description == "has scrabble score 14"

        # Set 3
        f3 = best_feature(["lowered", "levitate", "leveraged", "lynx", "lightly", "lengths", "legislator"])
        @test f3.description == "contains 'l' at index 1"

        # Set 4
        f4 = best_feature(["levitate", "inanimate", "sizes", "lightly", "crocodile", "legislator", "carousels"])
        @test f4.description== "contains a repeated consonant"

        # Intersection
        checks = (f1, f2, f3, f4, word -> length(word) == 9)
        for word in words
            if all(c(word) for c in checks)
                @test word == "lakesides"
                break
            end
        end

    end

    @testset "diagram 2" begin
        # Set 2
        f2 = best_feature(["questionable", "businesswoman", "exhaustion", "discouraged", "communicated", "hallucinogen", "sequoia"])
        @test f2.description == "has 5 unique vowels"

        # Set 3
        f3 = best_feature(["grimaced", "formally", "questionable", "discouraged", "communicated", "chrysalis", "saccharin"])
        @test f3.description == "contains 'a' at index 4 from end"

        # Set 4
        f4 = best_feature(["formally", "thinnest", "businesswoman", "communicated", "hallucinogen", "saccharin", "cellophane"])
        @test f4.description == "contains a double letter"
    end

    @testset "diagram 3" begin
        # Set 1
        f1 = best_feature(["thumbtacks", "monologue", "frigidities", "statuesque", "testimony", "satirizing", "flawed"])
        @test f1.description == "contains a day of the week abbreviation"

        # Set 3
        f3 = best_feature(["thumbtacks", "monologue", "testimony", "camel", "meteorology", "trampoline", "achievement"])
        @test f3.description == "contains 'm'"
    end

    @testset "diagram 4" begin
        # Set 3
        f3 = best_feature(["philharmonic", "mischievous", "leeching", "loophole", "toothpaste", "alcoholic", "narwhal"])
        @test f3.description == "contains 'h' at index 5"
    end
end
