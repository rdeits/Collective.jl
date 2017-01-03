# http://web.mit.edu/puzzle/www/2012/puzzles/phantom_of_the_operator/solution/
@testset "phantom of the operator meta" begin
    f = best_feature(wordlist(IOBuffer("""
        FIRESTONE
        CLINTON
        UNION
        MERCURY
        PERSHING
        CHERRY
        VALLEY
        VIKING
        TERMINAL
        """)))
    @test f.description == "is a Ma Bell recommended telephone exchange name"
end
