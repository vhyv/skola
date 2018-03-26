######################################## Uloha 1 #################################
#Nactete do R data ze souboru baltimor_salary.xlsx
library(openxlsx)
baltimor <- read.xlsx (xlsxFile = "baltimor_salary.xlsx", sheet = "data", startRow = 1, colNames = T )

#Zjistete dimenzionalitu datove matice.
dim(baltimor) #63954 radku, 8 sloupcu

#Prozkoumejte nactena data, jestli neobsahuji chybejici pozorovani.
sum(rowSums(is.na(baltimor) == T)) #9 radku obsahuje chybejici pozorovani
sum(rowSums(is.na(baltimor) > 1)) #Zadny radek neobsahuje vice nez jedno chybejici pozorovani.

#Zobrazte si hlavicku datoveho soubotu a zamyslete se nad vyznamem jednotlivych sloupcu.
head(baltimor)
#Jedna se o jakysi seznam (statnich?) zamestnancu z Baltimoru (Maryland) nebo Connecticutu?
#Data obsahuji jmena a prijmeni jednotlivych zamestnancu, jejich zamestnavatele, oddeleni, titul a platove informace.

######################################### Uloha 2 ####################################
#Promenna AMOUNT - charakteristiky.

#Prumer
mean(baltimor$AMOUNT, na.rm = T)
#Trimovany prumer pro p = 0.1
mean(baltimor$AMOUNT, na.rm = T, trim = 0.1)
#Vyberove kvartily
summary(baltimor$AMOUNT) #Vycteme
quantile(baltimor$AMOUNT, c(0.25, 0.5, 0.75), na.rm = T, type = 1) #Trochu sofistikovanejsi postup
#Variancni koeficient
VarKoef <- function(x, na.rm = F) {
    if (na.rm)
    x = na.omit(x)
    return(sd(x)/mean(x))
}
VarKoef(baltimor$AMOUNT) *100
#Nasel jsem fci coefficient.variation z verze R asi 0.6, ale v novejsich verzich uz zrejme neni dostupna.

#Sikmost
install.packages("moments")
moments::skewness(baltimor$AMOUNT)
#Spicatost
moments::kurtosis(baltimor$AMOUNT)

####################################### Uloha 3 ################################
#Pomoci vhodneho pravidla naleznete odlehla pozorovani.

#Po kompletnim odstraneni vetsiny vysokych hodnot vidime z histogramu,
#ze pravdepodobnostni rozdeleni zbyvajicich hodnot rozhodne neni normalni. Je zde velka sikmost.
hist(baltimor$AMOUNT[baltimor$AMOUNT < 200000])

#Promenna nema normalni rozdeleni, a proto pouzijeme robustni pravidlo.
#Ve jmenovateli jsem pouzil jednoduse MAD, namisto MADN, 
#jelikoz jsem nedokazal najit, jak se presne pouziva dana konstanta pro jednotliva rozdeleni.
extremy <- (baltimor$AMOUNT - mean(baltimor$AMOUNT, na.rm = T))/mad(baltimor$AMOUNT, constant = 1)
length(baltimor$AMOUNT[extremy >= 3]) #Extremnich hodnot je 2616

#Pokud bychom pouzili klasicke pravidlo 3 sigma, extremnich hodnot by bylo vyrazne mene - 513
length(baltimor$AMOUNT[(baltimor$AMOUNT - mean(baltimor$AMOUNT, na.rm = T))/sd(baltimor$AMOUNT) >= 3])

#Extremne vysokymi hodnotami budou silne ovlivneny tyto statistiky:
    #Prumer
    #Zmeni se i smerodatna odchylka a tim padem take variancni koeficient, ale je tezke urcit, jak moc.
    #Zmena meanu primo ovlivni velikost sikmosti dane promenne.
    #Extremni hodnoty samotne pak ovlivnuji spicatost dane promenne.