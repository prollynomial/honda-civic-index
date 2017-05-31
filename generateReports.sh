#/bin/bash
Rscript generatePlots.R output/mtl/civics.mtl.csv output/mtl/market.mtl.svg Montreal > /dev/null 2>&1
Rscript generatePlots.R output/tor/civics.tor.csv output/tor/market.tor.svg Toronto  > /dev/null 2>&1
Rscript generatePlots.R output/ott/civics.ott.csv output/ott/market.ott.svg Ottawa   > /dev/null 2>&1
Rscript generatePlots.R output/wpg/civics.wpg.csv output/wpg/market.wpg.svg Winnipeg > /dev/null 2>&1
Rscript generatePlots.R output/cgy/civics.cgy.csv output/cgy/market.cgy.svg Calgary  > /dev/null 2>&1
Rscript generatePlots.R output/edm/civics.edm.csv output/edm/market.edm.svg Edmonton > /dev/null 2>&1
