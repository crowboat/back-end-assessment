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

-- Import data from CSV into the table
.import /home/node/app/build/db/csv/Projection2021.csv crop_harvest_plant_history
