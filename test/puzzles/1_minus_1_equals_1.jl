# http://web.mit.edu/puzzle/www/2007/puzzles/1_1_1/
@testset "1-1=1" begin
    f = best_feature(wordlist(IOBuffer("""
        STRIFE
        SEAMAN
        NIX
        ETCH
        POST
        QUEERART
        FOO
        TALKS
        REPAYS
        STU
        HUMF
        UNDERHID
        SIXTEENS
        BOWMEN
        """)), 1)
    @test f.description == "has a 1-letter transdeletion"
end
