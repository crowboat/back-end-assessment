.mode csv

CREATE TABLE IF NOT EXISTS crop_harvest_plant_history (
    Attribute TEXT,
    Commodity TEXT,
    CommodityType TEXT,
    Units TEXT,
    YearType TEXT,
    Year TEXT,
    Value INTEGER
);

.import /home/node/app/build/db/csv/Projection2021.csv crop_harvest_plant_history
