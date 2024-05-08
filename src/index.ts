import express from 'express';
import sqlite3, { Database } from 'sqlite3';

enum ColumnName {
  Attribute = 'Attribute',
  Commodity = 'Commodity',
  CommodityType = 'CommodityType',
  Units = 'Units',
  YearType = 'YearType',
  Year = 'Year',
  Value = 'Value',
}

interface Row {
  columnValue: ColumnName;
  count: number;
}

const app = express();
const dbPath = __dirname + '/db/Projection2021.db';
const db: Database = new sqlite3.Database(dbPath);

app.get('/:columnName/histogram', (req, res) => {
  const columnName =
    ColumnName[req.params.columnName.toString() as keyof typeof ColumnName];

  // Construct the SQL query to get histogram data for the specified column
  const sql = `SELECT $columnName as columnValue, COUNT(*) AS count FROM crop_harvest_plant_history GROUP BY $columnName`;

  // Prepare HTML response
  let htmlResponse = '<h1>Histogram</h1>';
  htmlResponse += `<table border="1"><tr><th>${columnName}</th><th>Count</th></tr>`;

  // Execute the query for each row individually
  db.each(
    sql,
    { $columnName: columnName },
    (err: Error, row: Row) => {
      if (err) {
        res.status(500).send(err.message);
        return;
      }
      if (row.columnValue === columnName) return;
      // Add row data to the HTML response
      htmlResponse += `<tr><td>${row.columnValue}</td><td>${row.count}</td></tr>`;
    },
    () => {
      // After all rows have been processed, close the HTML table and send the response
      htmlResponse += '</table>';
      res.send(htmlResponse);
    }
  );
});

// Start the server
app.listen(4000, () => {
  console.log(`Server is running!`);
});
