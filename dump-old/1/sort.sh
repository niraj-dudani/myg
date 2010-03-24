sed -i 's:CaPool:Ca_conc:' caconc-xml.csv
sed -i 's:Conductance::' channel-xml.csv

sort caconc-genesis.csv -o caconc-genesis.csv
sort caconc-xml.csv -o caconc-xml.csv
sort channel-genesis.csv -o channel-genesis.csv
sort channel-xml.csv -o channel-xml.csv
sort compartment-genesis.csv -o compartment-genesis.csv
sort compartment-xml.csv -o compartment-xml.csv

diff compartment*
diff channel*
diff caconc*
