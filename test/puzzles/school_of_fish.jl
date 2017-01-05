# http://web.mit.edu/puzzle/www/2015/puzzle/school_of_fish_meta/
@testset "school of fish meta" begin
    f = best_feature(wordlist(IOBuffer("""
        cred
        ruble
        marble
        lodge
        regent
        barfed
        boone
        lunge
        toughen
        freeing
        ahead
        stolen
        mice
        elite
        rambles
        octal
        crook
        sedan
        amadeus
        dangle
        boucher
        clanlaird
        crasher
        eking
        dylan
        sturgeon
        wraps
        stooge
        rotorset
        ankles
        coloredice
        raptors
        spare net
        sick porno
        hawke
        limon
        taco
        tuba
        others
        triage
        heartpin
        rant
        blazer
        isabel
        baron
        paws
        opera
        internal
        pikers
        soaped
        draft
        papers
        serbia
        crowds
        cleaned
        piper
        """)), 10)
    @test f.description == "has a 1-letter transdeletion"
end