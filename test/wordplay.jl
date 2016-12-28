# MIT Mystery Hunt 2013 puzzle Wordplay 
# http://www.mit.edu/~puzzle/2013/coinheist.com/get_smart/wordplay/index.html

@testset "wordplay" begin

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
