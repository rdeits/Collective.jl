# http://web.mit.edu/puzzle/www/2012/puzzles/okla_holmes_a/solution/

@testset "okla holmes-a meta" begin
    puzzle = wordlist(IOBuffer("""
        CARPAL
        THE SOUTH
        STERNO
        BYLINE
        SO CLOSE
        BUFFOON
        VESTIGE 
        """))
    f = best_feature(puzzle)
    @test f.description == "can be completely broken down into chemical element symbols"
end
