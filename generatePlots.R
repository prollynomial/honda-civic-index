civics <- read.csv('output/edm/civics.edm.csv')
options(scipen=999)

svg('market.edm.svg')

par(mfrow=c(3, 2), oma=c(0,0,5,0))

# Quick facts
plot(c(0, 1), c(0, 1), ann=F, bty='n', type='n', xaxt='n', yaxt='n')

formatPrice <- function (price) {
	format(price, format="f", big.mark=",", digits=2)
}

info <- paste0("Volume: ", nrow(civics),
			"\nCap: $", formatPrice(sum(civics$price, na.rm=T)),
			"\nReference Civic 2005: $",
				formatPrice(mean(civics[civics$year == 2005 & civics$kms >= 225000 & civics$kms <= 275000, c('price')], na.rm=T)),
			"\nReference Civic 2010: $",
				formatPrice(mean(civics[civics$year == 2010 & civics$kms >= 125000 & civics$kms <= 175000, c('price')], na.rm=T)),
			"\nReference Civic 2015: $",
				formatPrice(mean(civics[civics$year == 2015 & civics$kms >= 25000 & civics$kms <= 75000, c('price')], na.rm=T)))

text(x=0.5, y=0.5, info, cex=1.5, col="black")

# Price distribution
civics <- civics[civics$price <= 30000, ]
hist(civics$price, probability=T, xlim=c(0, 30000), breaks=seq(0, 30000, 1000), col="gray", border="white", main="Price distribution")
d <- density(civics$price, na.rm=T)
lines(d, col="red")

# Year distribution (Sorry Calgary, nothing before 1990.)
civics <- civics[civics$year >= 1990, ]
hist(civics$year, probability=T, xlim=c(1990, 2020), breaks=seq(1990, 2020, 1), col="gray", border="white", main="Model year distribution")
d <- density(civics$year, na.rm=T)
lines(d, col="red")

# KMs distribution
civics <- civics[civics$kms <= 400000, ]
hist(civics$kms, probability=T, xlim=c(0, 400000), breaks=seq(0, 400000, 10000), col="gray", border="white", main="KMs distribution")
d <- density(civics$kms, na.rm=T)
lines(d, col="red")

# Price as a function of year
plot(price ~ year, data=civics, xlim=c(1990, 2020), col="gray", border="white")
title("Price as a function of model year")

# Price as a function of kms
plot(price ~ kms, data=civics, xlim=c(0, 400000), col="gray", border="white")
title("Price as a function of kilometers")

title("Honda Civic Index - Edmonton", outer=T, cex.main="1.8")

dev.off()
