# http://web.mit.edu/puzzle/www/2013/coinheist.com/rubik/substance_abuse/index.html
@testset "substance abuse" begin
    f = best_feature(wordlist("""
            KBNSCSICRBNA
            PSICAFCRLIO
            CRLISCNCA
            LIKBBECALI
            NCABPARNSCBNA
            CABNEHBKNSCHESCP
            BCSIOCLNCBNA
            NEHBNATIHEBCASLIO
            BHESIPOSIPNCSICA
            SINASCNCLI
            NNALISCSICLI
            NAARCASIOSIMGSIOCR
            NEHNOSCAL
            NCRCRSICBN
            NASIOHCKHCR
            CAFLI
            PBSCNAARBECALICKLI
            NANPHENBNABC
            SCARFCRSICA
            HELIOSISCSICBC
            PHEBCASINAFBEBC
            LINAHESCNHEF
            SNCBCACABC
        """), 5)
    @test f.description == "can be completely broken down into chemical element symbols"
end
