civics <- read.csv('civics.csv')

# Filter out anything that Kijiji didn't filter.
civics.out <- civics[civics$make == 'honda' & civics$model == 'civic',]

# Keep kilometers as numerics.
civics.out$kms <- as.numeric(as.character(civics.out$kms))

# Throw away make and model, as they're now useless.
keeps <- c('price', 'year', 'kms', 'body')
civics.out <- civics.out[keeps]

# Add a huge penalty to scientific notation printing before generating CSV.
options(scipen=999)
write.csv(civics.out, 'civics.wpg.csv', row.names=FALSE)
