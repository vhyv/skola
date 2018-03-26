
# 4ST315 - 2. cvičení - samostatná práce - xhyvv00

##################################Příklad 1########################################
#Vytvořte vektor x o délce 12, který bude obsahovat čísla 1,1,1,8,8,9,9,9,9,20,20,20
x <- c(1,1,1,8,8,9,9,9,9,20,20,20)

#Z vektoru x odstraňte veškeré prvky, které jsou větší než 10 nebo menší než 2.
x <- x [!x > 10 & !x < 2]

# Následně vyberte prvky, které jsou celočíselně dělitelné 2.
x [x %% 2 == 0]

#Vytvořte vektor p. který bude aritmetickou posloupností s počáteční hodnotou 5, dif 3 a délkou 8.
p <- seq(from = 5, by = 3, length.out = 8)

#Vytvořtě nový vektor p2, který bude obsahovat první dva a poslední dva prvky vektoru p.
sranda <- c(length(p)-1,length(p)) #Předpokládáme neznámou délku vektoru p.
p[c(1:2, sranda)]

##################################Příklad 2########################################
#Vytvořte matici m o rozměrech 3 x 2, která bude obsahovat samé jedničky
m <- matrix(rep(1, 6), nrow = 3, ncol = 2)

#Změňte hodnoty druhého řádku této matice na hodnoty 15 a 2.
m[2,] <- c(15, 2)

#Změňte hodnoty druhého sloupce této matice na 11, 2, 4.
m[,2] <- c(11, 2, 4)

#Vypočítejte součet a průměr řádků matice s využitím funkce apply().
prumeryradku <- apply(X = m, MARGIN = 1, FUN = mean)
souctyradku <- apply(X = m, MARGIN = 1, FUN = sum)

#################################Příklad 3#########################################
#Vytvořte list l, který bude obsahovat následující prvky:
    #jméno 
    #krevní skupina
    #věk
l <- list("jméno" = c("Pavel", "Eliška", "Dan"),
          "krevni_skupina" = c("A", "B", "A"),
          "věk" = c(15, 25, 33))

#Do listu l přidejte nový prvek, který se bude jmenovat student a bude obsahovat hodnoty: T, F, F.
l$student <- c(T, F, F)

#Vyberte prvek věk a uložte jej jako vektor, který pojmenujte vek.
vek <- l$věk

#Z listu l odstraňte prvek student
l$student <- NULL

#################################Příklad 4##########################################
#Pročtěte si popis datového souboru mtcars, pomocí příkazu ?mtcars
?mtcars #ať splním všechny úkoly....

#Spočítejte očet záznamů v datovém souboru.
nrow(mtcars)

#Kolik aut v datovém souboru má alespoň 8 válců?
sum(mtcars$cyl >= 8) #TRUE = 1, FALSE = 0, všechny T hodnoty nám dají result (= 14).

#Které auto váží více než 4000 lbs a zároveň je schopné ujet více něž 16 mil na galon?
mtcars[mtcars$mpg >= 16 & mtcars$wt >= 4,] #vyplivne všechno info
#Případně pouze název auta:
rownames(mtcars[mtcars$mpg >= 16 & mtcars$wt >= 4,])

#Které z aut má nejvyšší zrychlení na 1/4 míle.
mtcars[mtcars$qsec == max(mtcars$qsec),]
#Nebo znova jen název auta:
rownames(mtcars[mtcars$qsec == max(mtcars$qsec),])

